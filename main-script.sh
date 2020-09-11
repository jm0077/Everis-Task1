#!/bin/bash

echo $HOSTNAME > hostname.txt

export PROJECT_ID="everis1"
export REGION="us-central1"
export BUCKET_PREFIX="terraform-state-gke"
export SERVICEACCOUNT="gcpcmdlineuser@everis1.iam.gserviceaccount.com"
export CREDENTIALS="gcpcmdlineuser.json"
export DOCKER_IMAGE="app"
export HELM_CHART="appchart"

function CREATE()
{
echo "It is CREATE"
now="$(date +%s)"
#echo "$now"
#echo "$PROJECT_ID"
#Make bucket to store Terraform state
gsutil mb -p $PROJECT_ID -c regional -l $REGION gs://$BUCKET_PREFIX-$now
#Activate object versioning to allow for state recovery
gsutil versioning set on gs://$BUCKET_PREFIX-$now
#Grant read/write permissions on this bucket to our service account
gsutil iam ch serviceAccount:$SERVICEACCOUNT:legacyBucketWriter gs://$BUCKET_PREFIX-$now



#Configure Terraform to use the bucket to store the state

echo "terraform {
  backend \"gcs\" {
    credentials = \"./$CREDENTIALS\"
    bucket      = \"$BUCKET_PREFIX-$now\"
    prefix      = \"terraform/state\"
  }
}" > terraform.tf

terraform init

echo "-----------------------FINISH INIT"

terraform plan

echo "-----------------------FINISH PLAN"

terraform apply

echo "-----------------------FINISH APPLY"

#Configure the kubectl command line tool to connect to it with
gcloud container clusters get-credentials gke-cluster --region $REGION

echo "---
replicaCount: 1

image:
  repository: gcr.io/$PROJECT_ID/$DOCKER_IMAGE
  pullPolicy: Always

service:
  type: LoadBalancer
  port: 80

app_port: 8080" > Helm/values.yaml

#Allow the tiller pod to create resources in the cluster
cd Helm/
kubectl apply -f tiller.yaml

#Build the docker image
cd ..
gcloud builds submit --tag gcr.io/$PROJECT_ID/$DOCKER_IMAGE

#deploy our chart 
cd Helm/
#helm install . -f ./values.yaml $HELM_CHART
helm install -f ./values.yaml $HELM_CHART .

} # End of CREATE function

function DESTROY()
{    
echo "It is DESTROY"
cd ~
cd Helm/
helm uninstall $HELM_CHART
cd ..
terraform destroy
cd .terraform
rm terraform.tfstate
gcloud container images delete gcr.io/$PROJECT_ID/$DOCKER_IMAGE
gsutil rm -r gs://$BUCKET_PREFIX*
gsutil rm -r gs://artifacts*
gsutil rm -r gs://$PROJECT_ID*
} # End of DESTROY function

function OUTPUT()
{    
echo "It is OUTPUT"
echo "Clusters list"
gcloud container clusters list
echo "Services running"
kubectl get service
} # End of OUTPUT function

gcloud config set project $PROJECT_ID

if [ "$1" == "CREATE" ];
then
CREATE
elif  [ "$1" == "DESTROY" ];
then
DESTROY
elif  [ "$1" == "OUTPUT" ];
then
OUTPUT
else
echo "Sorry, no valid argument. Valid arguments are: CREATE, DESTROY and OUTPUT" 
fi


# Everis-Task1
Everis-Task1
TASK 1:
 
Crear un script bash o makefile, que acepte parámetros (CREATE, DESTROY y OUTPUT) con los siguientes pasos:
 
Exportar las variables necesarias para crear recursos en GCP (utilizar las credenciales previamente descargadas).
 
Utilizar terraform o pulumi para crear un Cluster de Kubernetes de un solo nodo (GKE).
 
Instalar ingress controller en el Cluster de k8s.
 
Crear una imagen docker para desplegar una aplicación tipo RESTFUL API, basada en python que responda a siguientes dos recursos:
 
/greetings: message —> “Hello World from $HOSTNAME”.
/square: message —>  number: X, square: Y, donde Y es el cuadrado de X. Se espera un response con el cuadrado.
Subir la imagen el registry propio del proyecto gcp ej: gcr.io/$MYPROJECT/mypythonapp.
 
Desplegar la imagen con los objetos mínimos necesarios (no utilizar pods ni replicasets directamente).
El servicio debe poder ser consumido públicamente.
 
NOTA: variabilizar todos los campos que lo ameritan, por ejemplo el PROJECT, para que el script pueda ser ejecutado por otra persona con otra cuenta GCP.

terraform {
  backend "gcs" {
    credentials = "./gcpcmdlineuser.json"
    bucket      = "terraform-state-gke-1599856082"
    prefix      = "terraform/state"
  }
}

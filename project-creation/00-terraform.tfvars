project_name     = "cloud-build-poc"
region           = "us-central1"
labels = {
  "environment" = "test"
}
gcp_service_list = [
  "cloudbuild.googleapis.com",
  "run.googleapis.com"
]

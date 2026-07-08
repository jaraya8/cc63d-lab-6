# Infraestructura como código del monolito (Lab 7 · Parte 3).
#
# Describe el estado deseado y Terraform lo reconcilia: declara el repositorio de
# Artifact Registry y el servicio de Cloud Run. Los nombres llevan sufijo "-tf"
# para no colisionar con los recursos creados a mano en las Partes 1 y 2.

terraform {
  required_version = ">= 1.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Imagen ya publicada en el repo "monolito" (Partes 1/2). Terraform provisiona la
# infraestructura; las imágenes las produce el pipeline. Por eso el servicio
# reutiliza una imagen existente en lugar de una del repo que crea Terraform.
locals {
  image = "${var.region}-docker.pkg.dev/${var.project_id}/monolito/incidentes:${var.image_tag}"
}

# Repositorio de Artifact Registry gestionado por Terraform.
resource "google_artifact_registry_repository" "monolito_tf" {
  repository_id = "monolito-tf"
  location      = var.region
  format        = "DOCKER"
  description   = "Repositorio del monolito de incidentes (gestionado por Terraform)."
}

# Servicio de Cloud Run del monolito.
resource "google_cloud_run_v2_service" "incidentes_tf" {
  name     = "incidentes-tf"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = local.image
      ports {
        container_port = 8080
      }
    }
  }
}

# Acceso público: cualquiera puede invocar el servicio (equivale a
# --allow-unauthenticated del despliegue manual).
resource "google_cloud_run_v2_service_iam_member" "public" {
  location = google_cloud_run_v2_service.incidentes_tf.location
  name     = google_cloud_run_v2_service.incidentes_tf.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

variable "project_id" {
  description = "ID del proyecto de GCP."
  type        = string
  default     = "project-eb38a6a1-0732-4b8e-8e3"
}

variable "region" {
  description = "Región de despliegue."
  type        = string
  default     = "southamerica-west1"
}

variable "image_tag" {
  description = "Tag de la imagen ya publicada en el repo 'monolito' (Partes 1/2)."
  type        = string
  default     = "v1"
}

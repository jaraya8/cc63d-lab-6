output "service_url" {
  description = "URL pública del servicio de Cloud Run gestionado por Terraform."
  value       = google_cloud_run_v2_service.incidentes_tf.uri
}

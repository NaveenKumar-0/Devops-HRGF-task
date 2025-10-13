output "ingress_service" {
  value = helm_release.nginx_ingress.status
}


output "kube_generated_dns_prefix" {
  value       = azurerm_kubernetes_cluster.aks.dns_prefix
  sensitive   = false
  description = "dns prefix"
}

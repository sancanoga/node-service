output "public_ip_address" {
  description = "The actual load balancer ip address allocated for the resource."
  value       = digitalocean_loadbalancer.devops_test.ip
}
# Outputs for the Rearc Server and ALB

# Output Rearc Server Public IP
output "instance_public_ip" {
  value = aws_instance.rearc_server.public_ip
}
# Output ALB DNS
output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value = aws_lb.rearc_alb.dns_name
} 
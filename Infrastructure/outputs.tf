output "ip-load-balancer-private-ip" {
  value = aws_instance.load-balancer.private_ip
}
output "ip-load-balancer-public-ip" {
  value = aws_instance.load-balancer.public_ip
}
output "ip-nginx1-private-ip" {
  value = aws_instance.nginx1.private_ip
}
output "ip-nginx1-public-ip" {
  value = aws_instance.nginx1.public_ip
}
output "ip-nginx2-private-ip" {
  value = aws_instance.nginx2.private_ip
}
output "ip-nginx2-public-ip" {
  value = aws_instance.nginx2.public_ip
}
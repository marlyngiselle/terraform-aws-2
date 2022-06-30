output "infra_publica_IPs_PUBLICA" { value = module.ec2_infra_publica[*].la_ip_publica }
output "infra_publica_IPs_PRIVADA" { value = module.ec2_infra_publica[*].la_ip_privada }

# output "infra_privada_IPs_PRIVADA" { value = module.ec2_infra_privada[*].la_ip_privada }

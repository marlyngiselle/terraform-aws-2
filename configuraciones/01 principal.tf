module "subred_publica" {
  source = "../modulos/subred"
  TIPO_RED = "publica"
  LETRA_AZ = "a"
  LA_VPC = aws_vpc.mi_vpc.id
  BLOQUE_SUBRED_CIDR = var.BLOQUE_CIDR_SUBRED_PUBLIC
  PROYECTO = var.NOMBRE_PROYECTO
  MAPA_TRES_AV_ZONES = var.AV_ZONES

}

module "subred_privada" {
  source = "../modulos/subred"
  TIPO_RED = "privada"
  LETRA_AZ = "c"
  LA_VPC = aws_vpc.mi_vpc.id
  BLOQUE_SUBRED_CIDR = var.BLOQUE_CIDR_SUBRED_PRIVATE
  PROYECTO = var.NOMBRE_PROYECTO
  MAPA_TRES_AV_ZONES = var.AV_ZONES

}

module "ec2_infra_publica" {
  source                  = "../modulos/ec2"
  count                   = 5
   NUMERO                 = count.index
  NOMBRE_PROYECTO         = var.NOMBRE_PROYECTO
  LISTA_NOMBRE_SERVIDORES = ["jenkins-master", "jenkins-agent1", "jenkins-agente2" , "docker" , "grafana" ]
  TIPO_INSTANCIA          = "t2.micro"
  TIPO_RED                = "public"
  ID_SUBRED               = module.subred_publica.id_de_la_subred
  IP_SERVIDOR_GUARDIAN    = "10.0.150.1${count.index}"
  IMAGEN_OS               = data.aws_ami.os_ubuntu.id
  IDS_SEC_GROUPS          = [aws_security_group.firewall_instancia.id]
  LLAVE_SSH_PUBLICA       = aws_key_pair.llave-ssh-neo.key_name
  
}

module "vm_registry" {
  source                  = "../modulos/ec2"
  count                   = 1
   NUMERO                 = count.index
  NOMBRE_PROYECTO         = var.NOMBRE_PROYECTO
  LISTA_NOMBRE_SERVIDORES = ["registry" ]
  TIPO_INSTANCIA          = "t2.large"
  TIPO_RED                = "public"
  ID_SUBRED               = module.subred_publica.id_de_la_subred
  IP_SERVIDOR_GUARDIAN    = "10.0.150.2${count.index}"
  IMAGEN_OS               = data.aws_ami.os_ubuntu.id
  IDS_SEC_GROUPS          = [aws_security_group.firewall_instancia.id]
  LLAVE_SSH_PUBLICA       = aws_key_pair.llave-ssh-neo.key_name
  
}

# module "ec2_infra_privada" {          
#   source                  = "../modulos/ec2"
#   count                   = 10
#    NUMERO                 = count.index
#   NOMBRE_PROYECTO         = var.NOMBRE_PROYECTO
#   LISTA_NOMBRE_SERVIDORES = ["uno", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez" ]
#   TIPO_INSTANCIA          = "t2.micro"
#   TIPO_RED                = "privada"
#   ID_SUBRED               = module.subred_privada.id_de_la_subred
#   IP_SERVIDOR_GUARDIAN    = "10.0.0.1${count.index}"
#   IMAGEN_OS               = data.aws_ami.os_ubuntu.id
#   IDS_SEC_GROUPS          = [aws_security_group.firewall_instancia.id]
#   LLAVE_SSH_PUBLICA       = aws_key_pair.llave-ssh-neo.key_name
  
# }






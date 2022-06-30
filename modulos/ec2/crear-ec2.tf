variable "NOMBRE_PROYECTO" {}
variable "TIPO_INSTANCIA" {}
variable "IP_SERVIDOR_GUARDIAN" {}
variable "IMAGEN_OS" {}
variable "ID_SUBRED" {}
variable "IDS_SEC_GROUPS" {
  type    = list
  default = []
}
variable "LLAVE_SSH_PUBLICA" {}
variable "NUMERO" {}
variable "LISTA_NOMBRE_SERVIDORES"{
  type = list
  default = []
}

variable "TIPO_RED" {}


data "template_file" "mi_bootstrap" {
  template = <<-EOF
                #!/bin/bash
                sudo hostnamectl set-hostname ${var.LISTA_NOMBRE_SERVIDORES[var.NUMERO]}

                sudo timedatectl set-timezone Europe/Paris

                sudo sed -i 's/^%sudo.*/%sudo   ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers

                sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
                sudo sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
                sudo systemctl restart sshd 

                USUARIO=ansible
                CONTRASENA=123
                sudo useradd -m -s /bin/bash -G sudo $USUARIO
                echo "$USUARIO:$CONTRASENA" | sudo chpasswd

                sudo touch /etc/sudoers.d/$USUARIO
                sudo chmod 440 /etc/sudoers.d/$USUARIO
                echo "$USUARIO ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$USUARIO

                sudo mkdir -p /home/$USUARIO/.ssh
                sudo chmod 700 /home/$USUARIO/.ssh
                sudo chown $USUARIO:$USUARIO /home/$USUARIO/.ssh/

                sudo touch /home/$USUARIO/.ssh/authorized_keys
                sudo chmod 644 /home/$USUARIO/.ssh/authorized_keys
                sudo chown $USUARIO:$USUARIO /home/$USUARIO/.ssh/authorized_keys
                echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcIqesf51uFB2a9tqLpJi70sNW7O9rBDTgBX8WWnMNN Ansible" | sudo tee -a /home/$USUARIO/.ssh/authorized_keys

                sudo apt update -y && sudo apt upgrade -y 

                sudo reboot
              EOF
}

resource "aws_instance" "mi_vm" {
  tags                   = {Name = "vm-${var.LISTA_NOMBRE_SERVIDORES[var.NUMERO]}-${var.NOMBRE_PROYECTO}-${var.NUMERO+1}" }
  ami                    = var.IMAGEN_OS
  instance_type          = var.TIPO_INSTANCIA
  subnet_id              = var.ID_SUBRED
  vpc_security_group_ids = var.IDS_SEC_GROUPS
  key_name               = var.LLAVE_SSH_PUBLICA
  private_ip             = var.IP_SERVIDOR_GUARDIAN
  user_data              = "${data.template_file.mi_bootstrap.rendered}"

  root_block_device {
    volume_size = 30 # in GB
    volume_type = "gp3"
    encrypted   = false
    delete_on_termination = true
  }

}

output "la_ip_publica" {
  value = aws_instance.mi_vm.public_ip 
}

output "la_ip_privada" {
  value = aws_instance.mi_vm.private_ip 
}
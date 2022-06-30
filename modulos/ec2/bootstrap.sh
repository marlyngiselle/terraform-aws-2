#!/bin/bash
NOMBRE_SERVIDOR=pepito
sudo hostnamectl set-hostname $NOMBRE_SERVIDOR

sudo timedatectl set-timezone Europe/Paris

sudo sed -i 's/^%sudo.*/%sudo   ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers

sudo sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PubkeyAuthentication.*/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo mkdir -p /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh
sudo chown ansible:ansible /home/ansible/.ssh/

sudo touch /home/ansible/.ssh/authorized_keys
sudo chmod 644 /home/ansible/.ssh/authorized_keys
sudo chown ansible:ansible /home/ansible/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJcIqesf51uFB2a9tqLpJi70sNW7O9rBDTgBX8WWnMNN Ansible" | sudo tee -a /home/ansible/.ssh/authorized_keys 


USUARIO=ansible
CONTRASENA=123
sudo useradd -m -s /bin/bash -G sudo $USUARIO
echo "$USUARIO:$CONTRASENA" | sudo chpasswd

sudo touch /etc/sudoers.d/$USUARIO
sudo chmod 440 /etc/sudoers.d/$USUARIO
echo "$USUARIO ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USUARIO

sudo apt update -y && sudo apt upgrade -y 
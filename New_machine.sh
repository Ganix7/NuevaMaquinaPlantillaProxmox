#!/bin/bash
#UTF-8

RESET="\e[0m"
RED="\e[31m"
BLUE="\e[34m"
GREEN='\033[0;32m'
UYELLOW='\033[4;33m'

if [[ $EUID -ne 0 ]]; then
		echo -e "${RED}Esto debe ejecutarse como "${UYELLOW}root${RESET}"${RED}...${RESET}" 
   exit 1
fi

#Configura ssh e id de la maquina nueva
rm -f /var/lib/dbus/machine-id 2>/dev/null
rm -f /etc/machine-id 2>/dev/null
dbus-uuidgen --ensure=/etc/machine-id 2>/dev/null
ln -s /etc/machine-id /var/lib/dbus/ 2>/dev/null
ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa -y && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa -y 2>/dev/null
ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521 -y 2>/dev/null
sudo touch /etc/cloud/cloud-init.disabled 2>/dev/null
#Configura el hostname de la maquina
read -p "Inserta el hostname de la maquina:" hostnamevar
read -p "Inserta el nombre de la plantilla:"  plantillavar
echo -e "El hostname de la maquina sera" "${RED}$hostnamevar${RESET}" "y el nombre de la plantilla es" "${BLUE}$plantillavar${RESET}"
echo
	read -p "Presiona enter para continuar..." -n 1 -r
echo
	if [[ ! $REPLY =~ ^[Yy]$ ]]
	then
		sed -i 's/$plantillavar/$hostnamevar/g' /etc/hosts
		sed -i 's/$plantillavar/$hostnamevar/g' /etc/hostname
		hostnamectl set-hostname $hostnamevar
		echo -e "${GREEN}Se configuro correctamente el hostname como $hostnamevar"
	fi


#!/bin/bash
COLOR_REST='\e[0m'
COLOR_GREEN='\e[0;32m';
COLOR_RED='\e[0;31m';
COLOR_YELLOW='\033[1;93m'


mkdir=${mkdir -p}
Bk_conf=$(cp /etc/samba/smb.conf /etc/samba/smb.conf.bak 2> /dev/null)
Samba_Conf_Path=$(/etc/samba/smb 2> /dev/null)
Samba_Conf_File=$(/etc/samba/smb.conf 2> /dev/null)
conf_file (){
conf="[global]
    dos charset = cp950
    netbios name = ${BIOS_NAME}
    server string = %h server (Samba, Ubuntu)
    server role = standalone server
    map to guest = Bad User
    obey pam restrictions = Yes
    pam password change = Yes
    passwd program = /usr/bin/passwd %u
    passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
    unix password sync = Yes
    log file = /var/log/samba/log.%m
    max log size = ${Log_Max_Size}
    max protocol = SMB3
    protocol = SMB3
    server min protocol = SMB2
    min protocol = SMB2
    load printers = No
    dns proxy = No
    usershare allow guests = Yes
    panic action = /usr/share/samba/panic-action %d
    idmap config * : backend = tdb


[king]
    comment = need share
    path = ${share_folder}
    valid users = ${User_Name}
    force user = ${User_Name}
    force group = ${User_Name}
    group = ${User_Name}
    read only = No
    create mask = 0777
    directory mask = 0777
    directory mode = 0777
    guest ok = Yes"
}
Check_install (){
apt-get install -y samba samba-common python-glade2 system-config-samba
}
Install_samba (){
conf_file

apt-get install -y samba samba-common python-glade2 system-config-samba
read -p "Please input share folder directory : " share_folder
read -p "Please input samba explore name : " BIOS_NAME
read -p "Please input user name : " User_Name
read -p "Please input samba log max size : " Log_Max_Size
share_folder=${share_folder:="/samba/anonymous"}
BIOS_NAME=${BIOS_NAME:="WIJTB"}
User_Name=${User_Name:="king"}
Log_Max_Size=${Log_Max_Size:="1000"}

$conf > $Samba_Conf_File

}


echo "(1).Install samba"
echo "(2).Exit"
read -p "Please Input Number (1-8):" choice
	case ${choice} in
	1)	
		Install_samba
	;;
	2)	break
	;;
	*)
	echo -e "\n${COLOR_RED}Error Input Please Try Again${COLOR_REST}\n"
	;;
	esac
#!/bin/bash
COLOR_REST='\e[0m'
COLOR_GREEN='\e[0;32m';
COLOR_RED='\e[0;31m';
COLOR_YELLOW='\033[1;93m'

mkdir=$(mkdir -p 2> /dev/null)
Bk_conf=$(cp /etc/samba/smb.conf /etc/samba/smb.conf.bak 2> /dev/null)
Samba_Conf_Path=$(/etc/samba/smb 2> /dev/null)
Samba_Conf_File="/etc/samba/smb.conf"

Ask_answer (){
read -p "Please input share folder directory : " share_folder
read -p "Please input samba explore name : " BIOS_NAME
read -p "Please input user name : " User_Name
read -p "Please input samba log max size : " Log_Max_Size
read -p "Please input samba net folder name : " NET_NAME
share_folder=${share_folder:="/samba/anonymous"}
BIOS_NAME=${BIOS_NAME:="WIJTB"}
User_Name=${User_Name:="king"}
Log_Max_Size=${Log_Max_Size:="1000"}
NET_NAME=${NET_NAME:="king"}
}

Conf_file (){
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


[${NET_NAME}]
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
if [ -f "/usr/sbin/smbd" ]; then
  test=0
else
  test=1
fi
}

Install_samba (){
Conf_file
Check_install
	if [ $test -eq 1 ]; then
	echo "installing samba"
	apt-get install -y samba samba-common python-glade2 system-config-samba
	elif [ $test -eq 0 ]; then
	echo "samba service had been exists"
	echo "(1).Reinstall samba"
	echo "(2).Exit"
	read -p "Please Input Number (1-2):" choice
		case ${choice} in
		1)	
			apt-get remove --purge -y samba samba-common python-glade2 system-config-samba 
			wait
			apt-get install -y samba samba-common python-glade2 system-config-samba
			wait
		;;
		2)
			break
		;;
		*)
		echo -e "\n${COLOR_RED}Error Input Please Try Again${COLOR_REST}\n"
		;;
		esac
	fi
wait
echo -e "\n${COLOR_GREEN}Install Success !!!!${COLOR_REST}\n"

echo "${conf}" > "${Samba_Conf_File}"
if [ -d "${share_folder}" ]; then
    echo "Directory ${share_folder} exists."
else
    echo "Directory ${share_folder} does not exists."
	echo "createing folder...."
	mkdir -p $share_folder
fi
chmod -R 0770 $share_folder
chown -R king:king $share_folder

echo "adding Samba User"
Check_User_Exist=$(cat /etc/passwd | grep -o $User_Name | head -n 1)
if [ "$Check_User_Exist" ==  $User_Name ]; then
smbpasswd -a $User_Name
else
adduser $User_Name && passwd $User_Name && smbpasswd -a $User_Name
fi

echo "setting firewall"

firwalld=$(command -v firewalld 2>/dev/null)
ufw=$(command -v ufw 2>/dev/null)
if [ $firewalld > /dev/null 2>&1 ]; then 
  echo 'Use firewalld' 
	firewall-cmd --zone=public --add-service samba
	firewall-cmd --zone=public --permanent --add-service samba 
elif [ $ufw > /dev/null 2>&1 ]; then 
  echo 'Use ufw' 
	ufw allow Samba
else
  echo -e "\n${COLOR_RED}We do not know what firewall you use !!!${COLOR_REST}\n"
fi
echo "starting samba service"
	systemctl restart smbd.service
wait
echo -e "\n${COLOR_GREEN}Starting Samba Service Success !!!${COLOR_REST}\n"

##IPV4 Check
ListIPcmd="/sbin/ifconfig"
IP=$($ListIPcmd | grep 'inet addr:' | grep -v '127.0.0.1' | awk '{print $2}' | awk -F:  '{print $2}')
echo -e "\nthis is windows samba information\n"
echo -e "\n${COLOR_GREEN}"'  \\''\\'"${IP}\\${NET_NAME}${COLOR_REST}\n"

}

Unstall_Samba (){
apt-get remove --purge samba samba-common python-glade2 system-config-samba
}
echo "(1).Install samba"
echo "(2).Unstall samba"
echo "(3).Exit"
read -p "Please Input Number (1-3):" choice
	case ${choice} in
	1)	
		Ask_answer
		Install_samba
	;;
	2)
		Unstall_Samba
	;;
	3)	break
	;;
	*)
	echo -e "\n${COLOR_RED}Error Input Please Try Again${COLOR_REST}\n"
	;;
	esac
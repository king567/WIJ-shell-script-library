#!/bin/bash
#######ftp一鍵腳本
#######使用平台ubuntu
#######腳本作者wijtb
Ubuntu_ftp_conf_path="/etc/vsftpd.conf"
check_user="$(cat /etc/passwd | grep -o ${User_Name} | head -n 1)"
check_chroot_user="$(cat /etc/vsftpd/chroot_list | grep -o ${User_Name} | head -n 1)"
initializeANSI()
{
  esc=""

  blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
  yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
  cyanf="${esc}[36m";    whitef="${esc}[37m"
  
  blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
  yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
  cyanb="${esc}[46m";    whiteb="${esc}[47m"

  boldon="${esc}[1m";    boldoff="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}
Firewall()
{
firwalld=$(command -v firewalld 2>/dev/null)
ufw=$(command -v ufw 2>/dev/null)
if [ $firewalld > /dev/null 2>&1 ]; then 
  echo 'Use firewalld' 
	firewall-cmd --zone=public --add-service=ftp
	firewall-cmd --permanent --zone=public --add-service=ftp
elif [ $ufw > /dev/null 2>&1 ]; then 
  echo 'Use ufw' 
	ufw allow 20
	ufw allow 21
else
  echo 'Use iptables'
	iptables -A INPUT -i enxb827eb8be83c -p tcp -m tcp --dport 21 -j ACCEPT
	iptables -A INPUT -i enxb827eb8be83c -p tcp -m tcp --dport 20 -j ACCEPT
	iptables -A OUTPUT -o enxb827eb8be83c -p tcp -m tcp --sport 21 -j ACCEPT
	iptables -A OUTPUT -o enxb827eb8be83c -p tcp -m tcp --sport 20 -j ACCEPT
fi
}
Download_Vsftpd()
{
if [ -f "/usr/sbin/vsftpd" ]; then
echo -n ${redf}"\n已檢測到安裝vsftpd\n"${reset}
echo -n ${greenf}"\n(1).解除安裝vsftpd\n"${reset}
echo -n ${greenf}"\n(2).重新安裝vsftpd\n"${reset}
read -p "請輸入選項(1-2):" Re_install_vsftpd
	case ${Re_install_vsftpd} in
	   1)
			apt-get remove --purge vsftpd -y
		 ;;
	   2)
			apt-get remove --purge vsftpd -y && apt-get install vsftpd -y
		 ;;
	   *)
		 echo -n ${redf}"\n輸入錯誤選項\n"${reset}
		 echo -n ${redf}"\n請再輸入一次\n"${reset}
		 ;;
	esac
else
	apt-get install vsftpd -y
echo -n ${greenf}"\n安裝成功\n"${reset}
fi
}
Simple_ftp()
{
echo "請選擇ftp類型"
echo "(1).主動式"
echo "(2).被動式"
echo "(2).主被動合用"
read -p "請輸入選項(1-2):" ftp_type
case ${ftp_type} in
   1)
		echo "anonymous_enable=NO
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list
chroot_local_user=YES
connect_from_port_20=YES
pasv_enable=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=YES
listen_ipv6=NO
pam_service_name=vsftpd
userlist_enable=NO
tcp_wrappers=YES" > ${Ubuntu_ftp_conf_path}
read -p "請輸入使用者名稱：" User_Name
echo "檢查使用者.."
if [ "$User_Name" == "$check_user" ]; then 
echo "使用者已存在.."
else
adduser ${User_Name}
passwd ${User_Name}
fi
mkdir -p /etc/vsftpd
echo "檢查chroot list使用者"
if [ "$check_user" == "$User_Name" ]; then
echo "使用者已存在chroot list"
else
echo ${User_Name} >> /etc/vsftpd/chroot_list
fi
systemctl restart vsftpd.service
     ;;
   2)
		echo "anonymous_enable=NO
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list
chroot_local_user=YES
pasv_enable=YES
connect_from_port_20=NO
pasv_min_port=65000
pasv_max_port=65500
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
xferlog_std_format=YES
listen=YES
listen_ipv6=NO
pam_service_name=vsftpd
userlist_enable=NO
tcp_wrappers=YES" > ${Ubuntu_ftp_conf_path}
systemctl restart vsftpd.service
     ;;
   3)
		echo "anonymous_enable=NO
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list
chroot_local_user=YES
pasv_enable=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
pasv_min_port=65000
pasv_max_port=65500
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=YES
listen_ipv6=NO
pam_service_name=vsftpd
userlist_enable=NO
tcp_wrappers=YES" > ${Ubuntu_ftp_conf_path}
systemctl restart vsftpd.service
     ;;	 
   *)
     echo "輸入錯誤選項"
     ;;
esac
}
Sed_conf_file()
{
######開啟listen
sed -i 's/listen=NO/listen=YES/g' ${Ubuntu_ftp_conf_path}
######關閉listen
sed -i 's/listen=YES/listen=NO/g' ${Ubuntu_ftp_conf_path}
######開起監聽listen_ipv6
sed -i 's/listen_ipv6=NO/listen_ipv6=YES/g' ${Ubuntu_ftp_conf_path}
######關閉監聽listen_ipv6
sed -i 's/listen_ipv6=YES/listen_ipv6=NO/g' ${Ubuntu_ftp_conf_path}
######開啟寫入
sed -i 's/write_enable=NO/write_enable=YES/g' ${Ubuntu_ftp_conf_path}
######關閉寫入
sed -i 's/write_enable=YES/write_enable=NO/g' ${Ubuntu_ftp_conf_path}
}

Uninstall_Vsftpd()
{
apt-get remove --purge vsftpd -y
}

Update_script()
{
wget --no-check-certificate -qO- https://raw.githubusercontent.com/king567/WIJ-shell-script-library/master/ftp_onclick.sh > $0
echo -n ${greenf}"\n更新成功\n"${reset}
}

initializeANSI

echo "請選擇ftp類型"
echo "(1).安裝vsftpd"
echo "(2).一般類型ftp"
echo "(3).外顯式ftp(ftpes)"
echo "(4).解除安裝vsftpd"
echo "(5).更新腳本"
read -p "請輸入選項(1-5):" platform
case ${platform} in
   1)
		Download_Vsftpd
     ;;
   2)
		Simple_ftp
     ;;
   3)
		echo "testing king"
     ;;
   4)
		Uninstall_Vsftpd
     ;;
   5)
		Update_script
     ;;
   *)
     echo "輸入錯誤選項"
     ;;
esac
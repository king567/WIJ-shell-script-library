#!/bin/bash
# test in apache2
# Blog: wijtb.nctu.me
#
#
# Write by WIJ
check_extra_folder (){
if [ -d "/etc/apache2/extra" ]; then
	if [ -f "/etc/apache2/extra/httpd-vhosts.conf" ]; then
	echo ""
	else
	touch /etc/apache2/extra/httpd-vhosts.conf
	fi
else
mkdir -p /etc/apache2/extra
wait
	if [ -f "/etc/apache2/extra/httpd-vhosts.conf" ]; then
	echo ""
	else
	touch /etc/apache2/extra/httpd-vhosts.conf
	fi
fi
}

if [ -f "/usr/bin/htpasswd" ]; then
	echo ""
else
	yum -y install httpd-tools || apt-get -y install apache2-utils || echo "error"
fi

if [ -f "/etc/apache2/apache2.conf" ]; then
	vhost="$(cat /etc/apache2/apache2.conf | grep Include | grep  /etc/apache2/extra/httpd-vhosts.conf | grep -o httpd-vhosts.conf)"
	if [ "${vhost}" == "httpd-vhosts.conf" ]; then
	check_extra_folder
	else
		if [ "${vhost}" == "httpd-vhosts.conf" ]; then 
		echo ""
		else
		echo 'Include /etc/apache2/extra/httpd-vhosts.conf' >> /etc/apache2/apache2.conf
		check_extra_folder
		fi
	check_extra_folder
	fi
else
	echo "you must install apache2"
fi




access_conf (){
if [ -d "${website_path}" ]; then
cd ${website_path}
else
echo "${website_path} not exist!!!" 
fi
echo "AuthName "PrivatePage"
AuthType Basic
AuthUserFile \"${website_path}/.htpasswd\"
require valid-user" > .htaccess
}


website_conf (){
cd /etc/apache2/extra
echo "<Directory \"${website_path}\">
   AllowOverride ALL
</Directory>" >> httpd-vhosts.conf
}

read -p "pleas input website path : " website_path
read -p "User Name : " User
website_conf
access_conf
cd ${website_path}
htpasswd -c .htpasswd ${User}
wait
systemctl restart apache2.service
wait
echo "success"
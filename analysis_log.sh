#!/bin/bash
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

initializeANSI


IPV4_format='[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+'
Log_Path='/var/log/auth.log*'
Fasle_text="${redf} \nfasle access\n ${reset}"
Success_text="${greenf} \nSuccess access\n ${reset}"
Country_API="https://ip.cn/index.php?ip="

######################################分析IP函數
Success_Grep()
{
	grep Accepted | grep publickey
}

Fasle_Grep()
{
	grep error | grep maximum
}

Order()
{
	sort | uniq -c | sort -n -r
}
Order_Country()
{
	sort | uniq -w 16 | sort -n -r
}
######################################
analyis_ip()
{
  echo -e $Fasle_text
  #Fasle
  cat ${Log_Path} | Fasle_Grep | grep -o ${IPV4_format} | Order
  #success
  echo -e $Success_text
  cat ${Log_Path} | Success_Grep | grep -o ${IPV4_format} | Order
  echo ""
}

Found_Country()
{
  echo -e $Fasle_text
  tmp=`cat ${Log_Path} | Fasle_Grep | grep -o ${IPV4_format} | Order_Country `
  echo -e "$tmp" > tmp
  count=`wc -l tmp | sed 's/ tmp//g'`
  for (( i=1; i<=$count; i++ ))
  do
    count_ip=`sed -n ${i}p tmp`
        curl -s "${Country_API}${count_ip}"
  done
  echo -e $Success_text
  tmp_two=`cat ${Log_Path} | Success_Grep | grep -o ${IPV4_format} | Order_Country `

  echo -e "$tmp_two" > tmp2
  count_two=`wc -l tmp2 | sed 's/ tmp2//g'`
  for (( i=1; i<=$count_two; i++ ))
  do
    count_ip2=`sed -n ${i}p tmp2`
        curl -s "${Country_API}${count_ip2}"
  done
  echo ""
  rm -f tmp
  rm -f tmp2
}
update_shell_script ()
{
wget --no-check-certificate -qO- https://raw.githubusercontent.com/king567/WIJ-shell-script-library/master/analysis_log.sh > $0
echo -e ${greenf}"\n更新成功\n"${reset}
}
echo "(1).analysis ip"
echo "(2).Ip Country Name"
echo "(3).更新腳本"
read -p "請輸入選項(1-3) :" choose
    case ${choose} in
       1)
			analyis_ip
         ;;
       2)
			Found_Country
         ;;
       3)
			update_shell_script
         ;;
       *)
         echo "輸入錯誤選項"
         ;;
    esac


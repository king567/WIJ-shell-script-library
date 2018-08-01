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
analyis_ip()
{
#ipv4_format="$(grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+')"
echo ""
echo -n $redf "fasle access" $reset
echo ""
echo ""
cat /var/log/auth.log* | grep  error | grep  maximum | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | sort | uniq -c | sort -n -r
echo ""

#success
echo -n $greenf "Success access" $reset
echo ""
echo ""
cat auth.log.* | grep Accepted | grep publickey | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | sort | uniq -c | sort -n -r
echo ""
}
Found_Country()
{
echo ""
echo -n $redf "fasle access" $reset
echo ""
echo ""
tmp=`cat /var/log/auth.log* | grep  error | grep  maximum | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | sort | uniq -w 16 | sort -n -r `

echo -e "$tmp" > tmp
count=`wc -l tmp | sed 's/ tmp//g'`
for (( i=1; i<=$count; i++ ))
do
	count_ip=`sed -n ${i}p tmp`
      curl -s "https://ip.cn/index.php?ip=${count_ip}"
done
echo ""
echo -n $greenf "Success access" $reset
echo ""
echo ""
tmp_two=`cat /var/log/auth.log* | grep Accepted | grep publickey | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | sort | uniq -w 16 | sort -n -r `

echo -e "$tmp_two" > tmp2
count_two=`wc -l tmp2 | sed 's/ tmp2//g'`
for (( i=1; i<=$count_two; i++ ))
do
	count_ip2=`sed -n ${i}p tmp2`
      curl -s "https://ip.cn/index.php?ip=${count_ip2}"
done

rm -f tmp
rm -f tmp2
}
initializeANSI

echo "(1).analysis ip"
echo "(2).Ip Country Name"
read -p "請輸入選項(1-2) :" choose
case ${choose} in
   1)
   		analyis_ip
     ;;
   2)
		Found_Country
     ;;

   *)
     echo "輸入錯誤選項"
     ;;
esac


#!/bin/bash


banner()
{
  echo ""
  echo "       .      S     "
  echo "      .       C     "
  echo "     .        A     "
  echo "    . @       N     "
  echo "   .   @      N     "
  echo "  . #   @     E     "
  echo " .   #   @    R     "
  echo "...................."
  echo ""
}

main()
{
  echo "Choose option:"
  echo "1: LFI to RCE"
  echo "2: fishing"
  
  
}

LFI()
{
  
}

fishing()
{
  
}

nmap_scan()
{
  ip=$1
  clear
  nmap -sS $ip;
  echo ""
  echo "Next level (more information, vuln scripts)[y/n]?"
  read agreem
  if [[ $agreem == "n" ]]; then
    exit 0
  elif [[ $agreem == "y" ]]; then
    
    clear
    
    cr=$( nmap -sS -A -D 10.19.58.32 --script=vuln -d -vv $ip -oN nmap_$ip.txt )
    
    echo "saved in nmap_$ip.txt"
    
    sa=$( cat $ip.txt | grep "80" | grep "open" )
    
    if [[ $sa == "" ]]; then
      exit 0
    fi
    
    cat nmap_$ip.txt
    
    echo ""
    
    echo "Next level (enumerate folders)[y/n]?"
    
    read agreem
    
    if [[ $agreem == "n" ]]; then
      exit 0
    elif [[ $agreem == "y" ]]; then
       
      dir_locate=$(locate directory-list-2.3-small.txt)
        
      ffuf -w $dir_locate -u http://$ip/FUZZ -fs 0 -o "ffuf_$ip.txt"
      
      echo "Next level (enumerate subdomains)[y/n]?"
    
      read agreem
    
      if [[ $agreem == "n" ]]; then
        exit 0
      elif [[ $agreem == "y" ]]; then
        dir_locate=$(locate subdomains-top1million-20000.txt)
        
        ffuf -w $dir_locate -u http://FUZZ.$ip/ -fs 0 >> "ffuf_$ip.txt"
      
    else
      echo "wrong choice"
      exit 0
    fi
  else
    echo "wrong choice"
    exit 0
  fi
}

hlp()
{
  echo "Please install SecLists"
  echo "if ip wasn't in /etc/hosts it will be added as test.vln (please don't use names of WA, only ip)"
  echo "-h | --help: for help"
  echo "-b | --banner: for banner"
  echo "-ip: for ip (default = 127.0.0.1)"
}


ip=127.0.0.1

ac=$( cat /etc/hosts | grep "$ip" )

if [[ $ac != *"$ip"* ]]; then
  echo "$ip test.vln" >> /etc/host
  ip=test.vln
else
  ip=$(echo $ac | cut -d " " -f 3)
fi

while test $# -gt 0; do
  case "$1" in
    -h | --help)
      hlp
      exit 0
      ;;
    -b | --banner)
      banner
      exit 0
      ;;
    -ip)
      ip=$1
      ;;
  esac
done

hlp
echo "\n\n"
nmap_scan $ip

echo ""

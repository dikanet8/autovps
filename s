#!/bin/bash
clear

myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;

flag=0

echo

function create_user() {
#myip=`dig +short myip.opendns.com @resolver1.opendns.com`
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $uname
exp="$(chage -l $uname | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$pass\n$pass\n"|passwd $uname &> /dev/null
echo -e ""| lolcat
echo -e "-----------------------------------------" | lolcat
echo -e ">>>>          Data Akun SSH          <<<<" | lolcat
echo -e "-----------------------------------------" | lolcat
echo -e "  Host: $myip" | lolcat
echo -e "  Username: $uname" | lolcat
echo -e "  Password: $pass                     " | lolcat
echo -e "  Port Dropbear: 443,80,22507,2000,2017" | lolcat
echo -e "  Port OpenSSH: 22,90                 " | lolcat
echo -e "  Port Squid: 8080,3128               " | lolcat
echo -e "  Config OVPN: $myip:81/1194-client.ovpn
echo -e "-----------------------------------------" | lolcat
echo -e "    Masa Aktif Sampai: $exp " | lolcat
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
echo -e "-----------------------------------------" | lolcat
echo -e "             Peraturan Server            " | lolcat
echo -e "1. Dilarang Carding, Torrent,DDOS,Spamming " | lolcat 
echo -e "   dan Ilegal Lainnya " | lolcat
echo -e "2. Max Login 2 Bitvise/Plink " |lolcat
echo -e "-----------------------------------------" | lolcat
echo -e "     PELANGGARAN YANG DILAKUKAN AKAN " | lolcat
echo -e "       MEMBUAT AKUN ANDA DIBANNED" | lolcat
echo -e "-------------- TERIMA KASIH -------------" | lolcat
echo -e " "
echo -e "===========Modified By DikaNET===========" | lolcat
}
function renew_user() {
	echo "Kadaluarsa User: $uname Di Perbarui Sampai: $expdate"| lolcat;
	usermod -e $expdate $uname
}

function delete_user(){
	userdel $uname
}

function expired_users(){
echo "---------------------------------"| lolcat
echo "BIL  USERNAME          EXPIRED "| lolcat
echo "---------------------------------"| lolcat
count=1
	cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
	totalaccounts=`cat /tmp/expirelist.txt | wc -l`
	for((i=1; i<=$totalaccounts; i++ )); do
	tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
		username=`echo $tuserval | cut -f1 -d:`
		userexp=`echo $tuserval | cut -f2 -d:`
		userexpireinseconds=$(( $userexp * 86400 ))
		todaystime=`date +%s`
		expired="$(chage -l $username | grep "Account expires" | awk -F": " '{print $2}')"
		if [ $userexpireinseconds -lt $todaystime ] ; then
			printf "%-4s %-15s %-10s %-3s\n" "$count." "$username" "$expired"
			count=$((count+1))
		fi
	done
	rm /tmp/expirelist.txt
}

function not_expired_users(){
    cat /etc/shadow | cut -d: -f1,8 | sed /:$/d > /tmp/expirelist.txt
    totalaccounts=`cat /tmp/expirelist.txt | wc -l`
    for((i=1; i<=$totalaccounts; i++ )); do
        tuserval=`head -n $i /tmp/expirelist.txt | tail -n 1`
        username=`echo $tuserval | cut -f1 -d:`
        userexp=`echo $tuserval | cut -f2 -d:`
        userexpireinseconds=$(( $userexp * 86400 ))
        todaystime=`date +%s`
        if [ $userexpireinseconds -gt $todaystime ] ; then
            echo $username
        fi
    done
	rm /tmp/expirelist.txt
}

function monssh2(){
echo ""| lolcat
echo "|   Tgl-Jam    | PID   |   User Name  |      Dari IP      |"| boxes -d peek | lolcat
echo "-------------------------------------------------------------"| lolcat
data=( `ps aux | grep -i dropbear | awk '{print $2}'`);

echo "=====================[ CEK LOGIN DROPBEAR ]=================="| lolcat
echo "-------------------------------------------------------------"| lolcat
for PID in "${data[@]}"
do
	#echo "check $PID";
	NUM=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
	USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk -F" " '{print $10}'`;
	IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk -F" " '{print $12}'`;
	waktu=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk -F" " '{print $1,$2,$3}'`;
	if [ $NUM -eq 1 ]; then
		echo "$waktu - $PID - $USER - $IP"| lolcat;
	fi
done


echo "-------------------------------------------------------------"| lolcat
data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);

echo "=====================[ CEK LOGIN OpenSSH ]==================="| lolcat
echo "-------------------------------------------------------------"| lolcat
for PID in "${data[@]}"
do
        #echo "check $PID";
		NUM=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
		USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
		IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
		waktu=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $1,$2,$3}'`;
        if [ $NUM -eq 1 ]; then
                echo "$waktu - $PID - $USER - $IP"| lolcat;
        fi
done

echo "-------------------------------------------------------------"| lolcat
echo -e "============[ MONITOR PENGGUNA DROPBEAR & OpenSSH]==========="| lolcat
echo -e " "
echo -e "===================== Modified By DikaNET ==================="| lolcat
}

function used_data(){
	myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`
	myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`
	ifconfig $myint | grep "RX bytes" | sed -e 's/ *RX [a-z:0-9]*/Received: /g' | sed -e 's/TX [a-z:0-9]*/\nTransfered: /g'
}

function bench-network2(){
wget freevps.us/downloads/bench.sh -O - -o /dev/null|bash
echo -e "Sekian...!!!"| lolcat
}

function user-list(){
echo "--------------------------------------------------"| lolcat
echo "BIL  USERNAME        STATUS        TGL KEDALUARSA "| lolcat
echo "--------------------------------------------------"| lolcat
C=1
ON=0
OFF=0
while read mumetndase
do
        AKUN="$(echo $mumetndase | cut -d: -f1)"
        ID="$(echo $mumetndase | grep -v nobody | cut -d: -f3)"
        exp="$(chage -l $AKUN | grep "Account expires" | awk -F": " '{print $2}')"
        online="$(cat /etc/openvpn/log.log | grep -Eom 1 $AKUN | grep -Eom 1 $AKUN)"
        if [[ $ID -ge 500 ]]; then
        if [[ -z $online ]]; then
        printf "%-4s %-15s %-10s %-3s\n" "$C." "$AKUN" "OFFLINE" "$exp"
        OFF=$((OFF+1))
        else
        printf "%-4s %-15s %-10s %-3s\n" "$C." "$AKUN" "ONLINE" "$exp"
        ON=$((ON+1))
        fi
        C=$((C+1))
        fi
JUMLAH="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
done < /etc/passwd
echo "--------------------------------------------------"| lolcat
echo " OFFLINE : $OFF     ONLINE : $ON     TOTAL USER : $JUMLAH "| lolcat
echo "--------------------------------------------------"| lolcat
}

function lokasi(){

data=( `ps aux | grep -i dropbear | awk '{print $2}'`);

echo "User Login" | boxes -d peek | lolcat;
echo "=================================";
echo "Dropbear" | lolcat
for PID in "${data[@]}"
do
    #echo "check $PID";
    NUM=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | wc -l`;
    USER=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $10}'`;
    IP=`cat /var/log/auth.log | grep -i dropbear | grep -i "Password auth succeeded" | grep "dropbear\[$PID\]" | awk '{print $12}'`;
    if [ $NUM -eq 1 ]; then
        echo "$USER - $IP";
    fi
done
echo ""
echo "OpenSSH" | lolcat;

data=( `ps aux | grep "\[priv\]" | sort -k 72 | awk '{print $2}'`);


for PID in "${data[@]}"
do
        #echo "check $PID";
        NUM=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | wc -l`;
        USER=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $9}'`;
        IP=`cat /var/log/auth.log | grep -i sshd | grep -i "Accepted password for" | grep "sshd\[$PID\]" | awk '{print $11}'`;
        if [ $NUM -eq 1 ]; then
                echo "$USER - $IP";
        fi
done
echo "-------------------------------" | lolcat
}


clear
echo "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+==+=+=+=+=+=+=+" | lolcat
echo "+                                  SELAMAT DATANG                              +" | lolcat
echo "+==============================================================================+" | lolcat
echo "+                                                                              +" | lolcat
echo "+                        Script Premium Modified by DikaNET                    +" | lolcat 
echo "+                              <<= Contact Person =>>                          +" | lolcat
echo "+                         BBM :D69F79CA | WA :082228644803                     +" | lolcat
echo "+                                                                              +" | lolcat
echo "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=+" | lolcat
echo " "
echo "                               Informasi Server Anda                            " | lolcat
echo " IP\Host : $myip " | lolcat
echo "================================================================================" | lolcat
echo "                             >>>>>>> Menu Premium <<<<<<<                       " | lolcat
echo "================================================================================" | lolcat
PS3='Silahkan ketik nomor pilihan anda lalu tekan ENTER: '
options=("Buat Akun SSH" "Buat Akun Trial" "Tambah Masa Aktif" "Daftar Akun SSH" "Hapus Akun SSH" "Cek Login Akun SSH" "On Kill Multi Login" "Off Kill Multi Login" "Akun SSH Belum Exp" "Akun SSH Sudah Exp" "Restart Server" "Ganti Password Akun" "Ganti Password VPS" "Cek Penggunaan data by User" "Bench-network" "Status RAM" "Bersihkan Cache RAM" "Ganti Port OpenVPN" "Ganti Port Dropbear" "Ganti Port Openssh" "Ganti Port Squid3" "Speedtest" "Edit Banner Login" "Lihat Lokasi User" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Buat Akun SSH")
       clear       
       echo -e "+==============================================================================+" | lolcat
       echo -e "+                                                                              +" | lolcat
       echo -e "+                        Script Premium Modified by DikaNET                    +" | lolcat 
       echo -e "+                              <<= Contact Person =>>                          +" | lolcat
       echo -e "+                         BBM :D69F79CA | WA :082228644803                     +" | lolcat
       echo -e "+                                                                              +" | lolcat
       echo -e "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=+=+" | lolcat
       echo -e "================================================================================" | lolcat
       echo -e "                          >>>>>>>>>> Buat Akun SSH <<<<<<<<<<                   " | lolcat
       echo -e "================================================================================" | lolcat
       echo -e " "
       echo -e " "
       read -p "Enter username: " uname
       read -p "Enter password: " pass
       read -p "Kadaluarsa (Berapa Hari): " masaaktif
       create_user
	    break
            ;;
	"Buat Akun Trial")
	uname=trial-`</dev/urandom tr -dc X-Z0-9 | head -c4`
	masaaktif="1"
	pass=`</dev/urandom tr -dc a-f0-9 | head -c5`
	clear
	create_user
	break
	;;
        "Tambah Masa Aktif")
	    clear	   
            echo -e "+==============================================================================+" | lolcat
            echo -e "+                                                                              +" | lolcat
            echo -e "+                        Script Premium Modified by DikaNET                    +" | lolcat 
            echo -e "+                              <<= Contact Person =>>                          +" | lolcat
            echo -e "+                         BBM :D69F79CA | WA :082228644803                     +" | lolcat
            echo -e "+                                                                              +" | lolcat
            echo -e "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=+=+" | lolcat
            echo -e "================================================================================" | lolcat
            echo -e "                         >>>>>>>>>> Renew Akun SSH <<<<<<<<<<                   " | lolcat
            echo -e "================================================================================" | lolcat
            echo -e " "
            echo -e " "
            read -p "Enter username yg di perbarui: " uname
            read -p "Aktif sampai tanggal Thn-Bln-Hr(YYYY-MM-DD): " expdate
            renew_user | boxes -d dog | lolcat
            break
            ;;
	 "Daftar Akun SSH")
	    clear
	    echo -e "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+==+=+=+=+=+=+=+" | lolcat
            echo -e "+                                  SELAMAT DATANG                              +" | lolcat
            echo -e "+==============================================================================+" | lolcat
            echo -e "+                                                                              +" | lolcat
            echo -e "+                        Script Premium Modified by DikaNET                    +" | lolcat 
            echo -e "+                              <<= Contact Person =>>                          +" | lolcat
            echo -e "+                         BBM :D69F79CA | WA :082228644803                     +" | lolcat
            echo -e "+                                                                              +" | lolcat
            echo -e "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=+=+" | lolcat
            echo -e "================================================================================" | lolcat
            echo -e "                        >>>>>>>>>> Daftar Akun SSH <<<<<<<<<<                   " | lolcat
            echo -e "================================================================================" | lolcat
            echo -e " "
            echo -e " "
	    user-list
	    break
	    ;;
        "Hapus Akun SSH")
	    clear
            echo -e "+==============================================================================+" | lolcat
            echo -e "+                                                                              +" | lolcat
            echo -e "+                        Script Premium Modified by DikaNET                    +" | lolcat 
            echo -e "+                              <<= Contact Person =>>                          +" | lolcat
            echo -e "+                         BBM :D69F79CA | WA :082228644803                     +" | lolcat
            echo -e "+                                                                              +" | lolcat
            echo -e "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=+=+" | lolcat
            echo -e "================================================================================" | lolcat
            echo -e "                         >>>>>>>>>> Hapus Akun SSH <<<<<<<<<<                   " | lolcat
            echo -e "================================================================================" | lolcat
            echo -e " "
            echo -e " "
	    user-list
	    echo ""
            read -p "Ketik user (di atas) yang akan di hapus: " uname 
	    echo -e "User $uname sukses dihapus boss!!!" | boxes -d boy | lolcat
            delete_user
	    break
            ;;
	  "Cek Login Akun SSH")
	  clear
	  echo -e "+==============================================================================+" | lolcat
	  echo -e "+                                                                              +" | lolcat
          echo -e "+                        Script Premium Modified by DikaNET                    +" | lolcat 
          echo -e "+                              <<= Contact Person =>>                          +" | lolcat
          echo -e "+                         BBM :D69F79CA | WA :082228644803                     +" | lolcat
          echo -e "+                                                                              +" | lolcat
          echo -e "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=+=+" | lolcat
          echo -e "================================================================================" | lolcat
          echo -e "                      >>>>>>>>>> Cek Login Akun SSH <<<<<<<<<<                  " | lolcat
          echo -e "================================================================================" | lolcat
          echo -e " "
          echo -e " "
	  monssh2
	  break
	  ;;
	    "On Kill Multi Login")
	   echo "* * * * * root ./userlimit 2" > /etc/cron.d/userlimit1
	   echo "* * * * * root sleep 10; ./userlimit.sh 2" > /etc/cron.d/userlimit2
           echo "* * * * * root sleep 20; ./userlimit.sh 2" > /etc/cron.d/userlimit3
           echo "* * * * * root sleep 30; ./userlimit.sh 2" > /etc/cron.d/userlimit4
           echo "* * * * * root sleep 40; ./userlimit.sh 2" > /etc/cron.d/userlimit5
           echo "* * * * * root sleep 50; ./userlimit.sh 2" > /etc/cron.d/userlimit6
	    service cron restart
	    service ssh restart
	    service dropbear restart
	    echo "AUTO KILL SUDAH AKTIFKAN"| lolcat
	    
	echo "Udah di kill bos....aman dah" | boxes -d boy | lolcat
		break
		;;
	"Off Kill Multi Login")
	rm -rf /etc/cron.d/userlimit1
	rm -rf /etc/cron.d/userlimit2
	rm -rf /etc/cron.d/userlimit3
	rm -rf /etc/cron.d/userlimit4
	rm -rf /etc/cron.d/userlimit5
	rm -rf /etc/cron.d/userlimit6
	service cron restart
	    service ssh restart
	    service dropbear restart
	echo "AUTO KILL LOGIN,SUDAH SAYA MATIKAN BOS!!!" | boxes -d boy | lolcat
	break
	;;
		"Daftar Akun SSH Aktif")
		  clear
	          echo -e "+==============================================================================+" | lolcat
	          echo -e "+                                                                              +" | lolcat
                  echo -e "+                        Script Premium Modified by DikaNET                    +" | lolcat 
                  echo -e "+                              <<= Contact Person =>>                          +" | lolcat
                  echo -e "+                         BBM :D69F79CA | WA :082228644803                     +" | lolcat
                  echo -e "+                                                                              +" | lolcat
                  echo -e "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=+=+" | lolcat
                  echo -e "================================================================================" | lolcat
                  echo -e "                    >>>>>>>>>> Daftar Akun SSH Aktif <<<<<<<<<<                 " | lolcat
                  echo -e "================================================================================" | lolcat
                  echo -e " "
                  echo -e " "
		  echo -e "==============================================================" | lolcat
			not_expired_users | | lolcat
	                echo -e "==============================================================" | lolcat
			break
			;;
		"Daftar Akun SSH Expired")
		  clear
	          echo -e "+==============================================================================+" | lolcat
	          echo -e "+                                                                              +" | lolcat
                  echo -e "+                        Script Premium Modified by DikaNET                    +" | lolcat 
                  echo -e "+                              <<= Contact Person =>>                          +" | lolcat
                  echo -e "+                         BBM :D69F79CA | WA :082228644803                     +" | lolcat
                  echo -e "+                                                                              +" | lolcat
                  echo -e "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=+=+" | lolcat
                  echo -e "================================================================================" | lolcat
                  echo -e "                   >>>>>>>>>> Daftar Akun SSH Expired <<<<<<<<<<                " | lolcat
                  echo -e "================================================================================" | lolcat
                  echo -e " "
                  echo -e " "
		  echo -e "==============================================================" | lolcat
			expired_users | | lolcat
		  echo -e "==============================================================" | lolcat
			break
			;;		
		"Restart Server")
			reboot
			break
			;;
		"Ganti Password User")
		  clear
	          echo -e "+==============================================================================+" | lolcat
	          echo -e "+                                                                              +" | lolcat
                  echo -e "+                        Script Premium Modified by DikaNET                    +" | lolcat 
                  echo -e "+                              <<= Contact Person =>>                          +" | lolcat
                  echo -e "+                         BBM :D69F79CA | WA :082228644803                     +" | lolcat
                  echo -e "+                                                                              +" | lolcat
                  echo -e "+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=++=+=+=+=+=+=+" | lolcat
                  echo -e "================================================================================" | lolcat
                  echo -e "                   >>>>>>>>>> Daftar Akun SSH Expired <<<<<<<<<<                " | lolcat
                  echo -e "================================================================================" | lolcat
                  echo -e " "
                  echo -e " "
		read -p "Ketik user yang akan di ganti passwordnya: " uname
		read -p "Silahkan isi passwordnya: " pass
		echo "$uname:$pass" | chpasswd
		echo "Sukses gan!!! Password $uname user ente sudah di ganti..."| boxes -d peek | lolcat
		break
		;;
		"Ganti Password VPS")
		read -p "Silahkan isi password baru untuk VPS anda: " pass	
		echo "root:$pass" | chpasswd
		echo "Ganti PW VPS ente sukses gan !!!"| boxes -d boy | lolcat
			break
			;;
		"Cek Penggunaan Data by User")
			used_data | boxes -d boy | lolcat
 			break
			;;
		"Bench-network")
			bench-network2 | lolcat
			break
			;;
		"Status RAM")
			free -h | grep -v + > /tmp/ramcache
			cat /tmp/ramcache | grep -v "Swap"
			break
			;;
		"Bersihkan Cache RAM")
	                echo 3 > /proc/sys/vm/drop_caches && swapoff -a && swapon -a
			echo "SUKSES..!!!Cache ram anda sudah di bersihkan." | boxes -d spring | lolcat
		        break
			;;
		"Ganti Port OpenVPN")	
            echo "Silahkan ganti port OpenVPN anda lalu klik enter?"| boxes -d peek | lolcat
            read -p "Port: " -e -i 55 PORT
            sed -i "s/port [0-9]*/port $PORT/" /etc/openvpn/1194.conf
            service openvpn restart
            echo "OpenVPN Updated Port: $PORT"| lolcat
			break
			;;
		"Ganti Port Dropbear")	
            echo "Silahkan ganti port Dropbear anda lalu klik ENTER!!!
Port dropbear tidak boleh sama dengan port openVPN/openSSH/squid3 !!!"| boxes -d peek | lolcat
           echo "Port1: 443 (Default)"
	    read -p "Port2: " -e -i 109 PORT
	    #read -p "Port3: " -e -i 143 PORT3
            sed -i "s/DROPBEAR_PORT=[0-9]*/DROPBEAR_PORT=$PORT/g" /etc/default/dropbear
	    #sed -i 's/DROPBEAR_EXTRA_ARGS="-p [0-9]*"/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear	
    service dropbear restart
            echo "Dropbear Updated Port2 : $PORT"| lolcat
	    #echo "Dropbear Updated : Port2 $PORT2" | lolcat
	    #echo "Dropbear Updated : Port3 $PORT3" | lolcat
			break
			;;
	   "Ganti Port Openssh")	
            echo "Silahkan ganti port Openssh anda lalu klik enter."| boxes -d peek | lolcat
            echo "Port default dan Port 2 tidak boleh sama !!!"| lolcat
	    echo "Port default: 22"| lolcat
	    read -p "Port 2: " -e -i 80 PORT
	    sed -i "s/Port  [0-9]*\nPort [0-9]*/Port  22\nPort $PORT/g" /etc/ssh/sshd_config
           service ssh restart
            echo "Openssh Updated Port: $PORT"| lolcat
			break
			;;
        "Ganti Port Squid3")	
            echo "Silahkan ganti port Squid3 anda lalu klik enter"| boxes -d dog | lolcat
	    echo "Isi dengan angka tidak boleh huruf !!!"| lolcat
	    read -p "Port Squid3: " -e -i 8080 PORT
            #sed -i 's/http_port [0-9]*\nhttp_port [0-9]*/http_port $PORT1\nhttp_port $PORT2/g' /etc/squid3/squid.conf
            sed -i "s/http_port [0-9]*/http_port $PORT/" /etc/squid3/squid.conf
	   service squid3 restart
            echo "Squid3 Updated Port: $PORT"| lolcat
			break
			;;
			"Speedtest")
			python speedtest.py --share | lolcat
			break		
			;;
      "Edit Banner Login")
	echo -e "1. Simpan text (CTRL + X, lalu ketik Y dan tekan Enter)
	2. Membatalkan edit text (CTRL + X, lalu ketik N dan tekan Enter)" | boxes -d boy | lolcat
	read -p "Tekan ENTER untuk melanjutkan........................ " | lolcat
	nano /bannerssh
	service ssh restart &&  service dropbear restart
	break
	;;
	"Lihat Lokasi User")
	lokasi
read -p "Ketik Salah Satu Alamat IP User: " userip
curl ipinfo.io/$userip
break
;;
		"Quit")
		
		break
		;;
	 
        *) echo invalid option;
	esac
done

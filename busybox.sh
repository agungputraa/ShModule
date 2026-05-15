#!/system/bin/sh

clear

printf "\033[1;36m"
cat << "EOF"
    ___                         ____            
   /   |  ____ ___  ______  ____/ / /___  __   __
  / /| | / __ `/ / / / __ \/ __  / / __ \/ | / /
 / ___ |/ /_/ / /_/ / / / / /_/ / / /_/ /| |/ / 
/_/  |_|\__, /\__,_/_/ /_/\__,_/_/\____/ |___/  
       /____/                                     

              A G U N G   D E V
EOF
printf "\033[0m"

printf "\n\033[1;33m[•] BusyBox Installer For Termux\033[0m\n"
printf "\033[1;33m[•] Repository : agungputraa/ShModule\033[0m\n"
printf "\033[1;33m[•] Target     : /sdcard/Download/busybox\033[0m\n\n"

sleep 1

printf "\033[1;34m[1/6] Checking Termux storage...\033[0m\n"
if [ ! -d "/sdcard/Download" ]; then
  termux-setup-storage
  sleep 2
fi

if [ ! -d "/sdcard/Download" ]; then
  printf "\033[1;31m[!] Storage belum aktif. Izinkan akses storage Termux lalu jalankan ulang.\033[0m\n"
  exit 1
fi

printf "\033[1;32m[✓] Storage ready\033[0m\n\n"

printf "\033[1;34m[2/6] Updating package list...\033[0m\n"
pkg update -y

printf "\n\033[1;34m[3/6] Installing downloader...\033[0m\n"
pkg install wget -y

printf "\n\033[1;34m[4/6] Cleaning old BusyBox file...\033[0m\n"
cd "$HOME" || exit 1
rm -f busybox
rm -f /sdcard/Download/busybox

printf "\033[1;32m[✓] Old file cleaned\033[0m\n\n"

printf "\033[1;34m[5/6] Downloading BusyBox ARM64...\033[0m\n"
wget -O busybox https://raw.githubusercontent.com/Magisk-Modules-Repo/busybox-ndk/master/busybox-arm64

if [ ! -f "$HOME/busybox" ]; then
  printf "\033[1;31m[!] Download gagal. Cek koneksi internet kamu.\033[0m\n"
  exit 1
fi

chmod 755 busybox

printf "\n\033[1;34m[6/6] Saving BusyBox to Download folder...\033[0m\n"
cp busybox /sdcard/Download/busybox
chmod 755 /sdcard/Download/busybox

if [ ! -f "/sdcard/Download/busybox" ]; then
  printf "\033[1;31m[!] Gagal menyimpan BusyBox ke /sdcard/Download\033[0m\n"
  exit 1
fi

printf "\n\033[1;32m"
cat << "EOF"
  ____                  __       
 / __ )__  __________  / /_____  __
/ __  / / / / ___/ / / / //_/ / / /
/ /_/ / /_/ (__  ) /_/ / ,< / /_/ / 
/_____/\__,_/____/\__,_/_/|_|\__, /  
                             /____/   

EOF
printf "\033[0m"

printf "\033[1;32m[✓] BusyBox berhasil diinstall ke:\033[0m\n"
printf "\033[1;37m    /sdcard/Download/busybox\033[0m\n\n"

printf "\033[1;36m[•] File info:\033[0m\n"
ls -lh /sdcard/Download/busybox

printf "\n\033[1;36m[•] Testing BusyBox:\033[0m\n"
/sdcard/Download/busybox --help | head -n 8

printf "\n\033[1;32m[✓] Termux setup selesai.\033[0m\n"
printf "\033[1;33m[!] Lanjutkan setup di Brevent Shell.\033[0m\n\n"

printf "\033[1;37mBrevent command:\033[0m\n"
printf "\033[1;36m"
cat << "EOF"
rm -f /data/local/tmp/busybox
rm -rf /data/local/tmp/bb
cp /sdcard/Download/busybox /data/local/tmp/busybox 2>/dev/null || cat /sdcard/Download/busybox > /data/local/tmp/busybox
chmod 755 /data/local/tmp/busybox
mkdir -p /data/local/tmp/bb
cp /data/local/tmp/busybox /data/local/tmp/bb/busybox
cd /data/local/tmp/bb
chmod 755 busybox
./busybox --install -s .
export PATH="/data/local/tmp/bb:$PATH"
busybox sh
EOF
printf "\033[0m\n"

#!/system/bin/sh

clear

R="\033[1;31m"
G="\033[1;32m"
Y="\033[1;33m"
B="\033[1;34m"
C="\033[1;36m"
W="\033[1;37m"
N="\033[0m"

printf "$C"
cat << "EOF"
    ___                         ____            
   /   |  ____ ___  ______  ____/ / /___  __   __
  / /| | / __ `/ / / / __ \/ __  / / __ \/ | / /
 / ___ |/ /_/ / /_/ / / / / /_/ / / /_/ /| |/ / 
/_/  |_|\__, /\__,_/_/ /_/\__,_/_/\____/ |___/  
       /____/                                     

              A G U N G   D E V
EOF
printf "$N"

printf "\n$Y"
printf "╔════════════════════════════════════════════╗\n"
printf "║        BUSYBOX INSTALLER FOR TERMUX        ║\n"
printf "║          ANDROID SHELL TOOLKIT             ║\n"
printf "╚════════════════════════════════════════════╝\n"
printf "$N\n"

printf "$W[•] Developer  : Agung Dev$N\n"
printf "$W[•] Repository : agungputraa/ShModule$N\n"
printf "$W[•] Target     : /sdcard/Download/busybox$N\n"
printf "$W[•] Mode       : Termux to Brevent / ADB Shell$N\n\n"

sleep 1

printf "$B[1/6] Checking Android architecture...$N\n"
ABI="$(getprop ro.product.cpu.abi 2>/dev/null)"

if [ "$ABI" = "arm64-v8a" ]; then
  BB_FILE="busybox-arm64"
elif [ "$ABI" = "armeabi-v7a" ] || [ "$ABI" = "armeabi" ]; then
  BB_FILE="busybox-arm"
elif [ "$ABI" = "x86" ]; then
  BB_FILE="busybox-x86"
elif [ "$ABI" = "x86_64" ]; then
  BB_FILE="busybox-x86_64"
else
  BB_FILE="busybox-arm64"
fi

printf "$G[✓] ABI detected : $ABI$N\n"
printf "$G[✓] Binary used  : $BB_FILE$N\n\n"

sleep 1

printf "$B[2/6] Checking storage access...$N\n"

if [ ! -d "/sdcard/Download" ]; then
  termux-setup-storage
  sleep 2
fi

if [ ! -d "/sdcard/Download" ]; then
  printf "$R[!] Storage belum aktif.$N\n"
  printf "$Y[!] Izinkan akses storage Termux, lalu jalankan ulang script ini.$N\n"
  exit 1
fi

printf "$G[✓] Storage ready$N\n\n"

sleep 1

printf "$B[3/6] Checking downloader...$N\n"

DOWNLOADER=""

if command -v curl >/dev/null 2>&1; then
  DOWNLOADER="curl"
elif command -v wget >/dev/null 2>&1; then
  DOWNLOADER="wget"
else
  printf "$R[!] curl atau wget tidak ditemukan.$N\n"
  printf "$Y[!] Install salah satu downloader dulu:$N\n"
  printf "$W    pkg install curl -y$N\n"
  printf "$W    pkg install wget -y$N\n"
  exit 1
fi

printf "$G[✓] Downloader ready : $DOWNLOADER$N\n\n"

sleep 1

printf "$B[4/6] Cleaning old BusyBox file...$N\n"

cd "$HOME" || exit 1
rm -f "$HOME/busybox"
rm -f /sdcard/Download/busybox
rm -f /sdcard/Download/agung_busybox_brevent.txt

printf "$G[✓] Old file cleaned$N\n\n"

sleep 1

printf "$B[5/6] Downloading BusyBox static binary...$N\n"

BB_URL="https://raw.githubusercontent.com/Magisk-Modules-Repo/busybox-ndk/master/$BB_FILE"

if [ "$DOWNLOADER" = "curl" ]; then
  curl -L "$BB_URL" -o "$HOME/busybox"
else
  wget -O "$HOME/busybox" "$BB_URL"
fi

if [ ! -f "$HOME/busybox" ]; then
  printf "$R[!] Download gagal.$N\n"
  printf "$Y[!] Cek koneksi internet atau repo BusyBox.$N\n"
  exit 1
fi

chmod 755 "$HOME/busybox"

if ! "$HOME/busybox" --help >/dev/null 2>&1; then
  printf "$R[!] File BusyBox tidak bisa dijalankan.$N\n"
  printf "$Y[!] Kemungkinan binary tidak cocok dengan arsitektur device.$N\n"
  exit 1
fi

printf "$G[✓] BusyBox downloaded and executable$N\n\n"

sleep 1

printf "$B[6/6] Saving BusyBox to Download folder...$N\n"

cp "$HOME/busybox" /sdcard/Download/busybox
chmod 755 /sdcard/Download/busybox

if [ ! -f "/sdcard/Download/busybox" ]; then
  printf "$R[!] Gagal menyimpan BusyBox ke /sdcard/Download$N\n"
  exit 1
fi

cat > /sdcard/Download/agung_busybox_brevent.txt << "EOF"
rm -f /data/local/tmp/busybox
rm -rf /data/local/tmp/bb
cp /sdcard/Download/busybox /data/local/tmp/busybox 2>/dev/null || cat /sdcard/Download/busybox > /data/local/tmp/busybox
chmod 755 /data/local/tmp/busybox
mkdir -p /data/local/tmp/bb
cp /data/local/tmp/busybox /data/local/tmp/bb/busybox
chmod 755 /data/local/tmp/bb/busybox
cd /data/local/tmp/bb
./busybox --install -s .
export PATH="/data/local/tmp/bb:$PATH"
/data/local/tmp/bb/busybox --help
/data/local/tmp/bb/busybox sh
EOF

printf "$G[✓] BusyBox saved successfully$N\n\n"

sleep 1

printf "$G"
cat << "EOF"
  ____                  __       
 / __ )__  __________  / /_____  __
/ __  / / / / ___/ / / / //_/ / / /
/ /_/ / /_/ (__  ) /_/ / ,< / /_/ / 
/_____/\__,_/____/\__,_/_/|_|\__, /  
                             /____/   
EOF
printf "$N"

printf "\n$G[✓] TERMUX SETUP SUCCESS$N\n\n"

printf "$C[•] BusyBox location:$N\n"
printf "$W    /sdcard/Download/busybox$N\n\n"

printf "$C[•] Brevent command saved to:$N\n"
printf "$W    /sdcard/Download/agung_busybox_brevent.txt$N\n\n"

printf "$C[•] File info:$N\n"
ls -lh /sdcard/Download/busybox

printf "\n$C[•] BusyBox test:$N\n"
/sdcard/Download/busybox --help | head -n 8

printf "\n$Y"
printf "╔════════════════════════════════════════════╗\n"
printf "║       COPY COMMAND BELOW TO BREVENT        ║\n"
printf "╚════════════════════════════════════════════╝\n"
printf "$N\n"

printf "$C"
cat << "EOF"
rm -f /data/local/tmp/busybox
rm -rf /data/local/tmp/bb
cp /sdcard/Download/busybox /data/local/tmp/busybox 2>/dev/null || cat /sdcard/Download/busybox > /data/local/tmp/busybox
chmod 755 /data/local/tmp/busybox
mkdir -p /data/local/tmp/bb
cp /data/local/tmp/busybox /data/local/tmp/bb/busybox
chmod 755 /data/local/tmp/bb/busybox
cd /data/local/tmp/bb
./busybox --install -s .
export PATH="/data/local/tmp/bb:$PATH"
/data/local/tmp/bb/busybox --help
/data/local/tmp/bb/busybox sh
EOF
printf "$N\n"

printf "$Y"
printf "╔════════════════════════════════════════════╗\n"
printf "║       COMMAND TEST AFTER INSTALLATION      ║\n"
printf "╚════════════════════════════════════════════╝\n"
printf "$N\n"

printf "$C"
cat << "EOF"
/data/local/tmp/bb/busybox find /sdcard -type f -size +100M
/data/local/tmp/bb/busybox find /sdcard -type f -name "*.apk"
/data/local/tmp/bb/busybox df -h
/data/local/tmp/bb/busybox du -h /sdcard/Download
/data/local/tmp/bb/busybox ps
/data/local/tmp/bb/busybox uname -a
EOF
printf "$N\n"

printf "$G[✓] Done. Lanjut buka Brevent / ADB shell dan paste command di atas.$N\n"

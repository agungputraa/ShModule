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
printf "║            NEON CORE ENGINE READY          ║\n"
printf "╚════════════════════════════════════════════╝\n"
printf "$N\n"

printf "$W[•] Developer  : Agung Dev$N\n"
printf "$W[•] Repository : agungputraa/ShModule$N\n"
printf "$W[•] Target     : /sdcard/Download/busybox$N\n"
printf "$W[•] Mode       : Termux to Neon Core Engine$N\n\n"

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
rm -f /sdcard/Download/neon_core_busybox_setup.txt
rm -f /sdcard/Download/neon_core_busybox_env.txt

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

printf "$B[6/6] Saving BusyBox and Neon Core setup command...$N\n"

cp "$HOME/busybox" /sdcard/Download/busybox
chmod 755 /sdcard/Download/busybox

if [ ! -f "/sdcard/Download/busybox" ]; then
  printf "$R[!] Gagal menyimpan BusyBox ke /sdcard/Download$N\n"
  exit 1
fi

cat > /sdcard/Download/neon_core_busybox_setup.txt << "EOF"
rm -f /data/local/tmp/busybox
rm -rf /data/local/tmp/bb
rm -f /data/local/tmp/neon-busybox-env.sh
cp /sdcard/Download/busybox /data/local/tmp/busybox 2>/dev/null || cat /sdcard/Download/busybox > /data/local/tmp/busybox
chmod 755 /data/local/tmp/busybox
mkdir -p /data/local/tmp/bb
cp /data/local/tmp/busybox /data/local/tmp/bb/busybox
chmod 755 /data/local/tmp/bb/busybox
cd /data/local/tmp/bb
./busybox --install -s .
cat > /data/local/tmp/neon-busybox-env.sh << 'ENVEOF'
export PATH="/data/local/tmp:/data/local/tmp/bb:$PATH"
ENVEOF
chmod 755 /data/local/tmp/neon-busybox-env.sh
export PATH="/data/local/tmp:/data/local/tmp/bb:$PATH"
busybox --help
busybox sh
EOF

cat > /sdcard/Download/neon_core_busybox_env.txt << "EOF"
export PATH="/data/local/tmp:/data/local/tmp/bb:$PATH"
busybox sh
EOF

printf "$G[✓] BusyBox saved successfully$N\n\n"

sleep 1

printf "$G"
cat << "EOF"
  _   _                  ____               
 | \ | | ___  ___  _ __ / ___|___  _ __ ___ 
 |  \| |/ _ \/ _ \| '_ \ |   / _ \| '__/ _ \
 | |\  |  __/ (_) | | | | |__| (_) | | |  __/
 |_| \_|\___|\___/|_| |_|\____\___/|_|  \___|
                                              
              ENGINE READY
EOF
printf "$N"

printf "\n$G[✓] TERMUX SETUP SUCCESS$N\n\n"

printf "$C[•] BusyBox location:$N\n"
printf "$W    /sdcard/Download/busybox$N\n\n"

printf "$C[•] Neon Core Engine setup saved to:$N\n"
printf "$W    /sdcard/Download/neon_core_busybox_setup.txt$N\n\n"

printf "$C[•] Neon Core Engine session shortcut saved to:$N\n"
printf "$W    /sdcard/Download/neon_core_busybox_env.txt$N\n\n"

printf "$C[•] File info:$N\n"
ls -lh /sdcard/Download/busybox

printf "\n$C[•] BusyBox test:$N\n"
/sdcard/Download/busybox --help | head -n 8

printf "\n$Y"
printf "╔════════════════════════════════════════════╗\n"
printf "║    COPY COMMAND BELOW TO NEON CORE ENGINE  ║\n"
printf "╚════════════════════════════════════════════╝\n"
printf "$N\n"

printf "$C"
cat << "EOF"
rm -f /data/local/tmp/busybox
rm -rf /data/local/tmp/bb
rm -f /data/local/tmp/neon-busybox-env.sh
cp /sdcard/Download/busybox /data/local/tmp/busybox 2>/dev/null || cat /sdcard/Download/busybox > /data/local/tmp/busybox
chmod 755 /data/local/tmp/busybox
mkdir -p /data/local/tmp/bb
cp /data/local/tmp/busybox /data/local/tmp/bb/busybox
chmod 755 /data/local/tmp/bb/busybox
cd /data/local/tmp/bb
./busybox --install -s .
cat > /data/local/tmp/neon-busybox-env.sh << 'ENVEOF'
export PATH="/data/local/tmp:/data/local/tmp/bb:$PATH"
ENVEOF
chmod 755 /data/local/tmp/neon-busybox-env.sh
export PATH="/data/local/tmp:/data/local/tmp/bb:$PATH"
busybox --help
busybox sh
EOF
printf "$N\n"

printf "$Y"
printf "╔════════════════════════════════════════════╗\n"
printf "║       COMMAND TEST AFTER INSTALLATION      ║\n"
printf "╚════════════════════════════════════════════╝\n"
printf "$N\n"

printf "$C"
cat << "EOF"
busybox find /sdcard -type f -size +100M
busybox find /sdcard -type f -name "*.apk"
busybox df -h
busybox du -h /sdcard/Download
busybox ps
busybox uname -a
find /sdcard -type f -size +100M
grep --help
awk --help
sed --help
EOF
printf "$N\n"

printf "$Y"
printf "╔════════════════════════════════════════════╗\n"
printf "║      FOR NEXT NEON CORE ENGINE SESSION     ║\n"
printf "╚════════════════════════════════════════════╝\n"
printf "$N\n"

printf "$C"
cat << "EOF"
. /data/local/tmp/neon-busybox-env.sh
busybox sh
EOF
printf "$N\n"

printf "$G[✓] Done. Buka Neon Core Engine lalu paste command setup di atas.$N\n"

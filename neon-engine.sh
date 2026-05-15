#!/system/bin/sh

clear

R="\033[1;31m"
G="\033[1;32m"
Y="\033[1;33m"
B="\033[1;34m"
C="\033[1;36m"
M="\033[1;35m"
W="\033[1;37m"
N="\033[0m"

NEON_URL_BASE="https://raw.githubusercontent.com/Magisk-Modules-Repo/busybox-ndk/master"
NEON_LOCAL="$HOME/.neon-core-engine"
NEON_PUBLIC="/sdcard/Download/.neon-core-engine"
NEON_SETUP="/sdcard/Download/neon-core-setup.sh"
NEON_CMD="sh /sdcard/Download/neon-core-setup.sh"

line() {
  printf "$C━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$N\n"
}

banner() {
  printf "$M"
  cat << "EOF"
 _   _                  ____               
| \ | | ___  ___  _ __ / ___|___  _ __ ___ 
|  \| |/ _ \/ _ \| '_ \ |   / _ \| '__/ _ \
| |\  |  __/ (_) | | | | |__| (_) | | |  __/
|_| \_|\___|\___/|_| |_|\____\___/|_|  \___|
                                            
        N E O N   C O R E   E N G I N E
EOF
  printf "$N"
}

box() {
  printf "$Y"
  printf "╔════════════════════════════════════════════╗\n"
  printf "║          NEON ENGINE INSTALLER            ║\n"
  printf "║        TERMUX TO ANDROID SHELL KIT         ║\n"
  printf "╚════════════════════════════════════════════╝\n"
  printf "$N"
}

banner
box
printf "\n"

printf "$W[•] Developer  : Agung Dev$N\n"
printf "$W[•] Repository : agungputraa/ShModule$N\n"
printf "$W[•] Engine     : Neon Core Engine$N\n"
printf "$W[•] Output     : $NEON_SETUP$N\n\n"

sleep 1
line

printf "$B[1/6] Detecting device platform...$N\n"

ABI="$(getprop ro.product.cpu.abi 2>/dev/null)"

if [ "$ABI" = "arm64-v8a" ]; then
  NEON_FILE="busybox-arm64"
elif [ "$ABI" = "armeabi-v7a" ] || [ "$ABI" = "armeabi" ]; then
  NEON_FILE="busybox-arm"
elif [ "$ABI" = "x86" ]; then
  NEON_FILE="busybox-x86"
elif [ "$ABI" = "x86_64" ]; then
  NEON_FILE="busybox-x86_64"
else
  NEON_FILE="busybox-arm64"
fi

printf "$G[✓] Platform detected : ${ABI:-unknown}$N\n"
printf "$G[✓] Engine package    : ready$N\n\n"

sleep 1
line

printf "$B[2/6] Checking storage access...$N\n"

if [ ! -d "/sdcard/Download" ]; then
  termux-setup-storage
  sleep 2
fi

if [ ! -d "/sdcard/Download" ]; then
  printf "$R[!] Storage belum aktif.$N\n"
  printf "$Y[!] Izinkan akses storage Termux, lalu jalankan ulang.$N\n"
  exit 1
fi

printf "$G[✓] Storage ready$N\n\n"

sleep 1
line

printf "$B[3/6] Checking downloader...$N\n"

DOWNLOADER=""

if command -v curl >/dev/null 2>&1; then
  DOWNLOADER="curl"
elif command -v wget >/dev/null 2>&1; then
  DOWNLOADER="wget"
else
  printf "$R[!] Downloader tidak ditemukan.$N\n"
  printf "$Y[!] Jalankan salah satu command ini:$N\n"
  printf "$W    pkg install curl -y$N\n"
  printf "$W    pkg install wget -y$N\n"
  exit 1
fi

printf "$G[✓] Downloader ready : $DOWNLOADER$N\n\n"

sleep 1
line

printf "$B[4/6] Preparing clean installation...$N\n"

cd "$HOME" || exit 1

rm -f "$NEON_LOCAL"
rm -f "$NEON_PUBLIC"
rm -f "$NEON_SETUP"
rm -f /sdcard/Download/neon-core-start.sh

printf "$G[✓] Clean install ready$N\n\n"

sleep 1
line

printf "$B[5/6] Downloading Neon Core Engine package...$N\n"

NEON_DOWNLOAD_URL="$NEON_URL_BASE/$NEON_FILE"

if [ "$DOWNLOADER" = "curl" ]; then
  curl -L "$NEON_DOWNLOAD_URL" -o "$NEON_LOCAL"
else
  wget -O "$NEON_LOCAL" "$NEON_DOWNLOAD_URL"
fi

if [ ! -f "$NEON_LOCAL" ]; then
  printf "$R[!] Download gagal.$N\n"
  printf "$Y[!] Cek koneksi internet lalu jalankan ulang.$N\n"
  exit 1
fi

chmod 755 "$NEON_LOCAL"

if ! "$NEON_LOCAL" --help >/dev/null 2>&1; then
  printf "$R[!] Engine package tidak bisa dijalankan.$N\n"
  printf "$Y[!] Kemungkinan paket tidak cocok dengan device ini.$N\n"
  exit 1
fi

cp "$NEON_LOCAL" "$NEON_PUBLIC"
chmod 755 "$NEON_PUBLIC"

printf "$G[✓] Neon Core Engine package ready$N\n\n"

sleep 1
line

printf "$B[6/6] Creating Neon Core Engine setup command...$N\n"

cat > "$NEON_SETUP" << "EOF"
#!/system/bin/sh

clear

R="\033[1;31m"
G="\033[1;32m"
Y="\033[1;33m"
B="\033[1;34m"
C="\033[1;36m"
M="\033[1;35m"
W="\033[1;37m"
N="\033[0m"

ENGINE_SRC="/sdcard/Download/.neon-core-engine"
ENGINE_MAIN="/data/local/tmp/.neon-core-engine"
ENGINE_HOME="/data/local/tmp/neon-core"
ENGINE_BIN="/data/local/tmp/neon-core/bin"
ENGINE_ENV="/data/local/tmp/neon-core/env.sh"

printf "$M"
cat << "BANNER"
 _   _                  ____               
| \ | | ___  ___  _ __ / ___|___  _ __ ___ 
|  \| |/ _ \/ _ \| '_ \ |   / _ \| '__/ _ \
| |\  |  __/ (_) | | | | |__| (_) | | |  __/
|_| \_|\___|\___/|_| |_|\____\___/|_|  \___|
                                            
        N E O N   C O R E   E N G I N E
BANNER
printf "$N\n"

printf "$C━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$N\n"
printf "$B[1/5] Resetting old engine files...$N\n"

rm -rf "$ENGINE_HOME"
rm -f "$ENGINE_MAIN"
rm -f /data/local/tmp/neon

printf "$G[✓] Reset complete$N\n\n"

printf "$C━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$N\n"
printf "$B[2/5] Installing engine core...$N\n"

if [ ! -f "$ENGINE_SRC" ]; then
  printf "$R[!] Engine package tidak ditemukan.$N\n"
  printf "$Y[!] Jalankan installer dari Termux terlebih dahulu.$N\n"
  exit 1
fi

cp "$ENGINE_SRC" "$ENGINE_MAIN" 2>/dev/null || cat "$ENGINE_SRC" > "$ENGINE_MAIN"
chmod 755 "$ENGINE_MAIN"

if ! "$ENGINE_MAIN" --help >/dev/null 2>&1; then
  printf "$R[!] Engine core gagal dijalankan.$N\n"
  exit 1
fi

printf "$G[✓] Engine core installed$N\n\n"

printf "$C━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$N\n"
printf "$B[3/5] Creating Neon shortcuts...$N\n"

mkdir -p "$ENGINE_BIN"

cp "$ENGINE_MAIN" "$ENGINE_BIN/.core"
chmod 755 "$ENGINE_BIN/.core"

cd "$ENGINE_BIN" || exit 1
./.core --install -s .

cat > "$ENGINE_BIN/neon" << "NEONEOF"
#!/system/bin/sh

CORE="/data/local/tmp/neon-core/bin/.core"

if [ "$1" = "" ]; then
  echo "Neon Core Engine"
  echo ""
  echo "Usage:"
  echo "  neon shell"
  echo "  neon find /sdcard -type f -size +100M"
  echo "  neon wget --help"
  echo "  neon df -h"
  echo "  neon ps"
  echo ""
  exit 0
fi

if [ "$1" = "shell" ]; then
  exec "$CORE" sh
fi

exec "$CORE" "$@"
NEONEOF

chmod 755 "$ENGINE_BIN/neon"
ln -sf "$ENGINE_BIN/neon" /data/local/tmp/neon

printf "$G[✓] Shortcut created: neon$N\n\n"

printf "$C━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$N\n"
printf "$B[4/5] Activating Neon environment...$N\n"

cat > "$ENGINE_ENV" << "ENVEOF"
export PATH="/data/local/tmp/neon-core/bin:/data/local/tmp:$PATH"
ENVEOF

chmod 755 "$ENGINE_ENV"

export PATH="/data/local/tmp/neon-core/bin:/data/local/tmp:$PATH"

printf "$G[✓] Environment activated$N\n\n"

printf "$C━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$N\n"
printf "$B[5/5] Finalizing setup...$N\n"

printf "$G[✓] Neon Core Engine is ready$N\n\n"

printf "$WAvailable commands:$N\n"
printf "$C  neon$N\n"
printf "$C  neon shell$N\n"
printf "$C  neon find$N\n"
printf "$C  neon wget$N\n"
printf "$C  neon df$N\n"
printf "$C  neon ps$N\n"
printf "$C  find$N\n"
printf "$C  grep$N\n"
printf "$C  awk$N\n"
printf "$C  sed$N\n"
printf "$C  wget$N\n"
printf "$C  tar$N\n"
printf "$C  unzip$N\n\n"

printf "$YUntuk sesi berikutnya, jalankan:$N\n"
printf "$W. /data/local/tmp/neon-core/env.sh$N\n\n"

printf "$GOpening Neon shell...$N\n"
neon shell
EOF

chmod 755 "$NEON_SETUP"

cat > /sdcard/Download/neon-core-start.sh << "EOF"
#!/system/bin/sh
. /data/local/tmp/neon-core/env.sh
neon shell
EOF

chmod 755 /sdcard/Download/neon-core-start.sh

if command -v termux-clipboard-set >/dev/null 2>&1; then
  printf "$NEON_CMD" | termux-clipboard-set
  CLIP_STATUS="copied"
else
  CLIP_STATUS="manual"
fi

printf "$G[✓] Setup command created$N\n\n"

sleep 1
line

printf "$G"
cat << "EOF"
 ____                 _       
|  _ \ ___  __ _  __| |_   _ 
| |_) / _ \/ _` |/ _` | | | |
|  _ <  __/ (_| | (_| | |_| |
|_| \_\___|\__,_|\__,_|\__, |
                        |___/ 
EOF
printf "$N"

printf "\n$G[✓] TERMUX SETUP SUCCESS$N\n\n"

printf "$C[•] Neon Core Engine setup file:$N\n"
printf "$W    $NEON_SETUP$N\n\n"

printf "$Y"
printf "╔════════════════════════════════════════════╗\n"
printf "║       RUN THIS IN NEON CORE ENGINE         ║\n"
printf "╚════════════════════════════════════════════╝\n"
printf "$N\n"

printf "$C$NEON_CMD$N\n\n"

if [ "$CLIP_STATUS" = "copied" ]; then
  printf "$G[✓] Command sudah dicopy ke clipboard.$N\n"
else
  printf "$Y[!] Copy satu baris command di atas.$N\n"
fi

printf "$G[✓] Done.$N\n"

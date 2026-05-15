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

BASE_URL="https://raw.githubusercontent.com/Magisk-Modules-Repo/busybox-ndk/master"
LOCAL_ENGINE="$HOME/.neon-core-engine"
PUBLIC_ENGINE="/sdcard/Download/.neon-core-engine"
SETUP_FILE="/sdcard/Download/neon-core-setup.sh"
RUN_CMD="sh /sdcard/Download/neon-core-setup.sh"

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

banner
printf "\n"

printf "$Y"
printf "╔════════════════════════════════════════════╗\n"
printf "║          NEON ENGINE INSTALLER            ║\n"
printf "║        TERMUX TO ANDROID SHELL KIT         ║\n"
printf "╚════════════════════════════════════════════╝\n"
printf "$N\n"

printf "$W[•] Developer  : Agung Dev$N\n"
printf "$W[•] Repository : agungputraa/ShModule$N\n"
printf "$W[•] Engine     : Neon Core Engine$N\n"
printf "$W[•] Output     : $SETUP_FILE$N\n\n"

sleep 1
line

printf "$B[1/6] Detecting device platform...$N\n"

ABI="$(getprop ro.product.cpu.abi 2>/dev/null)"

case "$ABI" in
  arm64-v8a)
    ENGINE_FILE="busybox-arm64"
    ;;
  armeabi-v7a|armeabi)
    ENGINE_FILE="busybox-arm"
    ;;
  x86)
    ENGINE_FILE="busybox-x86"
    ;;
  x86_64)
    ENGINE_FILE="busybox-x86_64"
    ;;
  *)
    ENGINE_FILE="busybox-arm64"
    ;;
esac

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

if command -v curl >/dev/null 2>&1; then
  DOWNLOADER="curl"
elif command -v wget >/dev/null 2>&1; then
  DOWNLOADER="wget"
else
  printf "$R[!] Downloader tidak ditemukan.$N\n"
  printf "$Y[!] Jalankan:$N\n"
  printf "$W    pkg install curl -y$N\n"
  exit 1
fi

printf "$G[✓] Downloader ready : $DOWNLOADER$N\n\n"

sleep 1
line

printf "$B[4/6] Preparing clean installation...$N\n"

cd "$HOME" || exit 1

rm -f "$LOCAL_ENGINE"
rm -f "$PUBLIC_ENGINE"
rm -f "$SETUP_FILE"
rm -f /sdcard/Download/neon-core-start.sh

printf "$G[✓] Clean install ready$N\n\n"

sleep 1
line

printf "$B[5/6] Downloading Neon Core Engine package...$N\n"

DOWNLOAD_URL="$BASE_URL/$ENGINE_FILE"

if [ "$DOWNLOADER" = "curl" ]; then
  curl -L --fail --progress-bar "$DOWNLOAD_URL" -o "$LOCAL_ENGINE"
else
  wget -q --show-progress -O "$LOCAL_ENGINE" "$DOWNLOAD_URL"
fi

if [ ! -f "$LOCAL_ENGINE" ]; then
  printf "$R[!] Download gagal.$N\n"
  printf "$Y[!] Cek koneksi internet lalu jalankan ulang.$N\n"
  exit 1
fi

SIZE="$(wc -c < "$LOCAL_ENGINE" 2>/dev/null)"

if [ -z "$SIZE" ] || [ "$SIZE" -lt 100000 ]; then
  printf "$R[!] File engine tidak valid.$N\n"
  printf "$Y[!] Jalankan ulang installer.$N\n"
  rm -f "$LOCAL_ENGINE"
  exit 1
fi

chmod 755 "$LOCAL_ENGINE"
cp "$LOCAL_ENGINE" "$PUBLIC_ENGINE"
chmod 755 "$PUBLIC_ENGINE"

printf "$G[✓] Neon Core Engine package ready$N\n\n"

sleep 1
line

printf "$B[6/6] Creating Neon Core Engine setup file...$N\n"

cat > "$SETUP_FILE" << 'SETUPEOF'
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

SRC="/sdcard/Download/.neon-core-engine"
CORE="/data/local/tmp/.neon-core-engine"
HOME_DIR="/data/local/tmp/neon-core"
BIN_DIR="/data/local/tmp/neon-core/bin"
ENV_FILE="/data/local/tmp/neon-core/env.sh"

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

rm -rf "$HOME_DIR"
rm -f "$CORE"
rm -f /data/local/tmp/neon

printf "$G[✓] Reset complete$N\n\n"

printf "$C━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$N\n"
printf "$B[2/5] Installing engine core...$N\n"

if [ ! -f "$SRC" ]; then
  printf "$R[!] Engine package tidak ditemukan.$N\n"
  printf "$Y[!] Jalankan installer dari Termux terlebih dahulu.$N\n"
  exit 1
fi

cp "$SRC" "$CORE" 2>/dev/null || cat "$SRC" > "$CORE"
chmod 755 "$CORE"

if ! "$CORE" --help >/dev/null 2>&1; then
  printf "$R[!] Engine core gagal dijalankan di Android shell.$N\n"
  printf "$Y[!] File ada, tapi tidak bisa dieksekusi di sesi ini.$N\n"
  exit 1
fi

printf "$G[✓] Engine core installed$N\n\n"

printf "$C━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$N\n"
printf "$B[3/5] Creating Neon shortcuts...$N\n"

mkdir -p "$BIN_DIR"

cp "$CORE" "$BIN_DIR/.core"
chmod 755 "$BIN_DIR/.core"

cd "$BIN_DIR" || exit 1
./.core --install -s .

cat > "$BIN_DIR/neon" << 'NEONEOF'
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
  exit 0
fi

if [ "$1" = "shell" ]; then
  exec "$CORE" sh
fi

exec "$CORE" "$@"
NEONEOF

chmod 755 "$BIN_DIR/neon"
ln -sf "$BIN_DIR/neon" /data/local/tmp/neon

printf "$G[✓] Shortcut created: neon$N\n\n"

printf "$C━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$N\n"
printf "$B[4/5] Activating Neon environment...$N\n"

cat > "$ENV_FILE" << 'ENVEOF'
export PATH="/data/local/tmp/neon-core/bin:/data/local/tmp:$PATH"
ENVEOF

chmod 755 "$ENV_FILE"

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
SETUPEOF

chmod 755 "$SETUP_FILE"

cat > /sdcard/Download/neon-core-start.sh << 'STARTEOF'
#!/system/bin/sh
. /data/local/tmp/neon-core/env.sh
neon shell
STARTEOF

chmod 755 /sdcard/Download/neon-core-start.sh

if command -v termux-clipboard-set >/dev/null 2>&1; then
  printf "%s" "$RUN_CMD" | termux-clipboard-set
  CLIP_STATUS="copied"
else
  CLIP_STATUS="manual"
fi

printf "$G[✓] Setup file created$N\n\n"

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
printf "$W    $SETUP_FILE$N\n\n"

printf "$Y"
printf "╔════════════════════════════════════════════╗\n"
printf "║       RUN THIS IN NEON CORE ENGINE         ║\n"
printf "╚════════════════════════════════════════════╝\n"
printf "$N\n"

printf "$C$RUN_CMD$N\n\n"

if [ "$CLIP_STATUS" = "copied" ]; then
  printf "$G[✓] Command sudah dicopy ke clipboard.$N\n"
else
  printf "$Y[!] Copy satu baris command di atas.$N\n"
fi

printf "$G[✓] Done.$N\n"

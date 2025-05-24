#!/bin/bash

BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN='\033[0;36m' # Menambahkan definisi CYAN
NC="\e[0m"

SWARM_DIR="$HOME/rl-swarm"
TEMP_DATA_PATH="$SWARM_DIR/modal-login/temp-data"
HOME_DIR="$HOME"

# Fungsi untuk menangani pencarian Python atau memberikan instruksi instalasi
check_and_guide_python_install() {
    DESIRED_PYTHON_VERSION="3.13"
    PYTHON_BIN_CANDIDATE="python${DESIRED_PYTHON_VERSION}"

    echo -e "${CYAN}${BOLD}[✓] Mencari interpreter Python...${NC}"

    if command -v $PYTHON_BIN_CANDIDATE &>/dev/null; then
        PYTHON_BIN=$PYTHON_BIN_CANDIDATE
        echo -e "${GREEN}${BOLD}[✓] Python ${DESIRED_PYTHON_VERSION} ditemukan: $PYTHON_BIN ($($PYTHON_BIN --version 2>&1))${NC}"
        return 0 # Python 3.13 ditemukan
    elif command -v python3.12 &>/dev/null; then
        PYTHON_BIN=python3.12
        echo -e "${YELLOW}${BOLD}[!] Python ${DESIRED_PYTHON_VERSION} tidak ditemukan.${NC}"
        echo -e "${CYAN}${BOLD}[✓] Menggunakan python3.12 sebagai fallback: $PYTHON_BIN ($($PYTHON_BIN --version 2>&1))${NC}"
    elif command -v python3.10 &>/dev/null; then
        PYTHON_BIN=python3.10
        echo -e "${YELLOW}${BOLD}[!] Python ${DESIRED_PYTHON_VERSION} tidak ditemukan.${NC}"
        echo -e "${CYAN}${BOLD}[✓] Menggunakan python3.10 sebagai fallback: $PYTHON_BIN ($($PYTHON_BIN --version 2>&1))${NC}"
    elif command -v python3 &>/dev/null; then
        PYTHON_BIN=python3
        echo -e "${YELLOW}${BOLD}[!] Python ${DESIRED_PYTHON_VERSION} tidak ditemukan.${NC}"
        echo -e "${CYAN}${BOLD}[✓] Menggunakan python3 sebagai fallback: $PYTHON_BIN ($($PYTHON_BIN --version 2>&1))${NC}"
    else
        echo -e "${RED}${BOLD}[✗] Tidak ada interpreter Python 3 yang cocok ditemukan.${NC}"
        echo -e "${YELLOW}Skrip ini sangat merekomendasikan Python ${DESIRED_PYTHON_VERSION}.${NC}"
        echo -e "${YELLOW}Silakan instal Python ${DESIRED_PYTHON_VERSION} menggunakan salah satu metode berikut di terminal terpisah, lalu jalankan kembali skrip ini:${NC}"
        echo -e "\n  ${BOLD}Metode 1: Menggunakan pyenv (direkomendasikan untuk Linux):${NC}"
        echo -e "    1. Instal pyenv: \`curl https://pyenv.run | bash\` (ikuti instruksi untuk PATH)"
        echo -e "    2. Instal dependensi build (contoh untuk Ubuntu/Debian):"
        echo -e "       \`sudo apt update && sudo apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl\`"
        echo -e "    3. Instal Python ${DESIRED_PYTHON_VERSION}: \`pyenv install ${DESIRED_PYTHON_VERSION}.x\` (ganti .x dengan versi patch terbaru)"
        echo -e "    4. Atur versi: \`pyenv global ${DESIRED_PYTHON_VERSION}.x\` atau \`cd ke_direktori_proyek && pyenv local ${DESIRED_PYTHON_VERSION}.x\`"
        echo -e "\n  ${BOLD}Metode 2: Untuk Ubuntu/Debian menggunakan PPA deadsnakes:${NC}"
        echo -e "    \`sudo add-apt-repository ppa:deadsnakes/ppa && sudo apt update\`"
        echo -e "    \`sudo apt install python${DESIRED_PYTHON_VERSION} python${DESIRED_PYTHON_VERSION}-venv python${DESIRED_PYTHON_VERSION}-pip python${DESIRED_PYTHON_VERSION}-dev\`"
        echo -e "\nSetelah instalasi, pastikan \`python${DESIRED_PYTHON_VERSION}\` ada di PATH Anda."
        exit 1
    fi
    # Memberi peringatan jika versi fallback yang digunakan
    if [[ "$PYTHON_BIN" != "$PYTHON_BIN_CANDIDATE" ]]; then
        echo -e "${YELLOW}${BOLD}[!] PERINGATAN: Untuk fungsionalitas dan kompatibilitas terbaik, sangat disarankan untuk menginstal dan menggunakan Python ${DESIRED_PYTHON_VERSION}.${NC}"
    fi
    return 1 # Python versi lain yang akan digunakan (bukan 3.13)
}

cd "$HOME" || exit # Pindah ke home directory atau keluar jika gagal

# --- Penanganan Direktori rl-swarm ---
if [ -d "$SWARM_DIR" ] && [ -f "$SWARM_DIR/swarm.pem" ]; then
    echo -e "${BOLD}${YELLOW}Anda sudah memiliki file ${GREEN}swarm.pem${YELLOW} di direktori ${GREEN}$SWARM_DIR${YELLOW}.${NC}\n"
    echo -e "${BOLD}${YELLOW}Apakah Anda ingin:${NC}"
    echo -e "${BOLD}1) Menggunakan swarm.pem yang ada (repositori akan di-refresh)${NC}"
    echo -e "${BOLD}${RED}2) Menghapus semua dan memulai dari awal${NC}"

    while true; do
        read -p $'\e[1mMasukkan pilihan Anda (1 atau 2): \e[0m' choice
        if [ "$choice" == "1" ]; then
            echo -e "\n${BOLD}${YELLOW}[✓] Menggunakan swarm.pem yang ada dan me-refresh repositori...${NC}"
            # Backup data penting
            mkdir -p "$HOME_DIR/temp_swarm_backup"
            mv "$SWARM_DIR/swarm.pem" "$HOME_DIR/temp_swarm_backup/"
            # Hanya pindahkan jika ada, abaikan error jika tidak ada
            mv "$TEMP_DATA_PATH/userData.json" "$HOME_DIR/temp_swarm_backup/" 2>/dev/null
            mv "$TEMP_DATA_PATH/userApiKey.json" "$HOME_DIR/temp_swarm_backup/" 2>/dev/null

            # Hapus direktori swarm lama
            rm -rf "$SWARM_DIR"

            echo -e "${BOLD}${YELLOW}[✓] Mengkloning repositori baru ke $SWARM_DIR...${NC}"
            if git clone https://github.com/Alvinagustus/rl-swarm.git "$SWARM_DIR" > /dev/null 2>&1; then
                # Buat struktur direktori yang diperlukan di repo baru
                mkdir -p "$SWARM_DIR/modal-login/temp-data"
                # Kembalikan file yang dibackup
                mv "$HOME_DIR/temp_swarm_backup/swarm.pem" "$SWARM_DIR/"
                mv "$HOME_DIR/temp_swarm_backup/userData.json" "$SWARM_DIR/modal-login/temp-data/" 2>/dev/null
                mv "$HOME_DIR/temp_swarm_backup/userApiKey.json" "$SWARM_DIR/modal-login/temp-data/" 2>/dev/null
                rm -rf "$HOME_DIR/temp_swarm_backup" # Hapus backup
                echo -e "${GREEN}${BOLD}[✓] Repositori berhasil di-refresh dan data dikembalikan.${NC}"
            else
                echo -e "${BOLD}${RED}[✗] Gagal mengkloning repositori baru. Membatalkan...${NC}"
                # Logika pemulihan jika kloning gagal (opsional, bisa kompleks)
                # Untuk saat ini, kita akan keluar.
                rm -rf "$HOME_DIR/temp_swarm_backup" # Hapus backup
                exit 1
            fi
            break
        elif [ "$choice" == "2" ]; then
            echo -e "\n${BOLD}${YELLOW}[✓] Menghapus folder $SWARM_DIR dan memulai dari awal...${NC}"
            rm -rf "$SWARM_DIR"
            echo -e "${BOLD}${YELLOW}[✓] Mengkloning repositori baru ke $SWARM_DIR...${NC}"
            if ! git clone https://github.com/Alvinagustus/rl-swarm.git "$SWARM_DIR" > /dev/null 2>&1; then
                 echo -e "${BOLD}${RED}[✗] Gagal mengkloning repositori. Keluar.${NC}"
                 exit 1
            fi
            echo -e "${GREEN}${BOLD}[✓] Repositori berhasil dikloning.${NC}"
            break
        else
            echo -e "\n${BOLD}${RED}[✗] Pilihan tidak valid. Silakan masukkan 1 atau 2.${NC}"
        fi
    done
elif [ -d "$SWARM_DIR" ]; then # Direktori ada tapi swarm.pem tidak ada di root-nya
    echo -e "${BOLD}${YELLOW}[!] Direktori $SWARM_DIR ada tetapi tidak ada swarm.pem di dalamnya.${NC}"
    echo -e "${BOLD}${YELLOW}    Menghapus direktori $SWARM_DIR dan mengkloning ulang untuk memastikan konsistensi...${NC}"
    rm -rf "$SWARM_DIR"
    echo -e "${BOLD}${YELLOW}[✓] Mengkloning repositori baru ke $SWARM_DIR...${NC}"
    if ! git clone https://github.com/Alvinagustus/rl-swarm.git "$SWARM_DIR" > /dev/null 2>&1; then
        echo -e "${BOLD}${RED}[✗] Gagal mengkloning repositori. Keluar.${NC}"
        exit 1
    fi
    echo -e "${GREEN}${BOLD}[✓] Repositori berhasil dikloning.${NC}"
else # Direktori SWARM_DIR tidak ada
    echo -e "${BOLD}${YELLOW}[✓] Direktori $SWARM_DIR tidak ditemukan. Mengkloning repositori baru...${NC}"
    if ! git clone https://github.com/Alvinagustus/rl-swarm.git "$SWARM_DIR" > /dev/null 2>&1; then
        echo -e "${BOLD}${RED}[✗] Gagal mengkloning repositori. Keluar.${NC}"
        exit 1
    fi
    echo -e "${GREEN}${BOLD}[✓] Repositori berhasil dikloning.${NC}"
fi

# Pindah ke direktori rl-swarm
cd "$SWARM_DIR" || { echo -e "${BOLD}${RED}[✗] Gagal masuk ke direktori $SWARM_DIR. Keluar.${NC}"; exit 1; }

# --- Penanganan Virtual Environment ---
if [ -n "$VIRTUAL_ENV" ]; then # Cek apakah sedang di dalam venv
    echo -e "\n${CYAN}${BOLD}[✓] Menonaktifkan lingkungan virtual yang aktif saat ini...${NC}"
    deactivate || echo -e "${YELLOW}[!] Gagal menonaktifkan lingkungan virtual (mungkin tidak dikelola oleh 'deactivate' standar).${NC}"
fi

# Hapus direktori .venv lama jika ada, untuk memastikan venv baru yang bersih
if [ -d ".venv" ]; then
    echo -e "${CYAN}${BOLD}[✓] Menghapus direktori .venv yang ada untuk setup baru...${NC}"
    rm -rf .venv
fi

echo -e "\n${CYAN}${BOLD}[✓] Memulai setup lingkungan virtual...${NC}"

# Panggil fungsi untuk mencari Python atau memberikan instruksi instalasi
check_and_guide_python_install
# Variabel PYTHON_BIN diatur di dalam fungsi check_and_guide_python_install

# Setup venv
echo -e "${CYAN}${BOLD}[✓] Membuat lingkungan virtual di .venv menggunakan $PYTHON_BIN...${NC}"
if $PYTHON_BIN -m venv .venv; then
    echo -e "${GREEN}${BOLD}[✓] Lingkungan virtual berhasil dibuat.${NC}"
    echo -e "${CYAN}${BOLD}[✓] Mengaktifkan lingkungan virtual dan mengupgrade pip...${NC}"
    
    source .venv/bin/activate
    if [ $? -ne 0 ]; then
        echo -e "${RED}${BOLD}[✗] Gagal mengaktifkan lingkungan virtual! Periksa output di atas.${NC}"
        exit 1
    fi
    
    if pip install --upgrade pip; then
        echo -e "${GREEN}${BOLD}[✓] Pip berhasil diupgrade.${NC}"
        echo -e "${GREEN}${BOLD}[✓] Setup lingkungan virtual selesai.${NC}"
    else
        echo -e "${RED}${BOLD}[✗] Gagal mengupgrade pip! Melanjutkan dengan pip yang ada...${NC}"
        # Anda bisa memilih untuk keluar jika upgrade pip adalah krusial:
        # exit 1 
    fi
else
    echo -e "${RED}${BOLD}[✗] Gagal membuat lingkungan virtual dengan $PYTHON_BIN.${NC}"
    exit 1
fi

# --- Eksekusi Skrip Utama ---
echo -e "\n${BOLD}${YELLOW}[?] Pilih metode koneksi untuk RL-SWARM:${NC}"
echo -e "${BOLD}1) Cloudflared${NC}"
echo -e "${BOLD}2) Ngrok${NC}"
read -p $'\e[1mPilih (1 atau 2): \e[0m' pilihan

# Export variabel lingkungan sebelum menjalankan skrip
export PYTORCH_MPS_HIGH_WATERMARK_RATIO=0.0

if [[ "$pilihan" == "1" ]]; then
    echo -e "\n${BOLD}${YELLOW}[✓] Menjalankan RL-SWARM dengan Cloudflared (CPU_ONLY=true)...${NC}"
    if [ -f "./run_rl_swarm.sh" ]; then
        chmod +x ./run_rl_swarm.sh
        CPU_ONLY=true ./run_rl_swarm.sh
    else
        echo -e "${RED}${BOLD}[✗] Skrip ./run_rl_swarm.sh tidak ditemukan!${NC}"
        exit 1
    fi
elif [[ "$pilihan" == "2" ]]; then
    echo -e "\n${BOLD}${YELLOW}[✓] Menjalankan RL-SWARM dengan Ngrok (CPU_ONLY=true)...${NC}"
    if [ -f "./run_rl_swarm.sh" ]; then
        chmod +x ./run_rl_swarm.sh
        CPU_ONLY=true ./run_rl_swarm.sh
    else
        echo -e "${RED}${BOLD}[✗] Skrip ./run_rl_swarm.sh tidak ditemukan!${NC}"
        exit 1
    fi
else
    echo -e "\n${BOLD}${RED}[!] Pilihan tidak valid. Keluar.${NC}"
    exit 1
fi

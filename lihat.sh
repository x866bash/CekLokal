#!/bin/bash

# ===============================
#  GitHub Repo Scanner All Tools
# ===============================

# Warna & efek
GREEN="\e[32m"
CYAN="\e[36m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"
BOLD="\e[1m"
BLINK="\e[5m"

OUTPUT_JSON="repos_scan.json"
LOGFILE="repos_scan.log"
> "$OUTPUT_JSON"
> "$LOGFILE"

# Simpan semua output ke log juga
exec > >(tee -a "$LOGFILE") 2>&1

# Timer mulai
start_time=$(date +%s)

# Banner awal
echo -e "${CYAN}${BOLD}"
echo "════════════════════════════════════════════════════════════"
echo "     🚀 GitHub Local Repo Scanner + System Info Tool 🚀     "
echo "════════════════════════════════════════════════════════════"
echo -e "${RESET}"

# Info user singkat
echo -e "${CYAN}User      : ${YELLOW}$(whoami)${RESET}"
echo -e "${CYAN}Hostname  : ${YELLOW}$(hostname)${RESET}"
echo -e "${CYAN}Tanggal   : ${YELLOW}$(date)${RESET}"
echo -e "${CYAN}Direktori : ${YELLOW}$(pwd)${RESET}"
echo

# Animasi scanning (FIX double "ESAI!!")
animate_progress() {
    local progress=0
    while [ $progress -le 100 ]; do
        local bar=""
        local blocks=$((progress / 20))

        for i in $(seq 1 5); do
            if [ $i -le $blocks ]; then
                bar+=" ${BLINK}${GREEN}█${RESET}"
            else
                bar+=" ░"
            fi
        done

        if [ $progress -ge 100 ]; then
            msg="${GREEN}✅ SELESAI!!${RESET}"
        elif [ $progress -ge 80 ]; then
            msg="${YELLOW}⚡ HAMPIR SELESAI!!${RESET}"
        else
            msg=""
        fi

        # Hapus line sebelumnya lalu tulis ulang
        echo -ne "\r$(tput el)"
        echo -ne "📂 ${CYAN}Scanning Project/Repo GitHub Lokal...${RESET} [$bar] $progress% $msg"

        sleep 0.1
        ((progress+=2))
    done
    echo
    echo -e "${CYAN}════════════════════════════════════════════════════════════${RESET}"
}

# Fungsi deteksi bahasa/script utama
detect_language() {
    local path="$1"
    if [ -f "$path/package.json" ]; then
        echo "NodeJS"
    elif ls "$path"/*.py >/dev/null 2>&1; then
        echo "Python"
    elif ls "$path"/*.php >/dev/null 2>&1; then
        echo "PHP"
    elif ls "$path"/*.sh >/dev/null 2>&1; then
        echo "Shell Script"
    elif ls "$path"/*.js >/dev/null 2>&1; then
        echo "JavaScript"
    elif ls "$path/Dockerfile" >/dev/null 2>&1; then
        echo "Docker"
    else
        echo "Unknown"
    fi
}

# Mulai JSON
echo "{" >> "$OUTPUT_JSON"
echo "  \"repos\": [" >> "$OUTPUT_JSON"

# Jalankan animasi progress
animate_progress

# Scan repo lokal
repos=$(find /root /home -type d -name ".git" 2>/dev/null | sed 's|/.git||')

repo_count=0
if [ -z "$repos" ]; then
    echo -e "${RED}❌ Tidak ada project GitHub ditemukan${RESET}"
else
    echo -e "${BOLD}${GREEN}📂 Project/Repo GitHub Lokal Ditemukan:${RESET}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${RESET}"
    printf "${YELLOW}%-20s %-50s %-20s %-15s${RESET}\n" "Nama" "Path" "Waktu" "Bahasa"

    first=true
    for repo in $repos; do
        name=$(basename "$repo")
        path="$repo"
        waktu=$(stat -c %y "$repo" | cut -d'.' -f1)
        bahasa=$(detect_language "$repo")
        ((repo_count++))

        printf "%-20s %-50s %-20s %-15s\n" "$name" "$path" "$waktu" "$bahasa"

        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$OUTPUT_JSON"
        fi

        echo "    {\"name\": \"$name\", \"path\": \"$path\", \"waktu\": \"$waktu\", \"bahasa\": \"$bahasa\"}" >> "$OUTPUT_JSON"
    done
fi

# Tutup array repos
echo "  ]," >> "$OUTPUT_JSON"

# Daftar tools terinstall
echo
echo -e "${BOLD}${GREEN}📦 Daftar Tools Terinstall (dpkg):${RESET}"
echo -e "${CYAN}════════════════════════════════════════════════════════════${RESET}"
dpkg-query -W -f='${Package}\t${Version}\n' | head -n 20 | column -t
tools_count=$(dpkg-query -W -f='${Package}\n' | head -n 20 | wc -l)

# Tambahkan ke JSON
echo "  \"tools\": [" >> "$OUTPUT_JSON"
dpkg-query -W -f='${Package}\t${Version}\n' | head -n 20 | \
    awk -F"\t" '{printf "    {\"name\": \"%s\", \"version\": \"%s\"},\n", $1, $2}' >> "$OUTPUT_JSON"
sed -i '$ s/,$//' "$OUTPUT_JSON"
echo "  ]," >> "$OUTPUT_JSON"

# Informasi disk
echo
echo -e "${BOLD}${GREEN}💾 Informasi Disk:${RESET}"
echo -e "${CYAN}════════════════════════════════════════════════════════════${RESET}"
df_out=$(df -h / | awk 'NR==2 {print $2, $3, $4, $5}')
total=$(echo $df_out | awk '{print $1}')
used=$(echo $df_out | awk '{print $2}')
avail=$(echo $df_out | awk '{print $3}')
percent=$(echo $df_out | awk '{print $4}')

echo -e "Total   : ${YELLOW}$total${RESET}"
echo -e "Terisi  : ${YELLOW}$used${RESET}"
echo -e "Sisa    : ${YELLOW}$avail${RESET}"
echo -e "Persen  : ${YELLOW}$percent${RESET}"

# Tambahkan ke JSON
echo "  \"disk\": {\"total\": \"$total\", \"used\": \"$used\", \"avail\": \"$avail\", \"percent\": \"$percent\"}," >> "$OUTPUT_JSON"

# Informasi sistem
echo
echo -e "${BOLD}${GREEN}🖥️  Informasi Sistem:${RESET}"
echo -e "${CYAN}════════════════════════════════════════════════════════════${RESET}"
hostname=$(hostname)
os=$(lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")
kernel=$(uname -r)
uptime_info=$(uptime -p)

echo -e "Hostname : ${YELLOW}$hostname${RESET}"
echo -e "OS       : ${YELLOW}$os${RESET}"
echo -e "Kernel   : ${YELLOW}$kernel${RESET}"
echo -e "Uptime   : ${YELLOW}$uptime_info${RESET}"

# Tambahkan ke JSON
echo "  \"system\": {\"hostname\": \"$hostname\", \"os\": \"$os\", \"kernel\": \"$kernel\", \"uptime\": \"$uptime_info\"}" >> "$OUTPUT_JSON"

# Tutup JSON
echo "}" >> "$OUTPUT_JSON"

# Timer selesai
end_time=$(date +%s)
runtime=$((end_time - start_time))

# Summary akhir
echo
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════${RESET}"
echo -e "${BOLD}📊 Summary${RESET}"
echo -e "${CYAN}────────────────────────────────────────────────────────────${RESET}"
echo -e "Repos ditemukan : ${YELLOW}$repo_count${RESET}"
echo -e "Tools tercatat  : ${YELLOW}$tools_count${RESET}"
echo -e "Disk terpakai   : ${YELLOW}$percent ($used / $total)${RESET}"
echo -e "OS              : ${YELLOW}$os${RESET}"
echo -e "Kernel          : ${YELLOW}$kernel${RESET}"
echo -e "Runtime         : ${YELLOW}${runtime}s${RESET}"
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}✅ Data berhasil disimpan ke $OUTPUT_JSON${RESET}"
echo -e "${GREEN}${BOLD}📄 Log terminal tersimpan di $LOGFILE${RESET}"
echo -e "${CYAN}${BOLD}════════════════════════════════════════════════════════════${RESET}"


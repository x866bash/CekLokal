#!/bin/bash

# Warna & efek
GREEN="\e[32m"
RESET="\e[0m"
BLINK="\e[5m"

OUTPUT_JSON="repos_scan.json"
> "$OUTPUT_JSON"

# Animasi scanning (blok hijau berkedip)
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
            msg="${GREEN}HAMPIR SELESAI!!${RESET}"
        else
            msg=""
        fi

        echo -ne "\r📂 Scanning Project/Repo GitHub Lokal... [$bar] $progress% $msg"
        sleep 0.1
        ((progress+=2))
    done
    echo
    echo "---------------------------------------"
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

# Scan repo lokal dari root & home
repos=$(find /root /home -type d -name ".git" 2>/dev/null | sed 's|/.git||')

if [ -z "$repos" ]; then
    echo "❌ Tidak ada project GitHub ditemukan"
else
    echo "📂 Project/Repo GitHub Lokal Ditemukan:"
    echo "---------------------------------------"
    printf "%-20s %-50s %-20s %-15s\n" "Nama" "Path" "Waktu" "Bahasa"

    first=true
    for repo in $repos; do
        name=$(basename "$repo")
        path="$repo"
        waktu=$(stat -c %y "$repo" | cut -d'.' -f1)
        bahasa=$(detect_language "$repo")

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

# Daftar tools terinstall (dpkg)
echo
echo "📦 Daftar Tools Terinstall (dpkg):"
echo "---------------------------------------"
dpkg-query -W -f='${Package}\t${Version}\n' | head -n 20 | column -t

# Tambahkan ke JSON (20 paket teratas)
echo "  \"tools\": [" >> "$OUTPUT_JSON"
dpkg-query -W -f='${Package}\t${Version}\n' | head -n 20 | \
    awk -F"\t" '{printf "    {\"name\": \"%s\", \"version\": \"%s\"},\n", $1, $2}' >> "$OUTPUT_JSON"
sed -i '$ s/,$//' "$OUTPUT_JSON"
echo "  ]," >> "$OUTPUT_JSON"

# Informasi disk
echo
echo "💾 Informasi Disk:"
echo "---------------------------------------"
df_out=$(df -h / | awk 'NR==2 {print $2, $3, $4, $5}')
total=$(echo $df_out | awk '{print $1}')
used=$(echo $df_out | awk '{print $2}')
avail=$(echo $df_out | awk '{print $3}')
percent=$(echo $df_out | awk '{print $4}')

echo "Total   : $total"
echo "Terisi  : $used"
echo "Sisa    : $avail"
echo "Persen  : $percent"

# Tambahkan ke JSON
echo "  \"disk\": {\"total\": \"$total\", \"used\": \"$used\", \"avail\": \"$avail\", \"percent\": \"$percent\"}" >> "$OUTPUT_JSON"
echo "}" >> "$OUTPUT_JSON"

echo
echo "✅ Data berhasil disimpan ke $OUTPUT_JSON"


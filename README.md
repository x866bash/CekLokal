# 🚀 GitHub Local Repo Scanner + System Info Tool

Alat ini adalah **script Bash interaktif** untuk melakukan scanning terhadap project/repo GitHub lokal di sistem, sekaligus menampilkan informasi sistem secara profesional dengan tampilan yang rapi.  
Mendukung progress bar animasi, deteksi bahasa repo, serta export hasil dalam format **JSON log**.

---

## ✨ Fitur Utama

- 📂 **Scanning Project/Repo GitHub Lokal**
  - Menampilkan daftar repo dengan `nama`, `path`, `last modified`, dan `bahasa`.
  - Auto-detect bahasa berdasarkan file dominan (Python, NodeJS, PHP, Docker, Shell Script, Unknown).

- ⚡ **Progress Bar Animasi**
  - Animasi progress berjalan di terminal.
  - ✅ Tidak ada bug `ESAI!!` atau teks dobel (menggunakan `tput el` untuk hapus line).
  - Menampilkan status: *20%*, *40%*, *60%*, *80% HAMPIR SELESAI!!*, *100% SELESAI!!*.
  - Sebelumnya ada bug yang mengharuskan untuk mengganti semua tampilan dengan yang baru.

- 🖥️ **Info Sistem Lengkap**
  - User login, hostname, tanggal, direktori kerja.
  - Informasi disk usage (`df -h`).
  - Resource sistem (`uptime`, load average, memory usage).

- 📊 **Ringkasan Akhir**
  - Jumlah total repo.
  - Distribusi bahasa repo.

- 📁 **Logging**
  - Menyimpan hasil ke `scan_results.json` (struktur JSON).
  - Menyimpan output console ke `scan_results.log`.

---

## 📦 Instalasi

Clone project ini atau copy script:

```bash
git clone https://github.com/x866bash/CekLokal.git
cd CekLokal
chmod +x lihat.sh
```

Pastikan dependencies berikut tersedia:
  - `bash` (v5 atau lebih baru)
  - `tput` (biasanya sudah ada di paket ncurses)
  - `jq` (opsional, jika ingin parse JSON hasil log)

---

## ▶️  Cara Menjalankan

```bash
./lihat.sh
```

Hasil akan tampil langsung di terminal dengan progress bar animasi.
Log tersimpan otomatis ke file:
  - `scan_results.log` → output terminal
  - `scan_results.json` → data dalam format JSON

---

## 🖥️ Kompatibilitas Terminal

Script ini sudah diuji dan bekerja baik di terminal berikut:

| Terminal Emulator                | Display Progress    | Catatan                                   |
| -------------------------------- | ------------------- | ----------------------------------------- |
| **GNOME Terminal** (Wayland/X11) | ✅ Full support      | Animasi halus                             |
| **KDE Konsole**                  | ✅ Full support      | Stabil                                    |
| **Alacritty**                    | ✅ Full support      | Perlu font emoji agar icon 📂 ⚡ ✅ tampil  |
| **Tilix**                        | ✅ Full support      | Sama dengan GNOME Terminal                |
| **xterm**                        | ⚠️ Support terbatas | Emoji mungkin tidak tampil, gunakan ASCII |
| **TTY (Ctrl+Alt+F1..F6)**        | ⚠️ Support terbatas | Warna & emoji tidak tampil                |

👉 Jika TERM tidak terdeteksi dengan benar, pastikan environment variable sudah ada:
```bash
echo $TERM
```
Output seharusnya seperti: `xterm-256color`, `screen-256color`, atau `alacritty`.

---

```swift
════════════════════════════════════════════════════════════
     🚀 GitHub Local Repo Scanner + System Info Tool 🚀     
════════════════════════════════════════════════════════════

User      : root
Hostname  : hostname
Tanggal   : Sun Sep 14 04:49:29 WIB 2025
Direktori : /home/hostname/project/github/TOOLS/CekLokal

📂 Scanning Project/Repo GitHub Lokal... [█ █ █ █ █] 100% ✅ SELESAI!!

════════════════════════════════════════════════════════════
Nama                 Path                                 Bahasa
DVWA                 /home/hostname/project/DVWA              PHP
terabox-app          /home/hostname/project/github/terabox-app NodeJS
Checker-Scammer      /home/hostname/project/github/TOOLS/Checker-Scammer Python
...

```

---

## 🔄 Perubahan dari Script Awal

Script ini berevolusi dari versi sederhana menjadi versi lengkap & profesional. Berikut daftar perubahan utama:
1. Tampilan & Styling
  - Ditambahkan header dekoratif (`═════════` + emoji).
  - Warna output (ANSI escape sequences) agar lebih readable.
  - Ikon emoji 📂 ⚡ ✅ untuk menambah kesan modern.
2.  Progress Bar
  - Script awal: progress bar sederhana, menimbulkan bug "ESAI!!".
  - Versi final: progress bar dengan `tput el` → tidak ada teks dobel/bug.
  - Ditambahkan status animasi (HAMPIR SELESAI!!, SELESAI!!).
3. Fitur Scan Repo
  - Awal: hanya list direktori.
  - Final: deteksi bahasa otomatis berdasarkan file dominan.
4. System Info
  - Tambahan info: user, hostname, tanggal, direktori kerja.
  - Tambahan disk usage (`df -h`) & resource (uptime, `free -h`).
5. Output & Logging
  - Awal: hanya print ke console.
  - Final: auto-save ke `scan_results.log` (console) + `scan_results.json`.
6. Kompatibilitas Terminal
  - Awal: tidak stabil, animasi berantakan di Wayland.
  - Final: support *GNOME Terminal*, *KDE Konsole*, *Alacritty*, *Tilix*, dengan fallback untuk *TTY/xterm*.
7. Summary Akhir
  - Tambahan statistik jumlah repo & distribusi bahasa pemrograman.

---

## Pict
![Pict1](https://raw.githubusercontent.com/x866bash/CekLokal/refs/heads/main/Pict1.png)
---
![Pict2](https://raw.githubusercontent.com/x866bash/CekLokal/refs/heads/main/Pict2.png)
---
![Pict3](https://raw.githubusercontent.com/x866bash/CekLokal/refs/heads/main/Pict3.png)

---

## 📜 Lisensi
MIT [License](https://raw.githubusercontent.com/x866bash/CekLokal/refs/heads/main/LICENSE) – bebas digunakan, dimodifikasi, dan dikembangkan lebih lanjut.

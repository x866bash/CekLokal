# 🛠️ GitHub Local Repo & System Scanner

---

Tool ini digunakan untuk:
- 📂 Scanning repository GitHub lokal secara otomatis dari `/root` dan `/home`
- 🔍 Mendeteksi bahasa utama project (Python, NodeJS, PHP, dsb)
- 📦 Menampilkan daftar tools terinstall (`dpkg`)
- 💾 Menampilkan informasi disk
- 📑 Menyimpan hasil scanning ke file JSON (`repos_scan.json`)
- ✨ Menampilkan animasi progress bar blok hijau berkedip

---

## 🚀 Cara Menjalankan

```bash
chmod +x scanner.sh
./scanner.sh

---

📊 Contoh Output

Output JSON (`repos_scan.json`):
```json
{
  "repos": [
    {
      "name": "my-project",
      "path": "/home/user/my-project",
      "waktu": "2025-09-01 14:12:33",
      "bahasa": "Python"
    }
  ],
  "tools": [
    {"name": "bash", "version": "5.2.15"},
    {"name": "coreutils", "version": "9.1"}
  ],
  "disk": {
    "total": "200G",
    "used": "150G",
    "avail": "50G",
    "percent": "75%"
  }
}

```
---

📸 Contoh

![contoh](https://raw.githubusercontent.com/x866bash/CekLokal/main/assets/Pict.png)

📜 Lisensi

MIT [License](https://github.com/x866bash/CekLokal?tab=MIT-1-ov-file) © 2025

# X-KillChain

**X-KillChain** adalah kerangka kerja otomatisasi yang dirancang untuk mempermudah fase *Reconnaissance* dan *Vulnerability Scanning* dalam metodologi *Penetration Testing*. Alat ini mengintegrasikan berbagai *tool* keamanan untuk memetakan *attack surface* target secara efisien dan sistematis.



## ⚠️ Disclaimer
* **Educational Purposes Only**: Alat ini dibuat hanya untuk tujuan pendidikan, riset keamanan, dan pengujian otorisasi.
* **No Guarantee of Accuracy**: Pengguna bertanggung jawab penuh atas penggunaan *tool* ini. Penulis tidak bertanggung jawab atas segala bentuk penyalahgunaan atau kerusakan yang ditimbulkan.

---

## 🛠️ Komponen Utama
* **`core/main.sh`**: *Engine* utama yang menjalankan alur kerja *Recon*, *Probing*, hingga *Scanning*.
* **`payload/`**: Berisi skrip pendukung untuk validasi dan eksplorasi lebih lanjut (termasuk *webshell* dan *privilege escalation tools*).

---

## 🚀 Instalasi

### 1. Kali Linux
Pastikan sistem Anda sudah diperbarui dan memiliki koneksi internet.

```bash
# Update sistem
sudo apt update && sudo apt upgrade -y

# Instal dependencies yang diperlukan
sudo apt install subfinder assetfinder curl nuclei -y

# Clone repositori dan berikan izin eksekusi
git clone <URL_REPO_ANDA>
cd x-killchain
chmod +x core/main.sh
```


2. Windows (Via WSL2)
Sangat disarankan menggunakan WSL2 (Windows Subsystem for Linux) dengan distro Kali atau Ubuntu.

Buka PowerShell (Admin) dan jalankan: wsl --install.

Setelah instalasi distro selesai, jalankan perintah instalasi Kali Linux di atas di dalam terminal WSL.

Pastikan tools (nuclei, subfinder, dll) sudah terpasang di dalam lingkungan WSL tersebut.

📖 Cara Penggunaan
Alat ini bekerja dengan satu perintah utama. Masukkan domain target sebagai argumen.

```Bash
cd x-killchain/core
./main.sh <domain_target.com>
```
Alur Kerja (Pipeline):
Reconnaissance (Stage 1): Mengumpulkan subdomain menggunakan subfinder dan assetfinder.

Probing (Stage 2): Melakukan check konektivitas (HTTP/HTTPS) secara paralel menggunakan curl.

Vulnerability Mapping (Stage 3): Menjalankan nuclei untuk memindai celah keamanan pada target yang aktif.

Hasil akhir akan tersimpan di dalam folder /storage/<domain_target>/stage3_vulns/vulnerabilities.txt.

🔍 Pembahasan untuk Tim
Tool ini dirancang untuk membedah alur kill chain secara mendalam:

Analisis Data: Memahami cara mengelola daftar attack surface dari hasil recon.

Optimization: Mempelajari teknik multithreading (xargs -P) untuk mempercepat proses probing.

Validation: Menggunakan payload pendukung untuk memvalidasi temuan secara manual setelah scanner memberikan indikasi celah.

💡 Tips Penting
Jika nuclei tidak menampilkan hasil, pastikan Anda telah menjalankan nuclei -ut untuk memperbarui templates.

Selalu periksa file active_targets.txt untuk memastikan target yang terdeteksi valid sebelum menjalankan pemindaian mendalam.

Gunakan dengan bijak dan pastikan Anda memiliki izin resmi untuk melakukan pengujian pada target.

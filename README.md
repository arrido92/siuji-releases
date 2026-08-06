# Siuji — Rilis

Aplikasi Ujian Online (Siuji) — boleh digunakan untuk kepentingan pendidikan di Indonesia. Aplikasi ini sudah siap pakai bagi sekolah/madrasah atau lembaga lain yang ingin menggunakan aplikasi ujian online Siuji.
Isinya dipakai juga oleh fitur cek/auto-update di panel admin Siuji (`Pengaturan > Peralatan > Ujian Aman`),
lewat file `manifest.json` di root repo ini.

Hak cipta tetap milik Nifadigital.

## Fitur

**Inti (gratis, tanpa lisensi tambahan)**
- Ujian online (CBT) dengan 7 tipe soal: pilihan ganda, pilihan ganda kompleks (jawaban benar >1), benar/salah, isian singkat, esai, urutkan, dan menjodohkan — sebagian besar dinilai otomatis, esai dinilai manual oleh guru.
- Bank Soal per mata pelajaran — soal ujian tinggal "Ambil dari Bank Soal", atau duplikat dari ujian yang sudah ada.
- Manajemen data sekolah: siswa, staf/guru, kelas (rombel), tahun ajaran, kenaikan kelas, pindah kelas, data alumni, riwayat siswa.
- Penjadwalan ujian, pendaftaran peserta (enrollment), dan penjadwalan ujian ulang.
- Cek Kesiapan Ujian sebelum ujian dimulai (validasi jadwal, peserta, dan soal).
- Monitoring Ujian Live untuk guru/pengawas, plus layar Monitoring Publik tanpa login (cocok ditampilkan di smart board/proyektor sekolah).
- Deteksi pelanggaran otomatis selama ujian (pindah tab/aplikasi, keluar layar penuh), dengan penguncian akun otomatis kalau siswa meninggalkan halaman ujian terlalu lama.
- Laporan hasil ujian, cetak kartu peserta, jadwal, daftar hadir, dan berita acara.
- Backup data dan Log Keamanan (audit aktivitas admin/guru).
- Auto-update langsung dari panel admin (lihat [Update ke versi berikutnya](#update-ke-versi-berikutnya)).

**Premium (butuh file lisensi dari Nifadigital)**
- **Ujian Aman** — kunci pengerjaan ujian ke Safe Exam Browser atau aplikasi [Siuji Desktop](https://github.com/arrido92/siuji-desktop) resmi: wajib layar penuh, blokir copy-paste dan klik kanan, terkunci ke jendela ujian.
- **Pengawasan Webcam** — bagian dari paket Ujian Aman, snapshot wajah siswa berkala selama ujian ke penyimpanan S3/Cloudflare R2 milik sekolah sendiri (Siuji tidak pernah menyimpan filenya), untuk ditinjau guru/pengawas.
- **Soal Bantuan AI** — buat draf soal otomatis dari topik/materi, tinggal ditinjau dan disunting guru sebelum dipakai.
- **Penjadwalan Remedial Otomatis** — jadwalkan ujian ulang otomatis untuk siswa yang belum tuntas.
- **Bulk Import Siswa** — impor data siswa massal, tidak perlu input satu per satu.

**Aplikasi pendamping**
- Android untuk siswa — lihat [tautan Play Store](#aplikasi-siswa-android) di bawah.
- [Siuji Desktop](https://github.com/arrido92/siuji-desktop) untuk Windows — lihat [bagian instalasi](#aplikasi-siswa-desktop-windows--ujian-aman) di bawah.

## Aplikasi Siswa (Android)

[![Download di Google Play](https://play.google.com/intl/en_us/badges/static/images/badges/id_badge_web_generic.png)](https://play.google.com/store/apps/details?id=id.siuji.studentclient)

> **Segera hadir** — aplikasi masih dalam proses review Google Play. Tombol di atas akan otomatis aktif begitu publikasi disetujui.

## Aplikasi Siswa (Desktop Windows — Ujian Aman)

Aplikasi desktop khusus Windows untuk mengunci pengerjaan ujian ke jendela resmi Siuji (alternatif/pendamping Safe Exam Browser), dipakai kalau fitur premium **Ujian Aman** diaktifkan sekolah.

**[⬇️ Unduh `Siuji.Desktop.Installer.msi`](https://update-siuji.nifaniaga.com/Siuji.Desktop.Installer.msi)**

- Jalankan file `.msi` yang diunduh, ikuti wizard instalasi (Welcome → Lisensi → Selesai).
- Setelah terpasang, buka aplikasi dari Start Menu/Desktop shortcut — aplikasi akan minta **alamat server** (URL Siuji sekolah) saat pertama kali dijalankan.
- Konfigurasi tersimpan di `%APPDATA%\id.siuji.desktop` — tidak ikut terhapus saat update ke versi baru (cuma hilang kalau aplikasi benar-benar di-uninstall).
- File ini di-hosting terpisah (Cloudflare R2), bukan di repo ini — link selalu mengarah ke versi terbaru, tidak perlu diganti tiap rilis.

## Struktur folder

```
windows/      siuji.exe + .env.example              -> Windows (Server/Desktop)
linux/        siuji + .env.example                  -> Linux (Ubuntu/Debian, VPS polos, MAUPUN VPS yang dikelola aaPanel -- binary-nya sama, lihat catatan aaPanel di bawah)
docker/       install.sh + docker-compose.yml + .env.docker.example  -> Instalasi via Docker (image di GitHub Container Registry, bukan file di repo ini)
```

(Aplikasi Desktop Windows di-hosting terpisah di Cloudflare R2 — lihat tautan unduh di atas, bukan di folder repo ini.)

`linux/siuji` sudah ditandai executable di git (mode 755) — tapi **kalau
diunduh lewat `wget`/`curl`** (bukan `git clone`), tanda itu TIDAK ikut
terbawa (keterbatasan HTTP polos, bukan bug). Makanya langkah `chmod +x siuji`
di bawah tetap WAJIB dijalankan, jangan dilewati.

---

## Instalasi di Windows

**1. Install PostgreSQL** (kalau belum ada)
- Unduh installer resmi: https://www.enterprisedb.com/downloads/postgres-postgresql-downloads
- Saat instalasi, **catat password user `postgres`** yang Anda buat — dibutuhkan lagi di langkah wizard nanti.
- Biarkan port default `5432`.

**2. Unduh `siuji.exe`**
- Dari folder [`windows/`](windows/) di repo ini, unduh `siuji.exe`.
- Taruh di folder sendiri, mis. `C:\siuji\siuji.exe`.

**3. Jalankan**
- Double-click `siuji.exe`, ATAU buka Command Prompt di folder itu lalu ketik `siuji.exe`.
- **Biarkan jendela ini tetap terbuka** — server berjalan selama jendela ini hidup (menutup jendela = server berhenti). Untuk deployment sungguhan, pertimbangkan menjalankannya lewat Task Scheduler/NSSM supaya tetap hidup di background — belum otomatis dari installer ini.
- Karena belum ada konfigurasi sama sekali, akan muncul pesan di layar:
  ```
  === SIUJI SETUP WIZARD ===
  Belum ada file .env -- buka alamat berikut di browser untuk mulai konfigurasi:
    http://localhost:8080/
  ```
  (Kalau port 8080 kebetulan dipakai aplikasi lain, otomatis pindah ke port lain dan pesannya menyesuaikan.)

**4. Buka alamat itu di browser**, isi:
- Host/Port/User/Password/Nama Database PostgreSQL (sesuai yang di-set langkah 1 — nama database boleh apa saja, mis. `siuji_db`, akan dibuatkan otomatis skemanya).
- Email & password akun admin pertama.
- Klik simpan — server otomatis lanjut jalan normal di jendela yang sama, tidak perlu restart manual.

**5. Selesai** — buka `http://localhost:8080` (atau alamat IP komputer ini di jaringan sekolah) untuk masuk ke Siuji.

Untuk restart berikutnya, tinggal jalankan `siuji.exe` lagi — konfigurasi yang tersimpan (`.env`, dibuat otomatis di folder yang sama) langsung terbaca, wizard tidak muncul lagi.

---

## Instalasi di Linux/VPS (Ubuntu/Debian polos)

**1. Install PostgreSQL**
```bash
sudo apt update
sudo apt install -y postgresql
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'ganti-dengan-password-kuat';"
```

**2. Unduh binary**
```bash
sudo mkdir -p /opt/siuji
cd /opt/siuji
sudo wget https://raw.githubusercontent.com/arrido92/siuji-releases/main/linux/siuji
sudo chmod +x siuji
```

**3. Buka port di firewall** (kalau ada ufw/security group aktif)
```bash
sudo ufw allow 8080/tcp
```
(Sesuaikan nomor port kalau nanti ternyata port lain yang dipakai — lihat pesan wizard di langkah berikut.)

**4. Jalankan SEBAGAI ROOT untuk instalasi pertama**
```bash
sudo ./siuji
```
Root **wajib** untuk instalasi pertama kali — kalau berhasil, Siuji otomatis mendaftarkan dirinya sebagai **systemd service** (auto-restart kalau crash, dan jadi syarat fitur auto-update dari panel admin bisa dipakai). Kalau dijalankan bukan sebagai root, Siuji tetap jalan normal, cuma tanpa kapabilitas auto-update itu (harus update manual selamanya).

**5. Buka alamat yang tercetak di terminal** (`http://<ip-server>:8080/`) lewat browser, isi form wizard (kredensial PostgreSQL dari langkah 1 + akun admin pertama).

**6. Setelah wizard selesai**, kalau langkah 4 berhasil daftar systemd, Siuji sudah otomatis jalan di background sebagai service. Cek statusnya:
```bash
sudo systemctl status siuji
sudo journalctl -u siuji -f      # lihat log real-time
sudo systemctl restart siuji     # restart manual kalau perlu
```

---

## Instalasi di VPS dengan aaPanel

Sama persis seperti Linux polos di atas — **unduh binary dan `.env.example` dari folder [`linux/`](linux/) yang sama** (tidak ada paket terpisah untuk aaPanel, binary-nya identik), cuma:
- PostgreSQL boleh dipasang lewat App Store aaPanel (menu "PostgreSQL Manager") alih-alih `apt install` manual — user/password diatur dari situ.
- Buka port lewat menu **Security** aaPanel (bukan `ufw` manual), kalau firewall aaPanel aktif.
- Jalankan `sudo ./siuji` tetap lewat SSH terminal (fitur "Process Daemon"/"Supervisor Manager" bawaan aaPanel BOLEH dipakai sebagai alternatif kalau tidak mau andalkan pendaftaran systemd otomatis di atas — pilih salah satu, jangan dua-duanya sekaligus supaya tidak rebutan port).

---

## Instalasi via Docker

Tidak perlu install PostgreSQL sendiri — `docker compose` menyiapkan database + server Siuji sekaligus dalam 1 container masing-masing. Cocok untuk yang sudah familiar Docker atau ingin instalasi paling cepat.

**Cara tercepat (1 perintah)** — pasang Docker otomatis kalau belum ada, generate `.env` dengan secret & password admin **acak unik** per instalasi (bukan default yang sama di semua instalasi), lalu langsung jalan:

```bash
curl -fsSL https://raw.githubusercontent.com/arrido92/siuji-releases/main/docker/install.sh | sudo bash
```

Setelah selesai, kredensial admin awal (URL, email, password acak) ditampilkan di terminal dan disimpan di `/opt/siuji/kredensial-awal.txt` — segera login dan ganti lewat menu Profil.

**Cara manual** (kalau mau baca dulu isinya sebelum jalan, atau sudah punya folder instalasi sendiri):

```bash
mkdir -p /opt/siuji && cd /opt/siuji
curl -fsSL https://raw.githubusercontent.com/arrido92/siuji-releases/main/docker/docker-compose.yml -o docker-compose.yml
curl -fsSL https://raw.githubusercontent.com/arrido92/siuji-releases/main/docker/.env.docker.example -o .env
# edit .env: isi DB_PASSWORD, JWT_SECRET (openssl rand -hex 32), ADMIN_PASSWORD
docker compose up -d
```

Image resmi: `ghcr.io/arrido92/siuji` — tag `:latest` selalu ikut rilis terbaru, atau kunci ke versi tertentu (mis. `:1.3.0`) dengan mengganti tag di `docker-compose.yml` / lewat `SIUJI_VERSION=1.3.0` sebelum menjalankan `install.sh`.

Data (`uploads/`, `backups/`, database PostgreSQL) tersimpan di Docker volume terpisah dari container `app` — aman kalau image di-update (`docker compose pull && docker compose up -d`), tidak ikut hilang.

### Pakai Domain Sendiri (HTTPS Otomatis dengan Caddy)

Langkah di atas cuma bisa diakses lewat `http://<ip-server>:8080` — kalau Anda punya domain sendiri (mis. `siuji.sekolahanda.sch.id`) dan mau diakses lewat alamat itu **dengan HTTPS (gembok hijau) tanpa `:8080` di belakang**, perlu 1 program tambahan bernama **Caddy** yang dipasang langsung di VPS (di luar Docker) — tugasnya cuma "menerima" alamat domain dan meneruskannya ke Siuji yang sudah jalan di port 8080, sambil otomatis mengurus sertifikat HTTPS gratis dari Let's Encrypt (Anda tidak perlu beli/perpanjang sertifikat manual).

**1. Arahkan domain ke IP server (DNS)**

Buka dashboard tempat Anda beli domain (atau Cloudflare kalau domainnya sudah dipindah ke sana), buat 1 **A record** baru:

| Kolom | Isi |
|---|---|
| Type | `A` |
| Name/Host | subdomain pilihan Anda, mis. `siuji` (jadi `siuji.sekolahanda.sch.id`) |
| Value/Content | alamat IP VPS Anda, mis. `103.59.95.238` |
| Proxy status (khusus Cloudflare) | **Matikan (DNS only / awan abu-abu)** — kalau dinyalakan, Cloudflare ikut coba urus HTTPS juga dan malah bentrok dengan Caddy |

Tunggu beberapa menit sampai domain itu bisa di-*ping* dan menunjuk ke IP server (bisa dicek lewat `ping siuji.sekolahanda.sch.id` dari komputer Anda).

**2. Install Caddy di VPS** (lewat SSH, jalankan satu-satu)

```bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt install -y caddy
```

**3. Beri tahu Caddy domain mana yang harus diteruskan ke mana**

Buka file konfigurasinya (bikin baru kalau belum ada):
```bash
sudo nano /etc/caddy/Caddyfile
```
Hapus semua isinya (kalau ada), ganti dengan (sesuaikan domainnya):
```
siuji.sekolahanda.sch.id {
    reverse_proxy localhost:8080
}
```
Simpan (di `nano`: `Ctrl+O` lalu `Enter`, keluar dengan `Ctrl+X`).

**4. Jalankan ulang Caddy supaya konfigurasi baru terbaca**
```bash
sudo systemctl restart caddy
```
Caddy otomatis menghubungi Let's Encrypt untuk mengambil sertifikat HTTPS domain itu di sini — prosesnya beberapa detik saja, tidak perlu langkah tambahan apa pun.

**5. Buka akses firewall** untuk HTTPS (443) dan HTTP (80, dipakai Caddy untuk verifikasi sertifikat) — port 8080 tidak perlu dibuka ke publik lagi, cukup diakses Caddy dari `localhost`:
```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

**Selesai** — buka `https://siuji.sekolahanda.sch.id` di browser, harusnya langsung muncul Siuji dengan gembok HTTPS, tanpa perlu ketik `:8080` lagi.

### Satu VPS untuk Beberapa Sekolah Sekaligus

Kalau 1 VPS ini mau dipakai melayani **beberapa sekolah berbeda** (masing-masing data/database-nya terpisah total, tidak bercampur), pola di atas tinggal diulang dengan 1 penyesuaian: **folder instalasi beda** per sekolah — port host otomatis dipilihkan (`install.sh` sudah pintar mendeteksi port yang masih kosong sendiri, mulai dari 8080 lalu naik kalau sudah dipakai sekolah lain), dan Caddy yang tadi dipasang cukup 1 kali saja, dia yang nanti membagi-bagi domain ke Siuji sekolah yang benar.

**Contoh: 2 sekolah, "SD Melati" dan "SMP Mawar", 1 VPS yang sama.**

**1. Instalasi sekolah pertama** — cukup ganti nama foldernya, sisanya persis cara 1-perintah biasa:
```bash
SIUJI_INSTALL_DIR=/opt/siuji-sd-melati curl -fsSL https://raw.githubusercontent.com/arrido92/siuji-releases/main/docker/install.sh | sudo bash
```
Karena belum ada apa pun di VPS ini, port yang kepilih otomatis `8080` — bisa dilihat di ringkasan akhir instalasi (baris "URL").

**2. Instalasi sekolah kedua** — SAMA PERSIS, cuma ganti nama folder lagi:
```bash
SIUJI_INSTALL_DIR=/opt/siuji-smp-mawar curl -fsSL https://raw.githubusercontent.com/arrido92/siuji-releases/main/docker/install.sh | sudo bash
```
Kali ini `install.sh` otomatis mendeteksi `8080` sudah dipakai sekolah pertama, jadi otomatis memilih `8081` — **catat port yang muncul di ringkasan akhir** (baris "URL", mis. `http://103.59.95.238:8081`), dibutuhkan di langkah 4 nanti untuk Caddyfile.

Ulangi pola ini (folder baru saja, port menyesuaikan sendiri) untuk sekolah ketiga dan seterusnya. Karena tiap sekolah punya folder sendiri, Docker otomatis memisahkan total database dan berkasnya masing-masing — sekolah A tidak akan pernah bisa melihat data sekolah B.

> Kalau mau **mengunci port tertentu sendiri** (bukan otomatis), set `SIUJI_APP_PORT` sebelum menjalankan perintahnya, mis. `SIUJI_APP_PORT=8081 SIUJI_INSTALL_DIR=/opt/siuji-smp-mawar curl -fsSL ... | sudo bash`.

**3. Arahkan 2 domain** ke IP VPS yang sama (ulangi langkah "Arahkan domain ke IP server" di atas untuk masing-masing, mis. `sd-melati.sch.id` dan `smp-mawar.sch.id`).

**4. Satu Caddyfile untuk semua sekolah** — edit `/etc/caddy/Caddyfile` (Caddy yang sama, tidak perlu install ulang), tambahkan 1 blok per sekolah, port menyesuaikan yang tercatat di langkah 1–2:
```
sd-melati.sch.id {
    reverse_proxy localhost:8080
}

smp-mawar.sch.id {
    reverse_proxy localhost:8081
}
```
Lalu `sudo systemctl restart caddy` sekali lagi. Caddy otomatis mengurus sertifikat HTTPS terpisah untuk kedua domain itu.

Kalau nanti mau tambah sekolah lagi, tinggal ulangi langkah 1–2–3 (folder baru, domain baru, catat port yang kepilih) lalu tambahkan 1 blok baru lagi di Caddyfile yang sama.

---

## Update ke versi berikutnya

- **Windows / Linux tanpa systemd**: hentikan proses lama, timpa file binary dengan yang baru dari repo ini, jalankan lagi. Konfigurasi (`.env`) tidak perlu diganti/disentuh.
- **Linux yang sudah terdaftar systemd** (lihat langkah 4 di atas): bisa lewat tombol **"Update Sekarang"** di panel admin (`Pengaturan > Peralatan` setelah update tersedia) — otomatis unduh, ganti file, restart sendiri.
- **Docker**: `docker compose pull && docker compose up -d` di folder instalasi (`/opt/siuji` kalau pakai `install.sh`) — tombol "Update Sekarang" di panel admin akan menampilkan perintah ini juga, bukan mengunduh otomatis (beda dari Linux systemd di atas). Kalau 1 VPS melayani beberapa sekolah (lihat [Satu VPS untuk Beberapa Sekolah Sekaligus](#satu-vps-untuk-beberapa-sekolah-sekaligus)), ulangi perintah ini di FOLDER MASING-MASING sekolah satu per satu — meng-update 1 folder tidak ikut meng-update folder sekolah lain.

Untuk supaya panel admin bisa MENDETEKSI ada versi baru sama sekali, isi di `.env`:
```
UPDATE_MANIFEST_URL=https://raw.githubusercontent.com/arrido92/siuji-releases/main/manifest.json
```

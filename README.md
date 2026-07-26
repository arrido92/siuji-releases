# Siuji — Rilis

Aplikasi Ujian Online (Siuji) — boleh digunakan untuk kepentingan pendidikan di Indonesia. Aplikasi ini sudah siap pakai bagi sekolah/madrasah atau lembaga lain yang ingin menggunakan aplikasi ujian online Siuji.
Isinya dipakai juga oleh fitur cek/auto-update di panel admin Siuji (`Pengaturan > Peralatan > Ujian Aman`),
lewat file `manifest.json` di root repo ini.

Hak cipta tetap milik Nifadigital.

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
windows/      siuji.exe + .env.example   -> Windows (Server/Desktop)
linux/        siuji + .env.example       -> Linux umum (Ubuntu/Debian, VPS polos)
vps-aapanel/  siuji + .env.example       -> Linux yang dikelola lewat panel aaPanel
```

(Aplikasi Desktop Windows di-hosting terpisah di Cloudflare R2 — lihat tautan unduh di atas, bukan di folder repo ini.)

`linux/siuji` dan `vps-aapanel/siuji` sudah ditandai executable di git (mode
755) — tapi **kalau diunduh lewat `wget`/`curl`** (bukan `git clone`), tanda
itu TIDAK ikut terbawa (keterbatasan HTTP polos, bukan bug). Makanya langkah
`chmod +x siuji` di bawah tetap WAJIB dijalankan, jangan dilewati.

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

Sama persis seperti Linux polos di atas, cuma:
- Unduh binary dari folder [`vps-aapanel/`](vps-aapanel/) sebagai gantinya (`wget https://raw.githubusercontent.com/arrido92/siuji-releases/main/vps-aapanel/siuji`).
- PostgreSQL boleh dipasang lewat App Store aaPanel (menu "PostgreSQL Manager") alih-alih `apt install` manual — user/password diatur dari situ.
- Buka port lewat menu **Security** aaPanel (bukan `ufw` manual), kalau firewall aaPanel aktif.
- Jalankan `sudo ./siuji` tetap lewat SSH terminal (fitur "Process Daemon"/"Supervisor Manager" bawaan aaPanel BOLEH dipakai sebagai alternatif kalau tidak mau andalkan pendaftaran systemd otomatis di atas — pilih salah satu, jangan dua-duanya sekaligus supaya tidak rebutan port).

---

## Update ke versi berikutnya

- **Windows / Linux tanpa systemd**: hentikan proses lama, timpa file binary dengan yang baru dari repo ini, jalankan lagi. Konfigurasi (`.env`) tidak perlu diganti/disentuh.
- **Linux yang sudah terdaftar systemd** (lihat langkah 4 di atas): bisa lewat tombol **"Update Sekarang"** di panel admin (`Pengaturan > Peralatan` setelah update tersedia) — otomatis unduh, ganti file, restart sendiri.

Untuk supaya panel admin bisa MENDETEKSI ada versi baru sama sekali, isi di `.env`:
```
UPDATE_MANIFEST_URL=https://raw.githubusercontent.com/arrido92/siuji-releases/main/manifest.json
```

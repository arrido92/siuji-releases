# Kebijakan Privasi — Siuji

*Terakhir diperbarui: 2 Agustus 2026*

Kebijakan Privasi ini menjelaskan bagaimana data diproses saat Anda menggunakan aplikasi Siuji ("Aplikasi"), baik lewat aplikasi Android maupun versi web, yang dikembangkan oleh Nifadigital ("kami", "Pengembang").

## 1. Poin Penting: Siapa Pengendali Data (Data Controller) Anda

Siuji **bukan layanan terpusat** — setiap sekolah/madrasah/lembaga ("Penyelenggara") menjalankan server Siuji miliknya **sendiri**. Aplikasi Android/web Siuji yang Anda pakai terhubung langsung ke server milik Penyelenggara tempat Anda terdaftar (dipilih lewat menu "Ganti Alamat Server"), **bukan ke server milik Nifadigital**.

Konsekuensinya:

- **Data Anda** (nama, NISN, jawaban ujian, dan sebagainya) **tersimpan di server yang dikelola Penyelenggara** (sekolah Anda), bukan di server Nifadigital.
- **Penyelenggara (sekolah/madrasah Anda) adalah pengendali data (data controller)** yang bertanggung jawab atas data tersebut, sesuai kebijakan internal mereka masing-masing.
- Nifadigital, sebagai pengembang perangkat lunak, **tidak memiliki akses rutin** ke data siswa/pengguna yang tersimpan di server masing-masing Penyelenggara.
- Untuk pertanyaan spesifik soal data Anda (misalnya permintaan hapus data atau koreksi data), hubungi **Penyelenggara/sekolah Anda langsung**, karena merekalah yang menyimpan dan mengendalikan data tersebut.

## 2. Data yang Dikumpulkan Aplikasi

Sesuai peran Anda (siswa, guru, pengawas, atau admin), Aplikasi mengumpulkan:

**Data identitas & akun**
- Nama lengkap, NISN (untuk siswa), email (opsional), jenis kelamin, kelas/rombel, foto profil (kalau diunggah oleh admin sekolah).
- Kata sandi — disimpan dalam bentuk terenkripsi (hash bcrypt); untuk siswa, tersedia juga salinan yang bisa dipulihkan admin sekolah khusus untuk keperluan cetak Kartu Ujian (misalnya saat siswa lupa password), disimpan dengan enkripsi AES-256.

**Data pengerjaan ujian**
- Jawaban yang diketik/dipilih selama ujian, waktu mulai/selesai, nilai/skor hasil ujian.
- Catatan pelanggaran teknis (misalnya keluar dari mode aman/kiosk, berpindah aplikasi) — dipakai semata untuk keperluan integritas ujian (mencegah kecurangan), bukan untuk pemantauan di luar konteks ujian.

**Data perangkat & teknis**
- ID perangkat (dibuat otomatis oleh Aplikasi, bukan nomor IMEI/identitas fisik perangkat), alamat IP, versi aplikasi, jenis klien (Android/Browser).
- Untuk pengawas ujian (guru): kode verifikasi TOTP (dua-faktor) dipakai membuka kembali sesi ujian yang terkunci karena pelanggaran — disimpan terenkripsi.

**Data kamera (Pengawasan Webcam) — HANYA kalau fitur ini diaktifkan Penyelenggara**
- Kalau sekolah/madrasah Anda mengaktifkan fitur premium **Pengawasan Webcam** (bagian dari Ujian Aman), Aplikasi mengambil foto singkat dari kamera depan secara berkala SELAMA Anda mengerjakan ujian, untuk ditinjau guru/pengawas sebagai bukti tambahan integritas ujian.
- Foto **TIDAK PERNAH melewati atau disimpan di server Nifadigital** — diunggah **langsung** dari perangkat Anda ke penyimpanan awan (S3/Cloudflare R2) milik **Penyelenggara sendiri**, sama seperti prinsip di Bagian 1: sekolah Anda tetap pengendali data untuk foto ini.
- Di aplikasi Android, kamera **wajib** diizinkan untuk bisa memulai ujian kalau fitur ini aktif (beda dari versi web/Safe Exam Browser/Siuji Desktop yang dikonfigurasi otomatis lewat aplikasi resmi sekolah, tanpa dialog izin terpisah) — Anda akan diminta izin akses kamera oleh sistem Android, bukan oleh Nifadigital.
- Foto HANYA bisa dilihat oleh guru/pengawas yang berwenang atas ujian tersebut (lewat tautan sementara yang kedaluwarsa dalam hitungan menit), dan setiap kali foto dibuka, tercatat siapa & kapan membukanya.

## 3. Bagaimana Data Digunakan

Data di atas dipakai **semata-mata** untuk menjalankan fungsi inti Aplikasi:

- Autentikasi login.
- Menyajikan soal ujian sesuai jadwal & aturan yang diatur guru/admin.
- Menyimpan & menilai jawaban ujian.
- Mencetak kartu ujian dan mengelola akses siswa oleh admin sekolah.
- Menjaga integritas pelaksanaan ujian (mode aman/kiosk, deteksi pelanggaran, dan foto Pengawasan Webcam kalau diaktifkan Penyelenggara) — foto webcam TIDAK dipakai untuk tujuan lain di luar peninjauan integritas ujian oleh guru/pengawas.

Kami (Nifadigital) **tidak menggunakan data ini untuk iklan, tidak menjualnya ke pihak ketiga, dan tidak membagikannya ke pihak luar** di luar server milik Penyelenggara tempat data itu tersimpan.

## 4. Penyimpanan & Keamanan Data

- Data tersimpan di server milik Penyelenggara (bisa berupa server sekolah sendiri, VPS, atau layanan hosting yang dipilih Penyelenggara). Khusus foto Pengawasan Webcam, tersimpan terpisah di penyimpanan awan (S3/Cloudflare R2) milik Penyelenggara sendiri, bukan di server aplikasi Siuji itu sendiri.
- Komunikasi antara Aplikasi dan server dilindungi enkripsi (HTTPS wajib untuk server publik).
- Sesi login perangkat mobile diikat ke perangkat tertentu (device binding) dengan tanda tangan kriptografis per-permintaan, untuk mencegah penyalahgunaan sesi oleh perangkat lain.
- Kata sandi tidak pernah disimpan dalam bentuk teks biasa untuk keperluan autentikasi (memakai hash satu-arah).

## 5. Anak di Bawah Umur

Siuji dipakai di lingkungan sekolah/madrasah, sehingga sebagian pengguna (siswa) mungkin berusia di bawah 13 tahun. Pendaftaran akun siswa **dilakukan oleh sekolah/madrasah (Penyelenggara)**, bukan oleh siswa/orang tua secara mandiri langsung ke Nifadigital — persetujuan penggunaan data siswa merupakan tanggung jawab hubungan sekolah dengan siswa/orang tua/wali, sesuai kebijakan masing-masing Penyelenggara.

## 6. Hak Anda

Untuk permintaan terkait data pribadi Anda (akses, koreksi, atau penghapusan), silakan hubungi **admin/operator sekolah tempat Anda terdaftar**, karena merekalah pengendali data yang menyimpan data tersebut secara langsung.

## 7. Perubahan Kebijakan

Kami dapat memperbarui Kebijakan Privasi ini dari waktu ke waktu. Perubahan akan tercermin pada tanggal "Terakhir diperbarui" di atas.

## 8. Kontak

Pertanyaan umum seputar aplikasi Siuji (bukan permintaan data pribadi spesifik, yang harus lewat sekolah Anda) dapat disampaikan ke:

**Nifadigital**
Email: support@nifadigital.web.id
Website: https://nifadigital.web.id

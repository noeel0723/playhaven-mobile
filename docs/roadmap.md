# Roadmap Android

## 1. Fondasi

Struktur fitur, tema sementara, navigasi tab, katalog fiktif, detail, koleksi sesi, API transport, konfigurasi publik, host Android, dan test awal. Jalankan `flutter doctor -v` untuk melengkapi tooling mesin sebelum menjalankan emulator atau build APK.

## 2. Akun dan kontrak API

Audit backend, tentukan kontrak JSON/auth, implementasikan login/register sesuai fitur backend, secure storage, session state, logout, dan profil pengguna. Hasil: akun yang sama dapat dipakai di mobile dan web.

## 3. Katalog dan koleksi nyata

Hubungkan katalog, gambar, pencarian, filter, pagination, detail, dan koleksi akun. Tentukan status bermain yang sama dengan backend. Hasil: perubahan koleksi sinkron antara mobile dan web, dengan error state yang dapat dipulihkan.

## 4. Komunitas

Profil pemain, follow/unfollow, followers/following, ulasan, dan aktivitas sesuai kemampuan API. Tambahkan reporting/moderasi jika sudah masuk ruang lingkup produk.

## 5. Rilis

Selaraskan desain dengan referensi web, finalisasi application ID dan ikon, uji aksesibilitas dan perangkat Android fisik, tetapkan kebijakan cache/offline, signing release, dan internal testing. Push notification, deep links publik, dan offline penuh dikerjakan ketika kebutuhan produk telah ditetapkan.

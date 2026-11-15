# Persiapan integrasi backend PlayHaven

Backend web belum tersedia di workspace ini dan kontrak API belum diverifikasi. Daftar berikut adalah pekerjaan integrasi yang diusulkan, bukan klaim endpoint sudah tersedia. Persiapan mobile tidak memerlukan perubahan database atau provider katalog.

## Kontrak yang perlu disepakati

| Kemampuan | Yang harus diverifikasi |
| --- | --- |
| Autentikasi | Login/register, mekanisme token untuk mobile, kedaluwarsa/revokasi, logout, verifikasi email, reset password |
| Profil | Identitas akun, avatar, bio, username, pengaturan privasi |
| Katalog | Daftar game, pencarian, pagination, detail, genre/platform, URL gambar |
| Koleksi | Daftar milik akun, tambah/hapus game, status bermain, progress, aturan konflik |
| Komunitas | Pemain, follow/unfollow, followers/following, ulasan, aktivitas dan pagination |
| Error | JSON validation, 401/403/404/422/429/5xx, retry dan rate limit |

Jika backend menggunakan Laravel + Inertia, halaman HTML/Inertia bukan otomatis REST API untuk Flutter. Periksa route API dan mekanisme autentikasi yang benar-benar tersedia dahulu. Tentukan apakah token berbasis Sanctum atau mekanisme lain memang sesuai implementasi backend; jangan mengasumsikan sesi cookie browser dapat langsung dipakai aplikasi native.

## Urutan implementasi

1. Audit backend secara read-only: routes, controller/resource JSON, middleware auth, rate limit, dan bentuk pagination.
2. Sepakati contoh respons sukses/error, ID game yang stabil, filter, serta permission untuk data privat.
3. Implementasikan auth repository dan session controller. Simpan token menggunakan secure storage, hapus pada logout, dan atur penanganan sesi yang tidak valid.
4. Tambahkan remote catalog repository beserta test parsing berdasarkan fixture API yang telah disepakati. Ubah binding `catalogRepositoryProvider` dari demo ke remote secara eksplisit.
5. Tambahkan repository koleksi dan operasi tulis yang memerlukan autentikasi; tangani kegagalan dan rollback UI bila memakai optimistic update.
6. Integrasikan komunitas dan profil setelah permission serta pagination jelas.

Contoh config berisi URL saja. Kunci RAWG/provider lain tetap di server PlayHaven agar kuota dan kebijakan akses dikendalikan backend. Flutter mengonsumsi katalog melalui backend, bukan database atau API provider secara langsung.

## Jaringan pengembangan Android

- Android Emulator: host komputer dapat diakses melalui `10.0.2.2`; `localhost` menunjuk emulator itu sendiri.
- Ponsel fisik: gunakan IP LAN host dan jaringan yang sama, atau `adb reverse` bila sesuai setup.
- Host Android debug mengizinkan HTTP untuk development. Release tidak menambahkan pengecualian cleartext; gunakan HTTPS dengan sertifikat valid.
- `API_BASE_URL` contoh memiliki prefix `/api/v1`, namun prefix final harus mengikuti backend. Transport menjaga prefix ketika menambahkan path endpoint.

## Kriteria integrasi selesai

- Login/logout/sesi tidak valid teruji tanpa token di log atau Git.
- Katalog memuat data nyata dengan loading, empty, error, pagination, dan coba lagi.
- Koleksi di perangkat sesuai akun setelah aplikasi dibuka ulang.
- Backend menerapkan otorisasi pada setiap operasi privat.
- Gangguan jaringan dan rate limit tidak menghapus data lokal tanpa konfirmasi hasil server.

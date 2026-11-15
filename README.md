# PlayHaven Mobile

Fondasi aplikasi Flutter untuk **Android dahulu**, dengan kode Dart yang dapat diperluas ke iOS nanti. Versi awal menggunakan data game fiktif dan tidak terhubung ke akun atau backend produksi.

## Yang sudah tersedia

- Tema gelap Material 3 dan navigasi Beranda, Koleksi, Komunitas, Profil.
- Katalog demo, pencarian judul/genre, detail game, tambah/hapus koleksi selama sesi aplikasi.
- Keadaan loading, error dengan coba lagi, hasil kosong, dan game tidak ditemukan.
- Riverpod untuk dependency injection dan state, go_router untuk navigasi, HTTP client dengan timeout dan pemetaan error.
- Pemisahan UI, model, dan repository; titik integrasi backend tanpa mengasumsikan endpoint yang sudah tersedia.
- Pengujian konfigurasi, transport JSON, pencarian, navigasi, dan koleksi.

Komunitas dan Profil masih berupa layar awal. Login, data live, sinkronisasi, penyimpanan koleksi setelah aplikasi ditutup, push notification, serta rilis Play Store belum diimplementasikan.

## Tooling

Gunakan **Flutter 3.50.0 stable / Dart 3.14.0**. Sumber SDK: [Flutter resmi](https://docs.flutter.dev/install). SDK lokal untuk persiapan berada di `.tools/flutter` dan diabaikan Git; proyek tidak mengubah PATH global.

1. Instal Android Studio, lalu melalui SDK Manager instal Android SDK Platform, Build-Tools, Command-line Tools, Platform-Tools, dan Android Emulator. Ikuti [panduan Android Flutter](https://docs.flutter.dev/platform-integration/android/setup) untuk versi yang sesuai.
2. Selesaikan lisensi dan periksa perangkat:

   ```powershell
   .\scripts\flutter.ps1 doctor -v
   .\scripts\flutter.ps1 doctor --android-licenses
   .\scripts\flutter.ps1 devices
   ```

3. Jalankan emulator dari Android Studio Device Manager, atau sambungkan ponsel Android dengan USB debugging aktif dan izinkan komputer pada ponsel.
4. Dari root proyek:

   ```powershell
   .\scripts\flutter.ps1 pub get
   .\scripts\flutter.ps1 run
   ```

Wrapper memilih SDK lokal jika tersedia, atau `flutter` di PATH. Cache paket dan temporary tooling lokal disimpan di `.tools`. Jika memakai SDK sendiri, perintah `flutter` biasa juga dapat digunakan. Di VS Code, pilih SDK melalui **Flutter: Change SDK** bila SDK lokal belum dikenali, lalu pilih konfigurasi **PlayHaven · Demo**.

## Struktur

```text
lib/
  main.dart
  app/
    config/           # Nilai publik dari --dart-define
    router/           # Rute dan shell navigasi
    shell/            # Navigasi bawah
    theme/            # Warna dan tema bersama
    playhaven_app.dart
  core/
    network/          # HTTP JSON, error, lifecycle client
    widgets/          # Widget bersama seperti empty state
  features/
    catalog/
      data/           # Repository demo; adapter API ditambahkan nanti
      domain/         # Model Game dan kontrak CatalogRepository
      presentation/   # Provider, halaman, widget katalog
    library/
      presentation/   # State koleksi sesi dan halaman
    community/
      presentation/
    profile/
      presentation/
config/               # Contoh konfigurasi publik
docs/                 # Arsitektur, kontrak backend, roadmap
scripts/              # Wrapper tooling Windows
test/                 # Unit dan widget tests
android/              # Proyek host Android
```

## Konfigurasi backend

Contoh `config/development.example.json` sengaja memakai alamat emulator Android `10.0.2.2` untuk host komputer. Path `/api/v1` hanyalah usulan; sesuaikan dengan kontrak backend sesungguhnya. Pada ponsel fisik, gunakan IP LAN komputer dan pastikan server dapat diakses dari jaringan lokal.

```powershell
Copy-Item config/development.example.json config/development.json
.\scripts\flutter.ps1 run --dart-define-from-file=config/development.json
```

**Mengatur URL belum mengaktifkan data live.** `catalogRepositoryProvider` tetap menggunakan `DemoCatalogRepository`. Setelah kontrak JSON disepakati, buat adapter remote dan ganti provider tersebut. `apiClientProvider` membaca `API_BASE_URL` ketika transport pertama kali digunakan. HTTP lokal hanya diizinkan pada build debug; gunakan HTTPS untuk produksi.

`--dart-define` tersimpan dalam aplikasi hasil build. Jangan memasukkan RAWG key, password database, private key, atau access token ke file ini. Kredensial provider katalog tetap di backend; token login nantinya disimpan melalui secure storage perangkat.

## Pemeriksaan

```powershell
.\scripts\flutter.ps1 analyze
.\scripts\flutter.ps1 test --concurrency=1
.\scripts\flutter.ps1 build apk --debug
```

Build APK memerlukan Android SDK dan lisensi yang sudah lengkap. Commit `pubspec.lock` untuk aplikasi ini agar dependency konsisten. Application ID awal `com.playhaven.playhaven_mobile` adalah placeholder; tetapkan ID milik organisasi sebelum distribusi. Konfigurasi signing release belum disiapkan untuk distribusi.

## Urutan pengembangan

1. **Fondasi:** struktur Flutter, host Android, navigasi, mode demo, konfigurasi, dan pengujian.
2. **Kontrak backend + akun:** audit API PlayHaven, autentikasi token, secure storage, sesi, logout, dan profil.
3. **Katalog live + koleksi:** pagination, pencarian API, detail game, status bermain, sinkronisasi akun.
4. **Komunitas:** pemain, follow/following, ulasan, aktivitas, dan penanganan izin.
5. **Persiapan rilis:** identitas visual final, ikon, aksesibilitas, perangkat nyata, signing, dan internal testing Play Store.

Rincian: [arsitektur](docs/architecture.md), [integrasi backend](docs/backend-integration.md), [roadmap](docs/roadmap.md).

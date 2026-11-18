# PlayHaven Mobile

Fondasi aplikasi Flutter untuk **Android dahulu**, dengan kode Dart yang dapat diperluas ke iOS nanti. Versi awal menggunakan pratinjau katalog web dan tidak terhubung ke akun atau backend produksi.

## Yang sudah tersedia

- Tema hitam/krem mengikuti web, banner dengan crop portrait, poster **Popular games this week**, dan enam kartu **A life in games. A place to keep it.**
- Navigasi Beranda, Koleksi, Komunitas, Profil; pencarian tersedia melalui ikon pencarian, Explore games, dan View all.
- Katalog demo, pencarian judul/genre, detail game, tambah/hapus koleksi selama sesi aplikasi.
- Keadaan loading, error dengan coba lagi, hasil kosong, dan game tidak ditemukan.
- Riverpod untuk dependency injection dan state, go_router untuk navigasi, HTTP client dengan timeout dan pemetaan error.
- Pemisahan UI, model, dan repository; titik integrasi backend tanpa mengasumsikan endpoint yang sudah tersedia.
- Pengujian konfigurasi, transport JSON, pencarian, navigasi, dan koleksi.

Komunitas dan Profil masih berupa layar awal. Login, data live, sinkronisasi, penyimpanan koleksi setelah aplikasi ditutup, push notification, serta rilis Play Store belum diimplementasikan.

Artwork dan urutan enam game merupakan snapshot beranda web pada 2026-11-18; urutan popularitas belum dihitung live di mobile. Diary, game lists, dan statistik menampilkan keterangan **Soon** saat dibuka. Rujukan gambar tercatat di [assets/README.md](assets/README.md).

## Tooling

Gunakan **Flutter 3.50.0 stable / Dart 3.14.0**. Sumber SDK: [Flutter resmi](https://docs.flutter.dev/install). SDK lokal untuk persiapan berada di `.tools/flutter` dan diabaikan Git; proyek tidak mengubah PATH global.

Setup yang disarankan: **VS Code + ekstensi Flutter/Dart + ponsel Android fisik**. Android Studio dan emulator tidak diperlukan. Ekstensi membantu edit/debug; build Android tetap memerlukan JDK dan Android SDK command-line.

1. Instal ekstensi **Flutter** (`Dart-Code.flutter`) di VS Code; ekstensi Dart ikut dipasang. Tooling portabel dapat disiapkan dari root proyek:

   ```powershell
   .\scripts\setup-android.ps1
   ```

   Script mengunduh Temurin JDK 21 dan Android Command-Line Tools dari sumber resmi, memeriksa SHA-256, lalu menyimpannya di `.tools`. Script tidak mengubah PATH global atau instalasi SDK lain.
2. Baca dan setujui lisensi SDK yang diperlukan secara interaktif, lalu instal paket Android minimum:

   ```powershell
   .\scripts\setup-android.ps1 -ReviewLicenses -InstallPackages
   ```

   Paket awal: Platform-Tools (`adb`), Android API 36, dan Build-Tools 36.0.0. Build pertama juga dapat mengunduh Gradle, dependency Android, dan NDK yang diminta Flutter; ukurannya lebih besar daripada ekstensi editor.
3. Buka workspace lokal yang dibuat script dan periksa tooling:

   ```powershell
   code .vscode/playhaven.local.code-workspace
   .\scripts\flutter.ps1 doctor -v
   .\scripts\flutter.ps1 devices
   ```

   Workspace lokal mengatur Java/Android SDK untuk ekstensi, debugger, dan terminal VS Code. File ini diabaikan Git karena mengandung path komputer. Buka terminal baru setelah workspace dimuat. `flutter doctor` bisa memberi peringatan Android Studio tidak terpasang; yang diperlukan adalah Android toolchain yang berhasil, bukan IDE tersebut.
4. Aktifkan **Developer options > USB debugging** di ponsel, sambungkan dengan kabel USB data, buka kunci layar, dan setujui **Allow USB debugging** pada ponsel. Jika Windows belum mengenali perangkat, periksa mode USB/kabel dan driver OEM.
5. Pilih ponsel dari status bar VS Code lalu tekan **F5** dengan konfigurasi **PlayHaven · Demo**. Alternatif terminal:

   ```powershell
   .\scripts\flutter.ps1 pub get
   .\scripts\flutter.ps1 devices
   .\scripts\flutter.ps1 run -d ID_PERANGKAT
   ```

Wrapper memilih SDK lokal jika tersedia, atau `flutter` di PATH, serta menggunakan JDK/SDK portabel bila sudah disiapkan. Cache paket, Gradle, dan temporary tooling lokal disimpan di `.tools`; environment proses dipulihkan setelah perintah selesai. Jika memakai SDK sendiri, perintah `flutter` biasa juga dapat digunakan. Di VS Code tersedia task pemeriksaan tooling, pencarian perangkat, dan build APK melalui **Terminal > Run Task**.

Panduan lebih lengkap: [VS Code dan ponsel Android](docs/vscode-android.md). Referensi resmi: [Flutter di VS Code](https://docs.flutter.dev/tools/vs-code), [Android command-line tools](https://developer.android.com/tools).

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

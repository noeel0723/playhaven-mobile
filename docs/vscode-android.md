# Mengembangkan PlayHaven tanpa Android Studio

Gunakan VS Code sebagai editor/debugger dan ponsel Android fisik sebagai perangkat uji. Ekstensi Flutter memasang dukungan Dart, tetapi tidak menggantikan JDK, Android SDK, atau perangkat Android. Emulator tetap opsional dan tidak dipasang oleh script proyek.

## Lokasi tooling

| Isi | Lokasi lokal |
| --- | --- |
| Flutter SDK | `.tools/flutter` |
| Temurin JDK 21 | `.tools/jdk` |
| Android SDK | `.tools/android-sdk` |
| SDK Manager | `.tools/android-sdk/cmdline-tools/latest/bin/sdkmanager.bat` |
| ADB setelah paket SDK dipasang | `.tools/android-sdk/platform-tools/adb.exe` |
| Cache Gradle | `.tools/gradle` |
| Konfigurasi Flutter khusus proyek | `.tools/flutter-config` |
| Unduhan bootstrap | `.tools/downloads` |
| Workspace VS Code khusus mesin | `.vscode/playhaven.local.code-workspace` |

Folder `.tools` dan workspace lokal diabaikan Git. Java sistem yang lama serta SDK lain dibiarkan tetap ada. Menjalankan `scripts/flutter.ps1` hanya mengubah environment proses selama perintah berjalan. Workspace lokal diperlukan agar Flutter daemon di ekstensi VS Code juga mendapat environment yang sama; terminal baru memakai environment workspace.

Flutter dapat memprioritaskan Java bawaan instalasi Android Studio di atas `JAVA_HOME`. Karena itu script membuat konfigurasi Flutter lokal yang menunjuk JDK portabel. Pada Windows, `APPDATA` dialihkan hanya untuk proses Flutter/wrapper dan proses Dart Code ke `.tools/flutter-config`; environment ini dipulihkan setelah wrapper selesai. Terminal tetap menggunakan `APPDATA` normal agar aplikasi lain tidak ikut berubah. Gunakan wrapper proyek untuk perintah Flutter di terminal.

Workspace menonaktifkan impor/build otomatis dari ekstensi Java dan Gradle. Pengembangan Flutter cukup menggunakan ekstensi Flutter/Dart, sedangkan build Android dijalankan oleh Flutter saat diminta. Pengaturan ini hanya berlaku untuk proyek ini. Jika ekstensi Java/Gradle sebelumnya sudah aktif, gunakan **Developer: Reload Window** sekali agar konfigurasi baru diterapkan.

## Persiapan satu kali

```powershell
.\scripts\setup-android.ps1
.\scripts\setup-android.ps1 -ReviewLicenses -InstallPackages
code .vscode/playhaven.local.code-workspace
```

Langkah review lisensi bersifat interaktif. Baca teks yang ditampilkan dan tentukan persetujuan untuk setiap lisensi yang diperlukan. Script tidak mengirim jawaban `yes` otomatis.

JDK dipatok ke Temurin 21.0.13+9 dan command-line tools ke build 15859902. Keduanya diperiksa menggunakan SHA-256 dari sumber unduhan resmi. Paket platform/build-tools disesuaikan dengan proyek Flutter saat ini (API 36 / Build-Tools 36.0.0). `sdkmanager` tetap tersedia pada paket ini, meskipun dokumentasi Google terbaru mulai mengarahkan pengelolaan SDK ke Android CLI.

Jika folder proyek dipindah, jalankan ulang `setup-android.ps1` untuk memperbarui path workspace lokal. Script melewati JDK dan command-line tools yang sudah tersedia. Unduhan pertama memerlukan jaringan dan ruang disk; Gradle, Maven dependency, dan NDK dapat diunduh lagi pada build pertama. Setup tanpa IDE lebih ringan saat digunakan, tetapi toolchain build tetap membutuhkan ruang disk.

## Menyambungkan ponsel

1. Di pengaturan ponsel, buka About phone lalu aktifkan Developer options (biasanya dengan mengetuk Build number tujuh kali; lokasi dapat berbeda per merek).
2. Aktifkan USB debugging di Developer options.
3. Sambungkan kabel USB yang mendukung data. Buka kunci ponsel dan izinkan USB debugging untuk komputer ini.
4. Periksa:

   ```powershell
   .\.tools\android-sdk\platform-tools\adb.exe devices -l
   .\scripts\flutter.ps1 devices
   ```

5. Pilih ID ponsel, lalu jalankan:

   ```powershell
   .\scripts\flutter.ps1 run -d ID_PERANGKAT
   ```

   Atau pilih ponsel dari status bar VS Code lalu tekan F5. Hot reload tersedia dari toolbar debugger; dalam `flutter run`, tekan `r` untuk hot reload dan `q` untuk berhenti.

## Pemecahan masalah

| Gejala | Tindakan |
| --- | --- |
| `unauthorized` | Buka kunci ponsel dan setujui prompt USB debugging. Jika perlu cabut/pasang kabel. |
| `INSTALL_FAILED_USER_RESTRICTED` | Pemasangan dibatalkan atau dibatasi ponsel. Buka kunci layar dan setujui dialog pemasangan. Pada Xiaomi/MIUI, periksa **Setelan tambahan > Opsi pengembang > Instal melalui USB**. |
| Ponsel tidak muncul | Coba kabel data/port lain, periksa mode USB, dan instal driver resmi OEM jika Windows membutuhkannya. |
| Java 8 dipakai saat build | Gunakan wrapper proyek atau workspace lokal; periksa `JAVA_HOME` di terminal baru. |
| Android command-line tools tidak ditemukan | Jalankan `setup-android.ps1` dan periksa struktur `cmdline-tools/latest/bin`. |
| Lisensi belum diterima | Jalankan `setup-android.ps1 -ReviewLicenses`, lalu ulangi instalasi paket. |
| `No Devices` di VS Code | Buka workspace lokal, hubungkan ponsel, pilih perangkat; reload window bila daemon belum membaca environment baru. |
| Android Studio ditandai belum terpasang | IDE tersebut tidak diperlukan untuk alur ini; periksa bagian Android toolchain pada `flutter doctor -v`. |
| Unduhan Gradle/NDK lama | Tunggu unduhan build pertama, periksa jaringan dan ruang disk; tidak perlu memasang emulator. |

Untuk mengakses backend dari ponsel fisik, gunakan IP LAN komputer atau `adb reverse` sesuai setup. `10.0.2.2` hanya untuk Android Emulator dan bukan alamat host komputer pada ponsel fisik.

Referensi: [Flutter VS Code](https://docs.flutter.dev/tools/vs-code), [Android tools](https://developer.android.com/tools), [SDK Manager](https://developer.android.com/tools/sdkmanager), [Temurin archive installation](https://adoptium.net/installation/archives/).

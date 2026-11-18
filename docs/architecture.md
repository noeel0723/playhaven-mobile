# Arsitektur awal

Proyek menggunakan struktur per fitur. Setiap fitur hanya memiliki lapisan yang sudah dibutuhkan; tambahkan lapisan data/domain ketika fitur tersebut mulai menggunakan API atau aturan bisnis. Hindari menambahkan service atau use case kosong.

## Aliran data

```text
Halaman/widget
    -> Riverpod provider atau controller
        -> kontrak repository
            -> repository demo / adapter API mendatang
                -> ApiClient -> backend PlayHaven
```

`CatalogRepository` mengembalikan model `Game`. UI tidak memahami struktur JSON backend. Adapter remote nantinya bertanggung jawab memetakan respons backend menjadi model domain, termasuk pagination dan validasi data. Pisahkan DTO jika bentuk JSON berbeda dengan kebutuhan UI.

`gamesProvider` mengelola loading/data/error. `LibraryController` menyimpan ID game dalam memori; statusnya hilang ketika proses aplikasi ditutup. State ini adalah simulasi interaksi, bukan pengganti koleksi milik akun.

## Navigasi

`StatefulShellRoute.indexedStack` mempertahankan cabang tab sehingga pencarian dan posisi scroll tidak langsung hilang saat berpindah tab. Rute awal:

| Rute | Tujuan |
| --- | --- |
| `/` | Beranda: banner, poster populer, dan kartu fitur |
| `/discover` | Pencarian judul/genre dan daftar katalog |
| `/library` | Koleksi demo |
| `/community` | Layar awal komunitas |
| `/profile` | Layar awal profil |
| `/games/:id` | Detail game di atas shell |

Rute detail dan URL tidak dikenal mempunyai empty/error state. Konfigurasi Android App Links publik belum dibuat. Setelah autentikasi tersedia, tambahkan redirect terpusat untuk rute privat dan pertahankan tujuan awal setelah login.

## Dependensi dan lifecycle

- Riverpod tanpa code generation: provider dapat di-override dalam test.
- go_router: navigasi deklaratif, shell tab, dan perluasan auth redirect.
- `http`: transport kecil untuk request JSON; client ditutup melalui `ref.onDispose`.
- `material_ui`: komponen Material untuk Flutter 3.50; tema berada dalam satu file.
- `flutter_svg`: logo vektor yang digunakan bersama referensi web.
- Tidak ada penyimpanan token, analytics, SDK RAWG, atau koneksi langsung database pada fondasi ini.

## Konvensi

- Berkas `snake_case.dart`, class `UpperCamelCase`, provider `lowerCamelCaseProvider`.
- Widget menggunakan model domain, bukan map JSON mentah.
- Hindari menampilkan body error backend karena dapat berisi detail internal.
- Jangan mencatat Authorization header atau token.
- String UI saat ini bahasa Indonesia. Tambahkan ARB dan `flutter_localizations` saat kebutuhan bahasa disepakati.
- Beranda memakai hitam/krem dari web, logo SVG, serta artwork lokal dengan crop portrait. Roboto dipakai sebagai font native Android; urutan game masih merupakan snapshot pratinjau.
- Tambahkan dependency hanya saat fiturnya diimplementasikan. Secure storage dan persistence belum diperlukan untuk demo.

Pemisahan UI/data mengikuti [rekomendasi arsitektur Flutter](https://docs.flutter.dev/app-architecture/recommendations), dengan lapisan tambahan sesuai kebutuhan aplikasi.

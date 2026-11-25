# OrbitNews (`orbit_app`)

Aplikasi mobile Flutter untuk pengelolaan dan penyajian berita berbasis **Firebase** (Firebase Authentication dan Cloud Firestore).

## Fitur Utama

- **Autentikasi Pengguna**: Login menggunakan email dan password melalui Firebase Authentication, dilengkapi pengecekan status sesi login secara otomatis dan opsi *Remember Me* (`SharedPreferences`).
- **Navigasi Utama**: *Bottom navigation bar* dengan menu **Beranda**, **Tambah Berita**, dan **Logout** (beserta dialog konfirmasi).
- **Daftar Berita Real-time**: Menampilkan berita terbaru dari Cloud Firestore (diurutkan berdasarkan `timestamp` terbaru), lengkap dengan thumbnail gambar dari URL, judul, dan ringkasan isi.
- **Kelola Berita (CRUD)**: Menambah berita baru, memperbarui berita yang sudah ada (`judul`, `isi`, `gambarUrl`), serta menghapus berita dengan dialog konfirmasi.
- **Manajemen Biodata**: Menyediakan model dan form untuk menambah serta mengubah data biodata (`name`, `age`, `address`) pada koleksi `biodata` di Cloud Firestore.
- **Halaman Detail Berita**: Tampilan contoh halaman detail berita (`NewsDetailPage`).

## Tech Stack

- **Framework**: Flutter (Dart SDK `^3.8.1`)
- **UI**: Material Design (Tema gelap / Dark Mode), `cupertino_icons`
- **Backend & Layanan**:
  - `firebase_core` (`^3.2.0`)
  - `firebase_auth` (`^5.5.4`)
  - `cloud_firestore` (`^5.1.0`)
- **Penyimpanan Lokal & Utilitas**:
  - `shared_preferences` (`^2.2.2`)
  - `image_picker` (`^1.0.0`)
- **Linter**: `flutter_lints` (`^5.0.0`)

## Struktur Proyek

```text
orbit_app/
├── assets/
│   └── image/                  # Aset gambar lokal
├── lib/
│   ├── main.dart               # Entry point, inisialisasi Firebase, dan routing sesi login
│   ├── login_screen.dart       # Halaman login & Remember Me
│   ├── main_page.dart          # Navigasi utama (BottomNavigationBar)
│   ├── biodata_list_screen.dart# Halaman beranda daftar berita real-time & aksi edit/hapus
│   ├── tambah_berita_screen.dart # Form tambah dan edit berita
│   ├── add_edit_biodata_screen.dart # Form tambah dan edit biodata
│   ├── berita_model.dart       # Model data Berita
│   ├── biodata_model.dart      # Model data Biodata
│   ├── deskripsi_screen.dart   # Halaman tampilan detail berita
│   └── firebase_options.dart   # Konfigurasi Firebase multi-platform
├── firebase.json               # Konfigurasi proyek FlutterFire
└── pubspec.yaml                # Daftar dependensi dan konfigurasi Flutter
```

## Instalasi dan Cara Menjalankan

1. **Prasyarat**
   - Pastikan [Flutter SDK](https://docs.flutter.dev/get-started/install) (dengan Dart SDK `^3.8.1`) dan perangkat/emulator telah terpasang.

2. **Clone Repositori**
   ```bash
   git clone https://github.com/BevandJanuartama/orbit.git
   cd orbit
   ```

3. **Install Dependensi**
   ```bash
   flutter pub get
   ```

4. **Jalankan Aplikasi**
   ```bash
   flutter run
   ```

## Konfigurasi Environment & Firebase

Proyek ini tidak menggunakan file `.env` maupun `.env.example`. Konfigurasi proyek terhubung ke Firebase melalui `firebase.json`, `lib/firebase_options.dart`, dan file konfigurasi platform (seperti `android/app/google-services.json`).

Jika ingin menghubungkan ke proyek Firebase Anda sendiri:
1. Pasang dan masuk ke Firebase CLI serta FlutterFire CLI.
2. Jalankan perintah berikut untuk membuat ulang konfigurasi platform:
   ```bash
   flutterfire configure
   ```
3. Pastikan **Firebase Authentication** (metode *Email/Password*) dan **Cloud Firestore** (koleksi `berita` dan `biodata`) telah diaktifkan di Firebase Console.

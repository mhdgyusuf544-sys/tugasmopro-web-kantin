# Kantin Bu Sari

Aplikasi Flutter untuk melihat menu kantin, mencari dan memfilter makanan, mengelola keranjang, serta mengirim detail pesanan untuk konfirmasi di kantin.

## Menjalankan aplikasi

Pastikan Flutter SDK tersedia, lalu jalankan:

```sh
flutter pub get
flutter run
```

## Fitur

- 12 menu makanan dan minuman dengan foto JPEG lokal di `assets/images/`.
- Pencarian, filter kategori, detail menu, dan rating.
- Favorit dengan halaman khusus.
- Keranjang dengan perubahan kuantitas dan ringkasan total.
- Checkout dengan nama, makan di tempat atau bungkus, nomor meja, catatan, serta pilihan pembayaran simulasi.
- Bukti pesanan dan riwayat pesanan.
- Profil kantin.

Menu, favorit, keranjang, dan riwayat saat ini disimpan di memori selama aplikasi berjalan. Pesanan belum terhubung ke sistem kantin dan pilihan QRIS tidak memproses pembayaran. Sumber foto dan lisensinya dicatat di `assets/images/README.txt`.

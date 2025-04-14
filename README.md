# Finance Application using local database (Hive) for Assignment 2 Mobile Programming

| Name                   | NRP        | Class |
|------------------------|------------|-------|
| Arya Gading Prinandika | 5025221280 | C     |

## Step-by-step Instructions to use local database

Karena pada GitHub milik [Hive Isar](https://github.com/isar/hive) commit terakhir pada tahun 2023,
maka
setelah saya baca terdapat Hive yang di-maintain dengan baik hingga saat ini
yaitu [Hive Community Edition](https://pub.dev/packages/hive_ce). Selain itu versi ini memiliki
hasil benchmark lebih baik ketimbang hive milik isar.

1. Menambahkan dependencies pada file `pubspec.yaml`:
   ```yaml
   dependencies:
     hive_ce: ^2.10.1
   ```
   Lalu jalankan perintah berikut pada terminal:
   ```bash  
   flutter pub get
   ```

2. Melakukan proses CRUD
   Karena kode ini merupakan lanjutan dari tugas sebelumnya yang menggunakan list maka hal pertama
   yang dilakukan adalah dengan menambahkan inisialisasi untuk database Hive

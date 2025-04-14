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
   yang dilakukan adalah dengan menambahkan inisialisasi untuk database Hive. Hal ini dilakukan
   dengan menambahkan type data untuk Hive agar sesuai dan database dapat digunakan untuk melakukan
   proses CRUD. Untuk menambahkan type data pada Hive, kita perlu membuat file baru di dalam folder
   Hive dangan nama 'hive_adapters.dart' dan masukkan kode berikut:
   ```dart
   import 'package:hive_ce/hive.dart';

   import 'package:local_db/finance.dart';
   import 'package:local_db/type_enum.dart';
   
   part 'hive_adapters.g.dart';
   
   @GenerateAdapters([AdapterSpec<Finance>(), AdapterSpec<FinanceType>()])
   // Annotations must be on some element
   // ignore: unused_element
   void _() {}
   ```
   Pada kode diatas karena saya mempunyai dua type data yaitu Finance dan FinanceType (enum) maka
   pada `@GenerateAdapters` saya menambahkan dua parameter yaitu `AdapterSpec<Finance>()` dan
   `AdapterSpec<FinanceType>()`. Pasti ketika terjadi error saat memulis file ini dimana pada
   bagian `part 'hive_adapters.g.dart';` terdapat error yang menyatakan bahwa file tersebut tidak
   ada. Hal ini karena file yang auto-generate belum dibuat untuk itu hal pertama yang harus
   dilakukan adalah dengan menambahkan package yang merupakan dependency untuk generate type yaitu
   `build_runner` dan `hive_ce_generator` cara mudah untuk menambahkan dependency ini adalah dengan
   menjalanka perintah

    ```bash
   flutter pub add dev:hive_ce_generator dev:build_runner
    ```

   Setelah itu kita perlu menjalankan perintah berikut untuk melakukan generate file

    ```bash
   dart pub run build_runner build --delete-conflicting-outputs
    ```

   Sekarang dapat terlihat bahwa terdapat file baru yang bernama `hive_adapters.g.dart` pada folder
   hive.

   Selanjutnya untuk menginisialisasi hive maka pada fungsi main yang ada di file main.dart perlu
   kita rubah fungsi tersebut untuk menjadi asynchronous


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

2. Melakukan definisi tipe data
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
   kita rubah fungsi tersebut untuk menjadi asynchronous. Lalu di dalam fungsi tersebut tuliskan
   kode berikut ini

   ```dart
    void main() async {
     WidgetsFlutterBinding.ensureInitialized();
   
     final appDocument = await getApplicationDocumentsDirectory();
     await Hive.initFlutter(appDocument.path);
   
     Hive.registerAdapters();
     await Hive.openBox<Finance>('myBox');
   
     final box = Hive.box<Finance>('myBox');
   
     if (box.isEmpty) {
       box.addAll([
         Finance(
           id: 1,
           name: 'Beli makan',
           amount: 15000.00,
           type: FinanceType.food,
         ),
         Finance(
           id: 2,
           name: 'Beli minum',
           amount: 5000.00,
           type: FinanceType.food,
         ),
         Finance(
           id: 3,
           name: 'Bayar UKT',
           amount: 3000000.00,
           type: FinanceType.education,
         ),
         Finance(
           id: 4,
           name: 'Beli buku',
           amount: 150000.00,
           type: FinanceType.entertainment,
         ),
       ]);
     }
   
     runApp(
       MaterialApp(
         home: MyApp(),
         theme: _buildTheme(Brightness.light),
       ),
     );
   }
    ```

   Pada kode diatas Hive di inisialisasi dengan `await Hive.initFlutter(appDocument.path);` dimana
   appDocument merupakan current path dari aplikasi kita. Selanjutnya perlu untuk menjalankan kode
   ini

   ```dart
    Hive.registerAdapters();
    await Hive.openBox<Finance>('myBox');
   ```

   Dua baris kode tersebut digunakan untuk mendaftarkan type adapter yang telah kita buat serta
   untuk membuat sebuah box yang akan kita gunakan sebagai tempat untuk menyimpan data. Untuk line
   of code selanjutnya berisi tentang migrasi data awal untuk melakukan cek di aplikasi.

3. Melakukan proses CRUD
   Karena pada finance_list terdapat beberapa widget seperti jumlah pengeluaran statistik
   pengeluaran dan list pengeluaran maka kita perlu untuk merubah penggunaan list menjadi
   pemanggilan ke local db kita. Contohnya untuk mengambil seluruh data maka digunakan kode berikut
   ini

   ```dart

    final financeData = Hive.box<Finance>('myBox').values;
   
   ```

   Kode diatas akan memanggil seluruh data yang disimpan pada local database kita. Untuk merubah
   menjadi list maka hanya perlu menambahkan menjadi

   ```dart
   
    final financeData = Hive.box<Finance>('myBox').values.toList();
     
   ```

   Selanjutnya untuk menjalankan proses create maka dari kode yang sebelumnya memasukkan ke dalam
   list menjadi kode berikut ini

   ```dart
   
   if (_nameController.text.isNotEmpty && amount != null) {
    setState(() {
      Hive.box<Finance>('myBox').add(
        Finance(
          id: Hive.box<Finance>('myBox').length + 1,
          name: _nameController.text,
          amount: amount,
          type: _selectedType,
        ),
      );
    });

    ```

    Selanjutnya untuk proses read maka sama dengan cara untuk mengambil seluruh data bedanya dengan menggunakan forloop yang diakses pada fungsi dibawah juga terdapat bagaimana untuk melakukan delete terhadap data
    
    ```dart
      ListView.builder(
        itemCount: financeData.length,
        itemBuilder: (context, index) {
          final finance = financeData.toList()[index];
          return FinanceCard(
            finance: finance,
            delete: () {
              setState(() {
                // finances.removeAt(index);
                Hive.box<Finance>('myBox').delete(finance.key);
              });
            },
            edit: () {
              openEditDialog(index);
            },
          );
        },
      ),
    ``` 

    Dapat terlihat bahwasanya untuk mengakses value dari hive tinggal menggunakan `financeData.toList()[index]` lalu untuk melakukan penghapusan data tinggal menggunakan kode `.delete(finance.key)`
    
    Untuk melakukan proses edit maka hal yang perlu dilakukan adalah dengan mengambil data dengan id yang diberikan melalui parameter

    ```dart

    final finance = Hive.box<Finance>('myBox').getAt(index);

    ```

    kode diatas berfungsi untuk mengambil data pada index yang telah ditentukan, kemudian untuk melakukan pergantian data cara yang dilakukan adalah berikut

    ```dart

    onPressed: () {
      double? amount = double.tryParse(_amountController.text);
      if (_nameController.text.isNotEmpty && amount != null) {
        setState(() {
          Hive.box<Finance>('myBox').put(
            finance.key,
            Finance(
              id: finance.id,
              name: _nameController.text,
              amount: amount,
              type: _selectedType,
            ),
          );
        });

        _nameController.clear();
        _amountController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Berhasil menambahkan data"),
            backgroundColor: Colors.green.shade300,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Mohon isi nama dan jumlah dengan benar",
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    },

    ``` 

    Hive telah menyediakan `.put` sebagai cara untuk kita dapat merubah value di dalam local database dimana menggunakan index sebagai cara untuk mencari data.


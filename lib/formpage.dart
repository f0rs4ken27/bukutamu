import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'lastpage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BukuTamuFormPage(),
    );
  }
}

class BukuTamuFormPage extends StatefulWidget {
  const BukuTamuFormPage({Key? key});

  @override
  _BukuTamuFormPageState createState() => _BukuTamuFormPageState();
}

class _BukuTamuFormPageState extends State<BukuTamuFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController notelpController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController lamakunjunganController = TextEditingController();

  Future<void> saveDataToBackend() async {
    final url = Uri.parse("http://localhost/flutterapi/bukutamu/create.php");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'nama': namaController.text,
          'notelp': notelpController.text,
          'alamat': alamatController.text,
          'tanggal': tanggalController.text,
          'lamakunjungan': lamakunjunganController.text,
        }),
      );

      if (response.statusCode == 200) {
        print('Data berhasil disimpan');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BukuTamuLastPage()),
        );
      } else {
        print('Gagal menyimpan data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buku',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Tamu',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(width: 8),
            Icon(
              Icons.menu_book_sharp,
              color: Colors.black,
              size: 50,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Divider(
            color: Colors.black,
            thickness: 1.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Isi Data Bawah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              buildTextFormField(
                controller: namaController,
                hintText: 'Masukkan Nama',
                labelText: 'Nama',
              ),
              SizedBox(height: 10),
              buildTextFormField(
                controller: notelpController,
                hintText: 'Masukkan No. Telp',
                labelText: 'No. Telp',
              ),
              SizedBox(height: 10),
              buildTextFormField(
                controller: alamatController,
                hintText: 'Masukkan Alamat',
                labelText: 'Alamat',
              ),
              SizedBox(height: 10),
              buildTextFormField(
                controller: tanggalController,
                hintText: 'Pilih Tanggal',
                labelText: 'Tanggal',
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 10),
              buildTextFormField(
                controller: lamakunjunganController,
                hintText: 'Masukkan Lama Kunjungan',
                labelText: 'Lama Kunjungan',
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Only proceed if the form is valid
                      saveDataToBackend();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    padding:
                    EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                  ),
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    bool enabled = true,
    GestureTapCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: controller,
          enabled: enabled,
          onTap: onTap,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Masukkan $labelText';
            }
            return null;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hintText,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != tanggalController.text) {
      setState(() {
        tanggalController.text = picked.toString().split(' ')[0];
      });
    }
  }
}

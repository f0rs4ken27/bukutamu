import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditGuestPage extends StatefulWidget {
  final dynamic data;

  const EditGuestPage({Key? key, required this.data}) : super(key: key);

  @override
  _EditGuestPageState createState() => _EditGuestPageState();
}

class _EditGuestPageState extends State<EditGuestPage> {
  late TextEditingController _namaController;
  late TextEditingController _notelpController;
  late TextEditingController _alamatController;
  late TextEditingController _tanggalController;
  late TextEditingController _lamaKunjunganController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.data['nama']);
    _notelpController = TextEditingController(text: widget.data['notelp']);
    _alamatController = TextEditingController(text: widget.data['alamat']);
    _tanggalController = TextEditingController(text: widget.data['tanggal']);
    _lamaKunjunganController =
        TextEditingController(text: widget.data['lamakunjungan']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Nama', _namaController),
            _buildTextField('No. Telp', _notelpController),
            _buildTextField('Alamat', _alamatController),
            _buildTextField('Tanggal Kunjungan', _tanggalController),
            _buildTextField('Lama Kunjungan', _lamaKunjunganController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveChanges();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black, // Ubah warna tombol disini
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              ),
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(controller.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.parse(controller.text)) {
      setState(() {
        controller.text = picked.toString().split(' ')[0];
      });
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: controller,
            onTap: () {
              _selectDate(context, controller);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Masukkan $label';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: label,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    final url = Uri.parse("http://localhost/flutterapi/bukutamu/edit.php");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(<String, dynamic>{
          'id': widget.data['id'],
          'nama': _namaController.text,
          'notelp': _notelpController.text,
          'alamat': _alamatController.text,
          'tanggal': _tanggalController.text,
          'lamakunjungan': _lamaKunjunganController.text,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Perubahan berhasil disimpan.'),
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan perubahan.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan perubahan. Silakan coba lagi nanti.'),
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan perubahan. Silakan coba lagi nanti.'),
        ),
      );
    }

  }
}
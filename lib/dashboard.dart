import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bukutamu/edit.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic>? tamu;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    var url = Uri.parse("http://localhost/flutterapi/bukutamu/dashboard.php");
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          tamu = data;
        });
      } else {
        print("Failed to load data: ${response.statusCode}");
      }
    } catch (error) {
      print("Error loading data: $error");
    }
  }

  void _deleteGuest(int index) async {
    try {
      var url = Uri.parse("http://localhost/flutterapi/bukutamu/hapus.php");
      var response = await http.post(url, body: {'id': tamu![index]['id']});

      if (response.statusCode == 200) {
        setState(() {
          tamu!.removeAt(index);
          var filteredTamu = tamu;
        });
        print("Guest deleted successfully");
      } else {
        throw Exception('Failed to delete guest');
      }
    } catch (e) {
      print('Error deleting guest: $e');
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
      body: tamu != null
          ? ListView.builder(
              itemCount: tamu!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(tamu![index]['nama']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditGuestPage(data: tamu![index]),
                              ),
                            ).then((_) {
                              // Panggil _fetchData() kembali setelah kembali dari laman edit
                              _fetchData();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.info),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GuestDetailsPage(data: tamu![index]),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Konfirmasi"),
                                  content: Text(
                                      "Apakah Anda yakin ingin menghapus tamu ini?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Tutup dialog
                                      },
                                      child: Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Tutup dialog
                                        _deleteGuest(index); // Hapus tamu
                                      },
                                      child: Text("Hapus"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class GuestDetailsPage extends StatelessWidget {
  final dynamic data;

  const GuestDetailsPage({Key? key, required this.data}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Nama', data['nama']),
            _buildDetailItem('No. Telp', data['notelp']),
            _buildDetailItem('Alamat', data['alamat']),
            _buildDetailItem('Tanggal Kunjungan', data['tanggal']),
            _buildDetailItem('Lama Kunjungan', data['lamakunjungan']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
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
          Text(value),
        ],
      ),
    );
  }
}

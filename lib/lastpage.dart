import 'package:flutter/material.dart';
import 'main.dart';


class BukuTamuLastPage extends StatelessWidget{
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
  SizedBox(width:8),
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
  
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Terima Kasih sudah mengisi data',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BukuTamuHomePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.black,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25,)
            ),
            child: Text('kembali'),
          ),
        ],
      ),
     ),
    );
  }
}
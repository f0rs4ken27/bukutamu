import 'package:bukutamu/dashboard.dart';
import 'package:bukutamu/formpage.dart';
import 'package:bukutamu/login.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BukuTamuHomePage(),
    );
  }
}

class BukuTamuHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 200), 
              child: Icon(
                Icons.menu_book_sharp,
                size: 100,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Container(
              margin: EdgeInsets.only(bottom: 300), 
              child: Text(
                'Buku Tamu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BukuTamuFormPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25,)
              ),
              child: Text('Masuk'),
            ),
            // Jarak antara tombol dan elemen berikutnya
          ],
        ),
      ),
    );
  }
}





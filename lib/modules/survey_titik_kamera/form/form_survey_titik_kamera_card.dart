import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormTitik extends StatelessWidget {
  const FormTitik({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey[900],
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.amber,
            )),
        title: Text(
          "Tambah Titik",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Judul Titik'),
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blueGrey[800],
                ),
                padding: EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.photo,
                        color: Colors.white,
                        size: MediaQuery.of(context).size.width * 0.2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Pilih foto',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(onPressed: () {}, child: Text('Kirim Data'))
          ],
        ),
      ),
    );
  }
}

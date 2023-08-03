import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormSurvey extends StatelessWidget {
  const FormSurvey({super.key});

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
          "Tambah Survey",
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
                  hintText: 'Nama projek'),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Alamat'),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white), hintText: 'Email'),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Nomor telpon'),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Status'),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () {}, child: Text('Kirim Data'))
          ],
        ),
      ),
    );
  }
}

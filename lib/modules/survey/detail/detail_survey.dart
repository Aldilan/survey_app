import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_app/modules/survey/widgets/survey_titik_kamera_card.dart';

class DetailSurvey extends StatelessWidget {
  const DetailSurvey({super.key});

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
          "Edit Survey",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
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
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Email'),
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
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () {}, child: Text('Kirim Data'))),
              ],
            ),
          ),
          Divider(),
          Container(
            height: kToolbarHeight,
            color: Colors.blueGrey[900],
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 48),
                Text(
                  "List Titik",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
                IconButton(
                  onPressed: () {
                    Get.toNamed('/form_titik');
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return TitikCard();
                }),
          )
        ],
      ),
    );
  }
}

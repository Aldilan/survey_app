import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_app/modules/survey/detail/controllers/detail_survey_controller.dart';
import 'package:survey_app/modules/survey/widgets/survey_titik_kamera_card.dart';
import 'package:survey_app/modules/survey_titik_kamera/form/form_survey_titik_kamera_card.dart';

class DetailSurvey extends StatelessWidget {
  final dynamic surveyData;
  DetailSurvey({super.key, required this.surveyData});

  @override
  Widget build(BuildContext context) {
    DetailSurveyController c =
        Get.put(DetailSurveyController(surveyData: surveyData));
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey[900],
        actions: [
          IconButton(
              onPressed: () {
                c.deleteSurvey(surveyData['Id_Survey']);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ))
        ],
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
                  controller: c.nama_projek_input,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Nama projek'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: c.alamat_input,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Alamat'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: c.email_input,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Email'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: c.no_telpon_input,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Nomor telpon'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: c.status_input,
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
                        onPressed: () {
                          c.updateSurvey(surveyData['Id_Survey']);
                        },
                        child: Text('Kirim Data'))),
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
                    Get.to(FormTitik(
                      idSurvey: surveyData['Id_Survey'],
                    ));
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
            child: Obx(
              () => ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: c.titikData.length,
                  itemBuilder: (context, index) {
                    return TitikCard(
                      titikData: c.titikData[index],
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}

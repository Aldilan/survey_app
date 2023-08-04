import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_app/modules/home/home_page.dart';
import 'package:survey_app/modules/survey/detail/detail_survey.dart';
import 'package:survey_app/modules/survey/form/form_survey.dart';
import 'package:survey_app/modules/survey_titik_kamera/detail/detail_survey_titik_kamera.dart';
import 'package:survey_app/modules/survey_titik_kamera/form/form_survey_titik_kamera_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      theme: ThemeData(primarySwatch: Colors.amber),
      getPages: [
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/form_survey', page: () => FormSurvey()),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:survey_app/modules/home/home_page.dart';
import 'package:survey_app/modules/survey/form/form_survey.dart';

void main() async {
  await GetStorage.init();
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

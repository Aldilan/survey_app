import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormTitikController extends GetxController {
  final int idSurvey;
  FormTitikController({required this.idSurvey});

  TextEditingController judul_input = TextEditingController();

  Future<void> addTitik() async {
    print(idSurvey);
  }
}

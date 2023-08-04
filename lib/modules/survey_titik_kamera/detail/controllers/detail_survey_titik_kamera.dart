import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_app/modules/globals/api_url.dart';
import 'package:dio/dio.dart' as dio;

class DetailTitikController extends GetxController {
  final dynamic titikData;
  DetailTitikController({required this.titikData});

  final dio.Dio _dio = dio.Dio();

  TextEditingController judul_titik_input = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    judul_titik_input.text = titikData['Judul_Titik'];
    super.onInit();
  }

  Future<void> deleteTitik(id_survey_titik_kamera) async {
    try {
      final response = await _dio.delete(
        ApiURL.currentApiURL + 'surveys_titik_kamera',
        data: {"survey_titik_kamera_id": id_survey_titik_kamera},
      );
      if (response.statusCode == 204) {
        Get.offAllNamed('/');
      }
    } catch (e) {
      print('object');
    }
  }
}

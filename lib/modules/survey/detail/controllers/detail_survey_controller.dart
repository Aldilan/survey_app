import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:survey_app/modules/globals/api_url.dart';

class DetailSurveyController extends GetxController {
  final dynamic surveyData;
  DetailSurveyController({required this.surveyData});

  final dio.Dio _dio = dio.Dio();

  RxList<dynamic> titikData = RxList<dynamic>();
  TextEditingController nama_projek_input = TextEditingController();
  TextEditingController alamat_input = TextEditingController();
  TextEditingController email_input = TextEditingController();
  TextEditingController no_telpon_input = TextEditingController();
  TextEditingController status_input = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    updateTextField();
    getTitik();
    super.onInit();
  }

  void updateTextField() {
    nama_projek_input.text = surveyData['Nama_Projek'];
    alamat_input.text = surveyData['Alamat'];
    email_input.text = surveyData['Email'];
    no_telpon_input.text = surveyData['Nomor_Telpon'];
    status_input.text = surveyData['Status_Survey'];
  }

  Future<void> updateSurvey(id_survey) async {
    try {
      final response = await _dio.put(
        ApiURL.currentApiURL + 'surveys',
        data: {
          "survey_id": id_survey,
          "nama_projek": nama_projek_input.text,
          "alamat": alamat_input.text,
          "email": email_input.text,
          "no_telpon": no_telpon_input.text,
          "status": status_input.text
        },
      );
      if (response.statusCode == 200) {
        Get.offAllNamed('/');
      }
    } catch (e) {
      print('object');
    }
  }

  Future<void> deleteSurvey(id_survey) async {
    try {
      final response = await _dio.delete(
        ApiURL.currentApiURL + 'surveys',
        data: {"survey_id": id_survey},
      );
      if (response.statusCode == 204) {
        Get.offAllNamed('/');
      }
    } catch (e) {
      print('object');
    }
  }

  Future<void> getTitik() async {
    try {
      final response = await _dio.post(
        ApiURL.currentApiURL + 'surveys_titik_kamera/survey',
        data: {"survey_id": surveyData['Id_Survey']},
      );
      print(response.data);
      if (response.statusCode == 200) {
        titikData.value = response.data;
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

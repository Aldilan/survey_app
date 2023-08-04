import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:survey_app/modules/globals/api_url.dart';

class FormSurveyController extends GetxController {
  final dio.Dio _dio = dio.Dio();

  TextEditingController nama_projek_input = TextEditingController();
  TextEditingController alamat_input = TextEditingController();
  TextEditingController email_input = TextEditingController();
  TextEditingController no_telpon_input = TextEditingController();
  TextEditingController status_input = TextEditingController();

  Future<void> addSurvey() async {
    try {
      final response = await _dio.post(
        ApiURL.currentApiURL + 'surveys',
        data: {
          "nama_projek": nama_projek_input.text,
          "alamat": alamat_input.text,
          "email": email_input.text,
          "no_telpon": no_telpon_input.text,
          "status": status_input.text
        },
      );
      if (response.statusCode == 201) {
        Get.offAllNamed('/');
      } else {
        print('Somtething wrong');
      }
    } catch (e) {
      print('Somtething wrong');
    }
  }
}

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:survey_app/modules/globals/api_url.dart';
import 'package:path/path.dart';

class DetailSurveyController extends GetxController {
  final dynamic surveyData;
  DetailSurveyController({required this.surveyData});
  late Database _database;

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
    _openDatabase();
    updateTextField();
    getTitik();
    super.onInit();
  }

  Future<void> _openDatabase() async {
    // Buka atau buat database di path yang ditentukan
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'my_database.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // Buat tabel di database jika belum ada
        await db.execute(
          'CREATE TABLE IF NOT EXISTS tb_survey (Id_Survey INTEGER PRIMARY KEY, Nama_Projek TEXT, Alamat TEXT, Email TEXT, Nomor_Telpon, TEXT, Status_Survey TEXT, Status_Sumber Text )',
        );
      },
    );
  }

  void updateTextField() {
    nama_projek_input.text = surveyData['Nama_Projek'];
    alamat_input.text = surveyData['Alamat'];
    email_input.text = surveyData['Email'];
    no_telpon_input.text = surveyData['Nomor_Telpon'];
    status_input.text = surveyData['Status_Survey'];
  }

  void clearTextField() {
    nama_projek_input.text = '';
    alamat_input.text = '';
    email_input.text = '';
    no_telpon_input.text = '';
    status_input.text = '';
  }

  Future<void> updateSurvey(id_survey) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      updateSurveyLocal(id_survey);
    } else if (connectivityResult == ConnectivityResult.mobile) {
      updateSurveyCloud(id_survey);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      updateSurveyCloud(id_survey);
    }
  }

  Future<void> updateSurveyLocal(id_survey) async {
    await _database.update(
      'tb_survey',
      {
        'Nama_Projek': nama_projek_input.text,
        'Alamat': alamat_input.text,
        'Email': email_input.text,
        'Nomor_Telpon': no_telpon_input.text,
        'Status_Survey': status_input.text,
        'Status_Sumber': 'Update',
      },
      where: 'Id_Survey = ?',
      whereArgs: [id_survey],
    );
    List<Map<String, dynamic>> localDataNewUpdate = await _database.query(
      'tb_survey',
      where: 'Id_Survey = ?',
      whereArgs: [id_survey],
    );

    Get.offAllNamed('/');
  }

  Future<void> updateSurveyCloud(id_survey) async {
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
        clearTextField();
        Get.offAllNamed('/');
      }
    } catch (e) {
      print('object');
    }
  }

  Future<void> deleteSurvey(id_survey) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      deleteSurveyLocal(id_survey);
    } else if (connectivityResult == ConnectivityResult.mobile) {
      deleteSurveyCloud(id_survey);
    } else if (connectivityResult == ConnectivityResult.wifi) {
      deleteSurveyCloud(id_survey);
    }
  }

  Future<void> deleteSurveyCloud(id_survey) async {
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

  Future<void> deleteSurveyLocal(id_survey) async {
    List<Map<String, dynamic>> localDataNewDelete = await _database.query(
      'tb_survey',
      where: 'Id_Survey = ?',
      whereArgs: [id_survey],
    );
    await _database.update(
      'tb_survey',
      {
        'Nama_Projek': localDataNewDelete[0]['Nama_Projek'],
        'Alamat': localDataNewDelete[0]['Alamat'],
        'Email': localDataNewDelete[0]['Email'],
        'Nomor_Telpon': localDataNewDelete[0]['Nomor_Telpon'],
        'Status_Survey': localDataNewDelete[0]['Status_Survey'],
        'Status_Sumber': 'Delete',
      },
      where: 'Id_Survey = ?',
      whereArgs: [id_survey],
    );
    Get.offAllNamed('/');
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

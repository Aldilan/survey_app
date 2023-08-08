import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:sqflite/sqflite.dart';
import 'package:survey_app/modules/globals/api_url.dart';
import 'package:path/path.dart';

class FormSurveyController extends GetxController {
  final dio.Dio _dio = dio.Dio();
  late Database _database;

  TextEditingController nama_projek_input = TextEditingController();
  TextEditingController alamat_input = TextEditingController();
  TextEditingController email_input = TextEditingController();
  TextEditingController no_telpon_input = TextEditingController();
  TextEditingController status_input = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    _openDatabase();
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
        await db.execute(
          'CREATE TABLE IF NOT EXISTS tb_survey_titik_kamera (Id_Survey_Titik_Kamera INTEGER PRIMARY KEY, Id_Survey TEXT, Judul_Titik TEXT, Foto_Titik TEXT, Foto_Local TEXT, Status_Sumber TEXT )',
        );
      },
    );
  }

  Future<void> addSurvey() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      addSurveyLocal();
    } else if (connectivityResult == ConnectivityResult.mobile) {
      addSurveyCloud();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      addSurveyCloud();
    }
  }

  Future<void> addSurveyLocal() async {
    await _database.insert(
      'tb_survey',
      {
        'Nama_Projek': nama_projek_input.text,
        'Alamat': alamat_input.text,
        'Email': email_input.text,
        'Nomor_Telpon': no_telpon_input.text,
        'Status_Survey': status_input.text,
        'Status_Sumber': 'Create'
      },
    );
    Get.offAllNamed('/');
  }

  Future<void> addSurveyCloud() async {
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

  Future<void> fetchData() async {
    List<Map<String, dynamic>> data = await _database.query('tb_survey');
    print(data.length);
  }
}

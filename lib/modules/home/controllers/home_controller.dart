import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:survey_app/modules/globals/api_url.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomeController extends GetxController {
  final Dio _dio = Dio();
  late Database _database;
  RxList<dynamic> surveysData = RxList<dynamic>();

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
          'CREATE TABLE IF NOT EXISTS tb_survey (Id_Survey INTEGER PRIMARY KEY, Nama_Projek TEXT, Alamat TEXT, Email TEXT, Nomor_Telpon TEXT, Status_Survey TEXT, Status_Sumber TEXT )',
        );
      },
    );
    if (_database != null) {
      checkInternetConnection();
    }
  }

  void checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      List<Map<String, dynamic>> data = await _database.query(
        'tb_survey',
        where: 'Status_Sumber != ?',
        whereArgs: ['Delete'],
      );
      surveysData.value = data;
    } else if (connectivityResult == ConnectivityResult.mobile) {
      getSurveysData();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      getSurveysData();
    }
  }

  Future<void> getSurveysData() async {
    List<Map<String, dynamic>> localDataNewInsert = await _database.query(
      'tb_survey',
      where: 'Status_Sumber = ?',
      whereArgs: ['Create'],
    );
    List<Map<String, dynamic>> localDataNewDelete = await _database.query(
      'tb_survey',
      where: 'Status_Sumber = ?',
      whereArgs: ['Delete'],
    );
    List<Map<String, dynamic>> localDataNewUpdate = await _database.query(
      'tb_survey',
      where: 'Status_Sumber = ?',
      whereArgs: ['Update'],
    );
    for (var i = 0; i < localDataNewDelete.length; i++) {
      deleteSurveyCloud(localDataNewDelete[i]['Id_Survey']);
    }
    for (var i = 0; i < localDataNewUpdate.length; i++) {
      updateSurveyCloud(
          localDataNewUpdate[i]['Id_Survey'],
          localDataNewUpdate[i]['Nama_Projek'],
          localDataNewUpdate[i]['Alamat'],
          localDataNewUpdate[i]['Email'],
          localDataNewUpdate[i]['Nomor_Telpon'],
          localDataNewUpdate[i]['Status_Survey']);
    }
    for (var i = 0; i < localDataNewInsert.length; i++) {
      addSurveyCloud(
          localDataNewInsert[i]['Nama_Projek'],
          localDataNewInsert[i]['Alamat'],
          localDataNewInsert[i]['Email'],
          localDataNewInsert[i]['Nomor_Telpon'],
          localDataNewInsert[i]['Status_Survey']);
    }
    await _database.delete('tb_survey');
    try {
      final response = await _dio.get(ApiURL.currentApiURL + 'surveys');
      if (response.statusCode == 200) {
        surveysData.value = response.data;
        for (var i = 0; i < surveysData.length; i++) {
          addSurveyLocal(
              response.data[i]['Id_Survey'],
              response.data[i]['Nama_Projek'],
              response.data[i]['Alamat'],
              response.data[i]['Email'],
              response.data[i]['Nomor_Telpon'],
              response.data[i]['Status_Survey'],
              'Import');
        }
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addSurveyCloud(String nama_projek, String alamat, String email,
      String nomor_telepon, String status_survey) async {
    try {
      final response = await _dio.post(
        ApiURL.currentApiURL + 'surveys',
        data: {
          "nama_projek": nama_projek,
          "alamat": alamat,
          "email": email,
          "no_telpon": nomor_telepon,
          "status": status_survey
        },
      );
    } catch (e) {
      print('Somtething wrong');
    }
  }

  Future<void> addSurveyLocal(
      id_survey,
      String nama_projek,
      String alamat,
      String email,
      String nomor_telepon,
      String status_survey,
      String status_sumber) async {
    if (_database == null) {
      await _openDatabase();
    }
    await _database.insert(
      'tb_survey',
      {
        'Id_Survey': id_survey,
        'Nama_Projek': nama_projek,
        'Alamat': alamat,
        'Email': email,
        'Nomor_Telpon': nomor_telepon,
        'Status_Survey': status_survey,
        'Status_Sumber': status_sumber
      },
    );
  }

  Future<void> deleteSurveyCloud(id_survey) async {
    try {
      final response = await _dio.delete(
        ApiURL.currentApiURL + 'surveys',
        data: {"survey_id": id_survey},
      );
    } catch (e) {
      print('object');
    }
  }

  Future<void> updateSurveyCloud(id_survey, String nama_projek, String alamat,
      String email, String nomor_telepon, String status_survey) async {
    try {
      final response = await _dio.put(
        ApiURL.currentApiURL + 'surveys',
        data: {
          "survey_id": id_survey,
          "nama_projek": nama_projek,
          "alamat": alamat,
          "email": email,
          "no_telpon": nomor_telepon,
          "status": status_survey
        },
      );
      print(response.data);
    } catch (e) {
      print('object');
    }
  }
}

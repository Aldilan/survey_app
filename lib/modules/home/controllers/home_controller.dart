import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:survey_app/modules/globals/api_url.dart';
import 'package:connectivity/connectivity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart' hide FormData;
import 'package:dio/dio.dart' as dio;

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
        // Buat tabel tb_survey
        await db.execute(
          'CREATE TABLE IF NOT EXISTS tb_survey (Id_Survey INTEGER PRIMARY KEY, Nama_Projek TEXT, Alamat TEXT, Email TEXT, Nomor_Telpon TEXT, Status_Survey TEXT, Status_Sumber TEXT )',
        );

        // Buat tabel tb_survey_titik_kamera
        await db.execute(
          'CREATE TABLE IF NOT EXISTS tb_survey_titik_kamera (Id_Survey_Titik_Kamera INTEGER PRIMARY KEY, Id_Survey TEXT, Judul_Titik TEXT, Foto_Titik TEXT, Foto_Local TEXT, Status_Sumber TEXT )',
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
    List<Map<String, dynamic>> localDataNewUpdateTitik = await _database.query(
      'tb_survey_titik_kamera',
      where: 'Status_Sumber = ?',
      whereArgs: ['Update'],
    );
    for (var i = 0; i < localDataNewUpdateTitik.length; i++) {
      updateTitikCloud(
          localDataNewUpdateTitik[i]['Id_Survey_Titik_Kamera'],
          localDataNewUpdateTitik[i]['Id_Survey'],
          localDataNewUpdateTitik[i]['Judul_Titik'],
          localDataNewUpdateTitik[i]['Foto_Local']);
    }
    // List<Map<String, dynamic>> localDataNewUpdateTitik = await _database.query(
    //   'tb_survey_titik_kamera',
    //   where: 'Status_Sumber = ?',
    //   whereArgs: ['Update'],
    // );
    // return print(localDataNewUpdateTitik);
    refreshTitikData();
    refreshSurveyData();
    await _database.delete('tb_survey');
    await _database.delete('tb_survey_titik_kamera');
    try {
      final responseSurvey = await _dio.get(ApiURL.currentApiURL + 'surveys');
      if (responseSurvey.statusCode == 200) {
        surveysData.value = responseSurvey.data;
        for (var i = 0; i < surveysData.length; i++) {
          addSurveyLocal(
              responseSurvey.data[i]['Id_Survey'],
              responseSurvey.data[i]['Nama_Projek'],
              responseSurvey.data[i]['Alamat'],
              responseSurvey.data[i]['Email'],
              responseSurvey.data[i]['Nomor_Telpon'],
              responseSurvey.data[i]['Status_Survey'],
              'Import');
        }
      } else {
        print('Request failed with status code: ${responseSurvey.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    try {
      final responseTitik =
          await _dio.get(ApiURL.currentApiURL + 'surveys_titik_kamera');
      if (responseTitik.statusCode == 200) {
        for (var i = 0; i < responseTitik.data.length; i++) {
          addTitikLocal(
              responseTitik.data[i]['Id_Survey_Titik_Kamera'],
              responseTitik.data[i]['Id_Survey'],
              responseTitik.data[i]['Judul_Titik'],
              responseTitik.data[i]['Foto_Titik'],
              'Import');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> refreshTitikData() async {
    List<Map<String, dynamic>> localDataNewDeleteTitik = await _database.query(
      'tb_survey_titik_kamera',
      where: 'Status_Sumber = ?',
      whereArgs: ['Delete'],
    );
    List<Map<String, dynamic>> localDataNewInsertTitik = await _database.query(
      'tb_survey_titik_kamera',
      where: 'Status_Sumber = ?',
      whereArgs: ['Create'],
    );
    List<Map<String, dynamic>> localDataNewUpdateTitik = await _database.query(
      'tb_survey_titik_kamera',
      where: 'Status_Sumber = ?',
      whereArgs: ['Update'],
    );
    print(localDataNewUpdateTitik);
    for (var i = 0; i < localDataNewInsertTitik.length; i++) {
      addTitikCloud(
          localDataNewInsertTitik[i]['Id_Survey'],
          localDataNewInsertTitik[i]['Judul_Titik'],
          localDataNewInsertTitik[i]['Foto_Local']);
    }
    for (var i = 0; i < localDataNewUpdateTitik.length; i++) {}
    for (var i = 0; i < localDataNewDeleteTitik.length; i++) {
      deleteTitikCloud(localDataNewDeleteTitik[i]['Id_Survey_Titik_Kamera']);
    }
  }

  Future<void> refreshSurveyData() async {
    List<Map<String, dynamic>> localDataNewInsertSurvey = await _database.query(
      'tb_survey',
      where: 'Status_Sumber = ?',
      whereArgs: ['Create'],
    );
    List<Map<String, dynamic>> localDataNewDeleteSurvey = await _database.query(
      'tb_survey',
      where: 'Status_Sumber = ?',
      whereArgs: ['Delete'],
    );
    List<Map<String, dynamic>> localDataNewUpdateSurvey = await _database.query(
      'tb_survey',
      where: 'Status_Sumber = ?',
      whereArgs: ['Update'],
    );

    for (var i = 0; i < localDataNewDeleteSurvey.length; i++) {
      deleteSurveyCloud(localDataNewDeleteSurvey[i]['Id_Survey']);
    }
    for (var i = 0; i < localDataNewUpdateSurvey.length; i++) {
      updateSurveyCloud(
          localDataNewUpdateSurvey[i]['Id_Survey'],
          localDataNewUpdateSurvey[i]['Nama_Projek'],
          localDataNewUpdateSurvey[i]['Alamat'],
          localDataNewUpdateSurvey[i]['Email'],
          localDataNewUpdateSurvey[i]['Nomor_Telpon'],
          localDataNewUpdateSurvey[i]['Status_Survey']);
    }
    for (var i = 0; i < localDataNewInsertSurvey.length; i++) {
      addSurveyCloud(
          localDataNewInsertSurvey[i]['Nama_Projek'],
          localDataNewInsertSurvey[i]['Alamat'],
          localDataNewInsertSurvey[i]['Email'],
          localDataNewInsertSurvey[i]['Nomor_Telpon'],
          localDataNewInsertSurvey[i]['Status_Survey']);
    }
  }

  Future<void> updateTitikCloud(id_survey_titik_kamera, id_survey,
      String judul_titik, String foto_local) async {
    print(foto_local);

    XFile localPhoto = XFile(foto_local);
    var selectedPicture = Rx<XFile?>(localPhoto);
    try {
      String fileExtension =
          selectedPicture.value!.path.split('.').last.toLowerCase();
      String filename = 'image.$fileExtension';
      MediaType contentType =
          MediaType('image', fileExtension == 'png' ? 'png' : 'jpeg');
      final formData = dio.FormData.fromMap({
        'image': await dio.MultipartFile.fromFile(
          selectedPicture.value!.path,
          filename: filename,
          contentType: contentType,
        ),
        'id_survey_titik_kamera': id_survey_titik_kamera,
        'id_survey': id_survey,
        'judul_titik': judul_titik,
      });

      final response = await _dio.put(
        ApiURL.currentApiURL + 'surveys_titik_kamera',
        data: formData,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
      } else {
        print('Gagal menambahkan titik survey. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> addTitikCloud(
      id_survey, String judul_titik, String foto_local) async {
    print(foto_local);

    XFile localPhoto = XFile(foto_local);
    var selectedPicture = Rx<XFile?>(localPhoto);
    try {
      String fileExtension =
          selectedPicture.value!.path.split('.').last.toLowerCase();
      String filename = 'image.$fileExtension';
      MediaType contentType =
          MediaType('image', fileExtension == 'png' ? 'png' : 'jpeg');

      final formData = dio.FormData.fromMap({
        'image': await dio.MultipartFile.fromFile(
          selectedPicture.value!.path,
          filename: filename,
          contentType: contentType,
        ),
        'id_survey': id_survey,
        'judul_titik': judul_titik,
      });

      final response = await _dio.post(
        ApiURL.currentApiURL + 'surveys_titik_kamera',
        data: formData,
      );

      print(response.statusCode);
      if (response.statusCode == 201) {
      } else {
        print('Gagal menambahkan titik survey. Status: ${response.statusCode}');
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

  Future<void> addTitikLocal(id_survey_titik_kamera, id_survey,
      String judul_titik, String foto_titik, String status_sumber) async {
    if (_database == null) {
      await _openDatabase();
    }
    await _database.insert(
      'tb_survey_titik_kamera',
      {
        'Id_Survey_Titik_Kamera': id_survey_titik_kamera,
        'Id_Survey': id_survey,
        'Judul_Titik': judul_titik,
        'Foto_Titik': foto_titik,
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

  Future<void> deleteTitikCloud(id_survey_titik_kamera) async {
    try {
      final response = await _dio.delete(
        ApiURL.currentApiURL + 'surveys_titik_kamera',
        data: {"survey_titik_kamera_id": id_survey_titik_kamera},
      );
      if (response.statusCode == 204) {}
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

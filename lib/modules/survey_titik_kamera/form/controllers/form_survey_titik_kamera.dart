import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart' hide FormData;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:survey_app/modules/globals/api_url.dart';
import 'package:path_provider/path_provider.dart';

class FormTitikController extends GetxController {
  final int idSurvey;
  late Database _database;
  FormTitikController({required this.idSurvey});

  final dio.Dio _dio = dio.Dio();
  final picker = ImagePicker();

  final selectedPicture = Rx<XFile?>(null);
  TextEditingController judul_input = TextEditingController();

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

  Future<void> selectPicture(context) async {
    CoolAlert.show(
      title: "Select your image",
      confirmBtnText: 'Camera',
      onConfirmBtnTap: () {
        cameraOption();
      },
      confirmBtnTextStyle: TextStyle(color: Colors.amber),
      cancelBtnText: 'Gallery',
      onCancelBtnTap: () {
        galleryOption();
      },
      cancelBtnTextStyle:
          TextStyle(color: Colors.blueGrey[900], fontWeight: FontWeight.w600),
      backgroundColor: const Color.fromRGBO(38, 50, 56, 1),
      confirmBtnColor: const Color.fromRGBO(38, 50, 56, 1),
      context: context,
      type: CoolAlertType.confirm,
    );
  }

  Future<void> cameraOption() async {
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedPicture.value = image;
    }
  }

  Future<void> galleryOption() async {
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedPicture.value = image;
    }
  }

  Future<void> addTitik() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      addTitikLocal();
    } else if (connectivityResult == ConnectivityResult.mobile) {
      addTitikCloud();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      addTitikCloud();
    }
  }

  Future<void> addTitikLocal() async {
    if (selectedPicture.value != null) {
      XFile? imageFile = selectedPicture.value;
      Directory appDir = await getApplicationDocumentsDirectory();
      String fileName = imageFile!.path.split('/').last;
      String filePath = '${appDir.path}/$fileName';
      File file = File(imageFile.path);
      await file.copy(filePath);

      print(imageFile.path);

      await _database.insert(
        'tb_survey_titik_kamera',
        {
          'Id_Survey': idSurvey,
          'Judul_Titik': judul_input.text,
          'Foto_Titik': 'null',
          'Foto_Local': imageFile.path,
          'Status_Sumber': 'Create'
        },
      );
      Get.offAllNamed('/');
    } else {
      print('Tidak ada gambar dipilih.');
    }
  }

  Future<void> addTitikCloud() async {
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
        'id_survey': idSurvey,
        'judul_titik': judul_input.text,
      });

      final response = await _dio.post(
        ApiURL.currentApiURL + 'surveys_titik_kamera',
        data: formData,
      );

      print(response.statusCode);
      if (response.statusCode == 201) {
        Get.offAllNamed('/');
      } else {
        print('Gagal menambahkan titik survey. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

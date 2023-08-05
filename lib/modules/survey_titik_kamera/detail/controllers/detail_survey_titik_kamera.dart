import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_app/modules/globals/api_url.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart' hide FormData;

class DetailTitikController extends GetxController {
  final dynamic titikData;
  DetailTitikController({required this.titikData});

  final dio.Dio _dio = dio.Dio();
  final picker = ImagePicker();

  final selectedPicture = Rx<XFile?>(null);
  TextEditingController judul_titik_input = TextEditingController();

  @override
  void onInit() {
    print(titikData);
    // TODO: implement onInit
    judul_titik_input.text = titikData['Judul_Titik'];
    super.onInit();
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

  Future<void> updateTitik() async {
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
        'id_survey_titik_kamera': titikData['Id_Survey_Titik_Kamera'],
        'id_survey': titikData['Id_Survey'],
        'judul_titik': judul_titik_input.text,
      });

      final response = await _dio.put(
        ApiURL.currentApiURL + 'surveys_titik_kamera',
        data: formData,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        Get.offAllNamed('/');
      } else {
        print('Gagal menambahkan titik survey. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
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

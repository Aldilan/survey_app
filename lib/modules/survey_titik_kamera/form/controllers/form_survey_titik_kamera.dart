import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart' hide FormData;
import 'package:survey_app/modules/globals/api_url.dart';

class FormTitikController extends GetxController {
  final int idSurvey;
  FormTitikController({required this.idSurvey});

  final dio.Dio _dio = dio.Dio();
  final picker = ImagePicker();
  final selectedPicture = Rx<XFile?>(null);

  TextEditingController judul_input = TextEditingController();

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

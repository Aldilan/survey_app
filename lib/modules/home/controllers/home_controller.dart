import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:survey_app/modules/globals/api_url.dart';

class HomeController extends GetxController {
  final Dio _dio = Dio();

  RxList<dynamic> surveysData = RxList<dynamic>();

  @override
  void onInit() {
    // TODO: implement onInit
    getSurveysData();
    super.onInit();
  }

  Future<void> getSurveysData() async {
    try {
      final response = await _dio.get(ApiURL.currentApiURL + 'surveys');
      if (response.statusCode == 200) {
        surveysData.value = response.data;
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

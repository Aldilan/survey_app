import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:survey_app/modules/globals/api_url.dart';
import 'package:get_storage/get_storage.dart';
import 'package:connectivity/connectivity.dart';

class HomeController extends GetxController {
  final Dio _dio = Dio();
  final box = GetStorage();

  RxList<dynamic> surveysData = RxList<dynamic>();

  @override
  void onInit() {
    // TODO: implement onInit
    checkInternetConnection();
    super.onInit();
  }

  void checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (box.read('surveyData') != null) {
        surveysData.value = box.read('surveyData');
        print(surveysData);
      }
    } else if (connectivityResult == ConnectivityResult.mobile) {
      getSurveysData();
      print(box.read('surveyData'));
    } else if (connectivityResult == ConnectivityResult.wifi) {
      print(box.read('surveyData'));
      getSurveysData();
    }
  }

  Future<void> getSurveysData() async {
    try {
      final response = await _dio.get(ApiURL.currentApiURL + 'surveys');
      if (response.statusCode == 200) {
        surveysData.value = response.data;
        List<dynamic> dataToSave = surveysData.toList();
        box.write('surveyData', dataToSave);
        print(box.read('surveyData'));
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

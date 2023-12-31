import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:survey_app/modules/home/controllers/home_controller.dart';
import 'package:survey_app/modules/home/widgets/survey_card.dart';
import 'package:survey_app/widgets/circleLoadingWidget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  HomeController c = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        elevation: 0,
        title: Text(
          "List Survey",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed('/form_survey');
              },
              icon: Icon(
                Icons.add,
                color: Colors.amber,
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.offAllNamed('/');
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () => ListView.builder(
              itemCount: c.surveysData.length == 0 ? 1 : c.surveysData.length,
              itemBuilder: (context, index) {
                return c.surveysData.length == 0
                    ? CircleLoadingWidget()
                    : SurveyCard(
                        surveyData: c.surveysData[index],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

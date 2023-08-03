import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_app/modules/home/widgets/survey_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) {
            return SurveyCard();
          },
        ),
      ),
    );
  }
}

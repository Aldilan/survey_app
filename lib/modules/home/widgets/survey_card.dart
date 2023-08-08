import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_app/modules/survey/detail/detail_survey.dart';

class SurveyCard extends StatelessWidget {
  final dynamic surveyData;
  const SurveyCard({super.key, required this.surveyData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(DetailSurvey(
          surveyData: surveyData,
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blueGrey[800],
        ),
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    surveyData['Nama_Projek'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    surveyData['Status_Survey'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 13,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  surveyData['Alamat'],
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.mail_outline,
                  color: Colors.white,
                  size: 13,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  surveyData['Email'],
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  Icons.phone,
                  color: Colors.green,
                  size: 13,
                ),
                SizedBox(
                  width: 3,
                ),
                Text(
                  surveyData['Nomor_Telpon'],
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

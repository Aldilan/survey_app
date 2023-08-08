import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:survey_app/modules/globals/api_url.dart';
import 'package:survey_app/modules/survey_titik_kamera/detail/detail_survey_titik_kamera.dart';
import 'package:survey_app/widgets/imageNotFoundWidget.dart';

class TitikCard extends StatelessWidget {
  final dynamic titikData;
  const TitikCard({super.key, required this.titikData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(DetailTitik(titikData: titikData));
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
            Text(
              titikData['Judul_Titik'].toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 10,
            ),
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: titikData['Foto_Titik'].toString() == 'null'
                    ? Image.file(File(titikData['Foto_Local']))
                    : Image.network(
                        ApiURL.currentImageApiURL + titikData['Foto_Titik'],
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          // Konten yang akan ditampilkan jika gambar tidak ditemukan
                          return ImageNotFoundWidget();
                        },
                      ))
          ],
        ),
      ),
    );
  }
}

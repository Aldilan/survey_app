import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TitikCard extends StatelessWidget {
  const TitikCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/detail_titik');
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
              'Pojok Kanan',
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
              child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/a/a1/Three_Surveillance_cameras.jpg'),
            )
          ],
        ),
      ),
    );
  }
}

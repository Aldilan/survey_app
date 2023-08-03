import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurveyCard extends StatelessWidget {
  const SurveyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/detail_survey');
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
                    'Pemasangan CCTV di SMK Wikrama',
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
                    'Active',
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
                  'Bogor',
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
                  'wikrama@sch.id',
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
                  '08023948334',
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

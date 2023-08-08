import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageNotFoundWidget extends StatelessWidget {
  const ImageNotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.blueGrey[700]),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: MediaQuery.of(context).size.width * 0.1,
              color: Colors.red,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Foto tidak ditemukan!r',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Text(
              'Ini kemungkinan anda sedang offline atau foto telah dihapus dari server',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            )
          ],
        ));
  }
}

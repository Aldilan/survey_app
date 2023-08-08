import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CircleLoadingWidget extends StatelessWidget {
  const CircleLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.2),
      child: LoadingAnimationWidget.threeArchedCircle(
          color: Colors.amber, size: MediaQuery.of(context).size.width * 0.15),
    );
  }
}

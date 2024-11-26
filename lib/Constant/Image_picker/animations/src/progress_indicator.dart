import 'package:flutter/material.dart';

import '../../../Con_Clr.dart';


class AppCircularProgressIndicator extends StatelessWidget {

  const AppCircularProgressIndicator({
    Key? key,
    this.color = Colors.black26,
    this.backgroundColor = Con_white38,
    this.strokeWidth = 4.0,
  }) : super(key: key);

  final Color color;

  final Color? backgroundColor;

  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: Con_Main_1,
      backgroundColor: backgroundColor,
      strokeWidth: strokeWidth,
    );
  }
}

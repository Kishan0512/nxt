import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../Constant/Con_Clr.dart';
import '../../../mdi_page/A_ChatBubble/audio/helpers/utils.dart';

/// document will be added
class Noises extends StatelessWidget {
  const Noises({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [for (int i = 0; i < 27; i++) _singleNoise(context)],
    );
  }

  _singleNoise(BuildContext context) {
    final double height = 5.74.w() * math.Random().nextDouble() + .26.w();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: .2.w()),
      width: .56.w(),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: Con_white,
      ),
    );
  }
}

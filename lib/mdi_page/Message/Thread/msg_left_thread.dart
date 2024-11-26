import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Con_Clr.dart';

class LeftThread extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final double r;

  const LeftThread(this.message,
      {Key? key, this.r = 2.5, this.backgroundColor = Con_white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ClipRThread(r),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(r)),
          child: Container(
            constraints:
                BoxConstraints.loose(MediaQuery.of(context).size * 0.8),
            padding: EdgeInsets.fromLTRB(8.0 + 2 * r, 8.0, 8.0, 8.0),
            color: Chat_Row_RightSideFontColor,
            child: Text(
              message,
              softWrap: true,
            ),
          ),
        ),
      ),
    );
  }
}

class ClipRThread extends CustomClipper<Path> {
  final double chatRadius;

  ClipRThread(this.chatRadius);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, chatRadius);
    final r = chatRadius;
    const angle = 0.785;
    path.conicTo(
      r - r * sin(angle),
      r + r * cos(angle),
      r - r * sin(angle * 0.5),
      r + r * cos(angle * 0.5),
      1,
    );

    final moveIn = 2 * r; // need to be > 2 * r
    path.lineTo(moveIn, r + moveIn * tan(angle));

    path.lineTo(moveIn, size.height - chatRadius);

    path.conicTo(
      moveIn + r - r * cos(angle),
      size.height - r + r * sin(angle),
      moveIn + r,
      size.height,
      1,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

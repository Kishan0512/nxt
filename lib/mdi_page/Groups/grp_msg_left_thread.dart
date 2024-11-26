import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nextapp/Constant/Constants.dart';

import '../../Constant/Con_Clr.dart';

class GrpLeftThread extends StatelessWidget {
  final String user;
  final String message;
  final Color backgroundColor;
  final double r;

  const GrpLeftThread(this.user, this.message,
      {super.key, this.r = 2.5, this.backgroundColor = Con_white});

  @override
  Widget build(BuildContext context) {
    String pStrName = Constants_List.need_contact
            .where((element) => element.id == user)
            .isNotEmpty
        ? Constants_List.need_contact
            .where((element) => element.id == user)
            .first
            .name
        : user;
    return ListTile(
      dense: true,
      title: Text(
        pStrName,
        softWrap: true,
      ),
      subtitle: Text(
        message,
        softWrap: true,
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

    final moveIn = 2 * r;
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

import 'package:flutter/material.dart';


class AppAnimatedCrossFade extends StatelessWidget {

  const AppAnimatedCrossFade({
    Key? key,
    required this.firstChild,
    required this.secondChild,
    required this.crossFadeState,
    this.alignment,
  }) : super(key: key);
  final Widget firstChild;
  final Widget secondChild;
  final CrossFadeState crossFadeState;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: firstChild,
      secondChild: secondChild,
      crossFadeState: crossFadeState,
      duration: const Duration(milliseconds: 200),
      layoutBuilder: (
        Widget topChild,
        Key topChildKey,
        Widget bottomChild,
        Key bottomChildKey,
      ) {
        return Stack(
          clipBehavior: Clip.none,
          alignment: alignment ?? Alignment.center,
          children: [
            Align(
              key: bottomChildKey,
              child: bottomChild,
            ),
            Align(
              alignment: alignment ?? Alignment.center,
              key: topChildKey,
              child: topChild,
            ),
          ],
        );
      },
    );
  }
}

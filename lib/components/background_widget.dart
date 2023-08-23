import 'package:flutter/material.dart';
import 'package:musiclyric/constants.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  final bool hasBackground;
  final Color? color;

  const BackgroundWidget(
      {super.key,
      required this.child,
      required this.hasBackground,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: hasBackground
          ? BoxDecoration(
              gradient: LinearGradient(colors: gradientWaveColorLast))
          : BoxDecoration(color: color ?? Colors.transparent),
      child: child,
    );
  }
}

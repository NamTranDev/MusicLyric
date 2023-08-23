import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Blob extends StatelessWidget {
  final Color color;
  final double scale;
  final double rotation;

  const Blob(
      {super.key, required this.color, this.scale = 1, this.rotation = 0});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(150),
                topRight: Radius.circular(240),
                bottomLeft: Radius.circular(220),
                bottomRight: Radius.circular(180),
              )),
        ),
      ),
    );
  }
}

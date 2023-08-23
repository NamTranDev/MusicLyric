import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../widget/music_button/blob.dart';
import 'dart:math' show pi;

class MusicButton extends StatefulWidget {
  final Widget child;
  final double size;
  final Color backgroundButton;
  final MusicButtonController? controller;

  const MusicButton(
      {super.key,
      required this.child,
      this.controller,
      required this.size,
      required this.backgroundButton});

  @override
  State<MusicButton> createState() => _MusicButtonState();
}

class _MusicButtonState extends State<MusicButton>
    with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  double _rotation = 0;
  double _scale = 0.85;

  late AnimationController _rotateController;
  late AnimationController _scaleController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    _rotateController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(() {
            setState(() {
              _rotation = _rotateController.value * 2 * pi;
            });
          })
          ..repeat();

    _scaleController =
        AnimationController(vsync: this, duration: _kToggleDuration);

    animation = Tween(begin: 1.0, end: 1.25).animate(_scaleController)
      ..addListener(() {
        setState(() {});
      });

    widget.controller?.addListener(() {
      if (widget.controller?.isPlaying == true) {
        _scaleController.forward();
      } else {
        _scaleController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.controller?.isPlaying == true) ...[
            Blob(
                color: Color(0xff0092ff),
                scale: animation.value,
                rotation: _rotation),
            Blob(
                color: Color(0xff4abc7b7),
                scale: animation.value,
                rotation: _rotation * 2 - 30),
            Blob(
                color: Color(0xffa4a6f6),
                scale: animation.value,
                rotation: _rotation * 3 - 45),
          ],
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: widget.backgroundButton),
            child: widget.child,
          )
        ],
      ),
    );
  }
}

class MusicButtonController extends ChangeNotifier {
  bool isPlaying = false;

  void playing() {
    isPlaying = true;
    notifyListeners();
  }

  void pause() {
    isPlaying = false;
    notifyListeners();
  }
}

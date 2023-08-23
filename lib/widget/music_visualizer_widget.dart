import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class VisualComponent extends StatefulWidget {
  final int duration;
  final double maxHeight;
  const VisualComponent(
      {super.key, required this.duration, required this.maxHeight});

  @override
  State<VisualComponent> createState() => _VisualComponentState();
}

class _VisualComponentState extends State<VisualComponent>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.duration));

    final curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutCubic);

    animation =
        Tween<double>(begin: widget.maxHeight / 3, end: widget.maxHeight)
            .animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });
    animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: animation.value,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class MusicVisualizer extends StatelessWidget {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.yellowAccent
  ];

  List<int> durations = [900, 700, 600, 800, 500];

  MusicVisualizer({super.key});

  @override
  Widget build(BuildContext context) {
    double height = 30;
    return Container(
      width: height,
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(
          5,
          (index) => VisualComponent(
            maxHeight: height - 5,
            duration: durations[index % 5],
          ),
        ),
      ),
    );
  }
}

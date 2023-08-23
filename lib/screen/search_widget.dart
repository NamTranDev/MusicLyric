import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import '../../logger.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key, required this.sizeWidth});

  final double sizeWidth;

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget>
    with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  late AnimateIconController animationControllerIcon;
  bool isExpand = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    final curvedAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOutExpo);

    logger(widget.sizeWidth);
    animation =
        Tween<double>(begin: 0, end: widget.sizeWidth).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              isExpand = true;
              focusNode.requestFocus();
            } else if (status == AnimationStatus.dismissed) {
              isExpand = false;
              focusNode.unfocus();
            }
          });

    animationControllerIcon = AnimateIconController();

    focusNode.addListener(() {
      if (!focusNode.hasFocus && isExpand) {
        animationController.reverse();
        animationControllerIcon.animateToStart();
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: animation.value,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 5),
              child: TextField(
                focusNode: focusNode,
                cursorColor: Colors.white12,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: animation.value > 1
                    ? BorderRadius.only(
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50))
                    : BorderRadius.circular(50)),
            child: Center(
              child: AnimateIcons(
                startIcon: Icons.search,
                endIcon: Icons.close,
                startIconColor: Colors.white,
                endIconColor: Colors.white,
                controller: animationControllerIcon,
                size: 20.0,
                duration: Duration(milliseconds: 500),
                onEndIconPress: () {
                  return animationInput();
                },
                onStartIconPress: () {
                  return animationInput();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  bool animationInput() {
    if (!animationController.isAnimating) {
      if (!isExpand) {
        animationController.forward();
        animationControllerIcon.animateToEnd;
      } else {
        animationController.reverse();
        animationControllerIcon.animateToStart();
      }
      return true;
    }
    return false;
  }
}

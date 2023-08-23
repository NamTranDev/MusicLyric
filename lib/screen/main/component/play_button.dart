import 'package:flutter/material.dart';
import '../../../widget/music_button/music_button.dart';

import '../../../notifiers/play_button_notifier.dart';
import '../../../services/player_manager.dart';
import '../../../services/service_locator.dart';

class PlayButton extends StatefulWidget {
  final PlayButtonController? controller;
  final double size;
  final Color background;
  final Color colorIcon;
  const PlayButton(
      {Key? key,
      this.controller,
      required this.size,
      required this.background,
      required this.colorIcon})
      : super(key: key);

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late MusicButtonController _musicButtonController;

  @override
  void initState() {
    super.initState();

    _musicButtonController = MusicButtonController();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));

    widget.controller?.addListener(() {
      if (widget.controller?.isAnimationPlaying == true) {
        _musicButtonController.playing();
        _animationController.forward();
      } else {
        _musicButtonController.pause();
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    // widget.controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerManager = getIt<PlayerManager>();
    return MusicButton(
      size: widget.size,
      backgroundButton: widget.background,
      controller: _musicButtonController,
      child: InkWell(
        child: AnimatedIcon(
          size: widget.size,
          icon: AnimatedIcons.play_pause,
          progress: _animationController,
          color: widget.colorIcon,
        ),
        onTap: () {
          switch (playerManager.currentPlayState()) {
            case ButtonState.paused:
              _animationController.forward();
              playerManager.play();
              break;
            case ButtonState.playing:
              _animationController.reverse();
              playerManager.pause();
              break;
            default:
              break;
          }
        },
      ),
    );
  }
}

class PlayButtonController extends ChangeNotifier {
  bool isAnimationPlaying = false;

  void animationPlaying() {
    this.isAnimationPlaying = true;
    notifyListeners();
  }

  void animationPause() {
    this.isAnimationPlaying = false;
    notifyListeners();
  }
}

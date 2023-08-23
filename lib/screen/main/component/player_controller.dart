import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musiclyric/screen/main/component/audio_progress_bar.dart';
import 'package:musiclyric/screen/main/component/play_button.dart';
import 'package:musiclyric/screen/main/component/repeat_button.dart';
import 'package:musiclyric/screen/main/component/shuffle_button.dart';
import '../../../constants.dart';
import '../../../notifiers/play_button_notifier.dart';
import '../../../services/player_manager.dart';
import '../../../services/service_locator.dart';
import '../../../widget/wave_config.dart';
import '../../../widget/wave_widget.dart';

class PlayerController extends StatefulWidget {
  const PlayerController({super.key});

  @override
  State<PlayerController> createState() => _PlayerControllerState();
}

class _PlayerControllerState extends State<PlayerController> {
  late final WaveController _waveController;
  late final PlayButtonController _playButtonController;

  @override
  void initState() {
    super.initState();
    _waveController = WaveController();
    _playButtonController = PlayButtonController();

    getIt<PlayerManager>().statusButtonListener = (value) {
      switch (value) {
        case ButtonState.paused:
          _playButtonController.animationPause();
          _waveController.pause();
          break;
        case ButtonState.playing:
          _playButtonController.animationPlaying();
          _waveController.resume();
          break;
        default:
          break;
      }
    };
  }

  @override
  void dispose() {
    getIt<PlayerManager>().statusButtonListener = null;
    // _waveController.dispose();
    // _playButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playerManager = getIt<PlayerManager>();
    return Stack(
      children: [
        WaveWidget(
          controller: _waveController,
          config: CustomConfig(
            gradients: gradientsWaveColors,
            durations: [10000, 12500, 15000, 17500],
            heightPercentages: [0.2, 0.2, 0.2, 0.2],
            blur: const MaskFilter.blur(BlurStyle.solid, 1),
            gradientBegin: Alignment.bottomLeft,
            gradientEnd: Alignment.topRight,
          ),
          backgroundColor: backgroundColor,
          size: const Size(double.infinity, 100),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const AudioProgressBar(),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RepeatButton(),
                    IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: sizeIconPlayerAnother,
                        onPressed: () {
                          playerManager.previous();
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          color: colorSecondPrimary,
                        )),
                    PlayButton(
                      size: sizeIconPlayer,
                      background: colorSecondPrimary,
                      colorIcon: Colors.white,
                      controller: _playButtonController,
                    ),
                    IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: sizeIconPlayerAnother,
                        onPressed: () {
                          playerManager.next();
                        },
                        icon: const Icon(
                          Icons.skip_next,
                          color: colorSecondPrimary,
                        )),
                    ShuffleButton()
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
    ;
  }
}

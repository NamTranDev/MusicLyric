import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../notifiers/repeat_button_notifier.dart';
import '../../../services/player_manager.dart';
import '../../../services/service_locator.dart';

class RepeatButton extends StatelessWidget {
  const RepeatButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PlayerManager>();
    return ValueListenableBuilder<RepeatState>(
      valueListenable: pageManager.repeatButtonNotifier,
      builder: (context, value, child) {
        Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = Icon(Icons.repeat, color: colorSecondPrimary.withAlpha(125));
            break;
          case RepeatState.repeatSong:
            icon = const Icon(
              Icons.repeat_one,
              color: colorSecondPrimary,
            );
            break;
          case RepeatState.repeatPlaylist:
            icon = const Icon(
              Icons.repeat,
              color: colorSecondPrimary,
            );
            break;
        }
        return IconButton(
          icon: icon,
          onPressed: pageManager.repeat,
        );
      },
    );
  }
}

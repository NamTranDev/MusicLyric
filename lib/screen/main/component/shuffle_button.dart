import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../services/player_manager.dart';
import '../../../services/service_locator.dart';

class ShuffleButton extends StatelessWidget {
  const ShuffleButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PlayerManager>();
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, child) {
        return IconButton(
          icon: (isEnabled)
              ? const Icon(
                  Icons.shuffle,
                  color: colorSecondPrimary,
                )
              : Icon(Icons.shuffle, color: colorSecondPrimary.withAlpha(125)),
          onPressed: pageManager.shuffle,
        );
      },
    );
  }
}

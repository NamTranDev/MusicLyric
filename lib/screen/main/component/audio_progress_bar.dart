import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import '../../../constants.dart';
import '../../../notifiers/progress_notifier.dart';
import '../../../services/player_manager.dart';
import '../../../services/service_locator.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final playerManager = getIt<PlayerManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: playerManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          timeLabelLocation: TimeLabelLocation.none,
          barHeight: 2,
          baseBarColor: colorSecondPrimary.withAlpha(125),
          progressBarColor: colorSecondPrimary,
          thumbColor: colorSecondPrimary,
          thumbRadius: 8,
          thumbGlowRadius: 5,
          progress: value.current,
          // buffered: value.buffered,
          total: value.total,
          onSeek: playerManager.seek,
        );
      },
    );
  }
}

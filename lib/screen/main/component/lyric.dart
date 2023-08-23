import 'package:flutter/cupertino.dart';
import '../../../constants.dart';
import 'package:lyric/lyric_ui/lyric_ui.dart';
import 'package:lyric/lyric_ui/ui_netease.dart';
import 'package:lyric/lyrics_reader_model.dart';
import 'package:lyric/lyrics_reader_widget.dart';

import '../../../notifiers/progress_notifier.dart';
import '../../../services/player_manager.dart';
import '../../../services/service_locator.dart';

class LyricView extends StatelessWidget {
  final LyricsReaderModel lyric;
  final LyricUI _lyricUI = UINetease(
      playingMainTextStyle: const TextStyle(
          fontSize: 25, color: colorSecondPrimary, fontWeight: FontWeight.bold),
      otherMainTextStyle: const TextStyle(fontSize: 20, color: textColor),
      highLightTextColor: colorSecondPrimary,
      highlight: false);

  LyricView({super.key, required this.lyric});

  @override
  Widget build(BuildContext context) {
    final playerManager = getIt<PlayerManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: playerManager.progressNotifier,
      builder: (_, value, __) {
        return LyricsReader(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          model: lyric,
          position: value.current.inMilliseconds,
          lyricUi: _lyricUI,
          playing: value.isPlaying,
        );
      },
    );
  }
}

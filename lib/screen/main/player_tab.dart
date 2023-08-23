import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../model/song.dart';
import 'component/lyric.dart';
import 'component/player_controller.dart';
import '../../../services/player_manager.dart';
import '../../../services/service_locator.dart';
import 'package:lyric/lyrics_model_builder.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Expanded(
          child: buildDisplaySong(),
        ),
        const PlayerController(),
      ],
    );
  }

  Widget buildDisplaySong() {
    final playerManager = getIt<PlayerManager>();
    return ValueListenableBuilder<Song?>(
      valueListenable: playerManager.songNotifier,
      builder: (context, song, _) {
        return song == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.only(top: 50, left: 50, right: 50),
                    child: Center(
                      child: Text(
                        song.nameOfSong ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: mainTextColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Center(
                      child: Text(
                        song.artist ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: LyricView(
                      lyric: LyricsModelBuilder.create()
                          .bindLyricToMain(song.lyric ?? '')
                          .getModel(),
                    ),
                  )
                ],
              );
      },
    );
  }
}

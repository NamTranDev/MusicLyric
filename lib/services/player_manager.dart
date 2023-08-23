import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:musiclyric/logger.dart';
import 'package:musiclyric/storage/db_provider.dart';
import '../../model/song.dart';
import '../../notifiers/song_info_notifier.dart';
import '../../notifiers/play_button_notifier.dart';
import '../../notifiers/progress_notifier.dart';
import '../../notifiers/repeat_button_notifier.dart';
import '../../services/service_locator.dart';

class PlayerManager {
  // Listeners: Updates going to the UI
  final songListNotifier = ValueNotifier<List<Song>>([]);
  final songNotifier = SongNotifier(null);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final playButtonNotifier = PlayButtonNotifier();
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);

  final _audioHandler = getIt<AudioHandler>();

  bool _isForceUpdate = false;

  Function? statusButtonListener;

  // Events: Calls coming from the UI
  void init() async {
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();

    if (kIsWeb) {
      await _audioHandler.skipToQueueItem(0);
    }
  }

  Future<void> loadSong() async {
    final db = getIt<DBProvider>();
    final playlist = await db.getAllMusic();
    final mediaItems = playlist
        .where((element) => element.link != null)
        .map((song) => MediaItem(
              id: song.id ?? '',
              artist: song.artist ?? '',
              title: song.nameOfSong ?? '',
              extras: {
                Song.FILE_NAME: song.fileName,
                Song.LINK: song.link,
                Song.PATH: song.path,
                Song.LYRIC: song.lyric,
              },
            ))
        .toList();
    mediaItems.shuffle();
    await _audioHandler.addQueueItems(mediaItems);
    logger('_loadSong Complete');
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (songListNotifier.value.isEmpty || _isForceUpdate) {
        _isForceUpdate = false;
        // logger(object: playlist, tag: '_listenToChangesInPlaylist');
        if (playlist.isEmpty) {
          songListNotifier.value = [];
        } else {
          final newList = playlist
              .map((item) => Song(
                    id: item.id,
                    nameOfSong: item.title,
                    artist: item.artist,
                    fileName: item.extras?[Song.FILE_NAME],
                    link: item.extras?[Song.LINK],
                    path: item.extras?[Song.PATH],
                    lyric: item.extras?[Song.LYRIC],
                  ))
              .toList();
          songListNotifier.value = newList;
        }
        updateSongInfo();
      }
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      // logger(object: playbackState, tag: '_listenToPlaybackState');
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      // if (processingState == AudioProcessingState.loading ||
      //     processingState == AudioProcessingState.buffering) {
      //   playButtonNotifier.value = ButtonState.loading;
      // } else
      if (!isPlaying) {
        if (playButtonNotifier.value != ButtonState.paused) {
          playButtonNotifier.value = ButtonState.paused;
          statusButtonListener?.call(ButtonState.paused);
        }
      } else if (processingState != AudioProcessingState.completed) {
        if (playButtonNotifier.value != ButtonState.playing) {
          playButtonNotifier.value = ButtonState.playing;
          statusButtonListener?.call(ButtonState.playing);
        }
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }

      _updateProcess(isPlaying: isPlaying);
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      _updateProcess(current: position);
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      _updateProcess(buffered: playbackState.bufferedPosition);
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      // logger(tag: '_listenToTotalDuration');
      _updateProcess(total: mediaItem?.duration);
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      // logger(object: mediaItem, tag: '_listenToChangesInSong');
      updateSongInfo();
    });
  }

  void playIndex(Song song) async {
    int index = _audioHandler.queue.value
        .indexWhere((element) => element.id == song.id);
    await _audioHandler.skipToQueueItem(index);

    updateSongInfo(song: song);
  }

  int? currentIndex() {
    final item = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (item == null) {
      return null;
    }
    return playlist.indexOf(item);
  }

  void updateSongInfo({Song? song}) {
    if (song != null) {
      songNotifier.value = song;
      return;
    }
    final item = _audioHandler.mediaItem.value;

    if (item == null) {
      return;
    }

    if (songNotifier.value?.id != item.id) {
      songNotifier.value = Song(
        id: item.id,
        nameOfSong: item.title,
        artist: item.artist,
        fileName: item.extras?[Song.FILE_NAME],
        link: item.extras?[Song.LINK],
        path: item.extras?[Song.PATH],
        lyric: item.extras?[Song.LYRIC],
      );

      _updateProcess(
          total: item.duration,
          isPlaying: _audioHandler.playbackState.value.playing);
    }
  }

  void _updateProcess(
      {Duration? current,
      Duration? buffered,
      Duration? total,
      bool? isPlaying}) {
    final oldState = progressNotifier.value;

    progressNotifier.value = ProgressBarState(
      current: current ?? oldState.current,
      buffered: buffered ?? oldState.buffered,
      total: total ?? oldState.total,
      isPlaying: isPlaying ?? oldState.isPlaying,
    );
  }

  void play() => _audioHandler.play();
  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();
  void next() => _audioHandler.skipToNext();

  ButtonState? currentPlayState() {
    PlaybackState state = _audioHandler.playbackState.value;
    final isPlaying = state.playing;
    final processingState = state.processingState;
    if (!isPlaying) {
      return ButtonState.paused;
    } else if (processingState != AudioProcessingState.completed) {
      return ButtonState.playing;
    } else {
      return null;
    }
  }

  void repeat() {
    repeatButtonNotifier.nextState();
    final repeatMode = repeatButtonNotifier.value;
    switch (repeatMode) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  // Future<void> add() async {
  //   final songRepository = getIt<PlaylistRepository>();
  //   final song = await songRepository.fetchAnotherSong();
  //   final mediaItem = MediaItem(
  //     id: song['id'] ?? '',
  //     album: song['album'] ?? '',
  //     title: song['title'] ?? '',
  //     extras: {'url': song['url']},
  //   );
  //   _audioHandler.addQueueItem(mediaItem);
  // }

  // void remove() {
  //   final lastIndex = _audioHandler.queue.value.length - 1;
  //   if (lastIndex < 0) return;
  //   _audioHandler.removeQueueItemAt(lastIndex);
  // }

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }

  bool isPlaying() {
    return playButtonNotifier.value == ButtonState.playing;
  }
}

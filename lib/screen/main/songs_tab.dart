import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../model/song.dart';
import '../../../notifiers/play_button_notifier.dart';
import 'component/play_button.dart';
import '../../../services/player_manager.dart';
import '../../../services/service_locator.dart';
import '../../../widget/music_visualizer_widget.dart';

class ListSongScreen extends StatefulWidget {
  const ListSongScreen({super.key});

  @override
  State<ListSongScreen> createState() => _ListSongScreenState();
}

class _ListSongScreenState extends State<ListSongScreen>
    with AutomaticKeepAliveClientMixin {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  TextEditingController editingController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final playerManager = getIt<PlayerManager>();
    List<Song> items = [];
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(20),
          decoration: _focusNode.hasFocus
              ? const BoxDecoration(boxShadow: [BoxShadow(blurRadius: 1)])
              : null,
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: editingController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                  hintText: 'Search',
                  fillColor: Colors.white,
                  hoverColor: Colors.white,
                  filled: true,
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colorPrimary, width: 0.5)),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 1)),
              style: TextStyle(fontSize: 18),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder<List<Song>>(
            valueListenable: playerManager.songListNotifier,
            builder: (context, value, child) {
              items = value
                  .where((item) =>
                      item.nameOfSong
                          ?.toLowerCase()
                          .contains(editingController.text.toLowerCase()) ==
                      true)
                  .toList();
              return ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    autofocus: false,
                    hoverColor: Colors.transparent,
                    onTap: () async {
                      Song? song = playerManager.songNotifier.value;

                      if (items[index].id != song?.id) {
                        playerManager.playIndex(items[index]);
                      }
                    },
                    child: ValueListenableBuilder(
                      valueListenable: playerManager.songNotifier,
                      builder: (context, value, child) {
                        if (items[index].id == value?.id) {
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            elevation: 4,
                            child: buildItemSong(items[index],
                                currentSelect: true),
                          );
                        }
                        return buildItemSong(items[index],
                            currentSelect: false);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildItemSong(Song item, {bool currentSelect = false}) {
    final playerManager = getIt<PlayerManager>();
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: 10, horizontal: currentSelect ? 10 : 20),
      child: Row(children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.nameOfSong ?? '',
                maxLines: 1,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text(
                item.artist ?? '',
                maxLines: 1,
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
        if (currentSelect) ...[
          ValueListenableBuilder(
            valueListenable: playerManager.playButtonNotifier,
            builder: (context, value, child) {
              return value == ButtonState.playing
                  ? MusicVisualizer()
                  : const PlayButton(
                      size: sizeIconPlayer / 2,
                      background: colorPrimary,
                      colorIcon: Colors.white,
                    );
            },
          )
        ]
      ]),
    );
  }
}

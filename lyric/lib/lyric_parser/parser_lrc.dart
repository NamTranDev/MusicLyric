

import '../lyrics_log.dart';
import '../lyrics_reader_model.dart';
import 'lyrics_parse.dart';

///normal lyric parser
class ParserLrc extends LyricsParse {
  RegExp pattern = RegExp(r"\[\d{2}:\d{2}.\d{2,3}]");

  ///Match normal format content
  ///eg:[00:03.47] -> 00:03.47
  RegExp valuePattern = RegExp(r"\[(\d{2}:\d{2}.\d{2,3})\]");

  ParserLrc(String lyric) : super(lyric);

  @override
  List<LyricsLineModel> parseLines({bool isMain: true}) {
    //read each line
    var lines = lyric.split("\n");
    if (lines.isEmpty) {
      LyricsLog.logD("Lyrics not parsed");
      return [];
    }
    List<LyricsLineModel> lineList = [];
    lines.forEach((line) {
      //match time
      var time = pattern.stringMatch(line);
      if (time == null) {
      //No match to return directly
      //TODO Song-related information is not processed yet
        LyricsLog.logD("Ignores that do not match Time:$line");
        return;
      }
      //Remove time, get real lyrics
      var realLyrics = line.replaceFirst(pattern, "");
      //transfer timestamp
      var ts = timeTagToTS(time);
      LyricsLog.logD("Match time: $time($ts) Real lyrics: $realLyrics");
      var lineModel = LyricsLineModel()..startTime = ts;
      if (realLyrics == "//") {
        LyricsLog.logD("Remove invalid characters://");
        realLyrics = "";
      }
      if (isMain) {
        lineModel.mainText = realLyrics;
      } else {
        lineModel.extText = realLyrics;
      }
      lineList.add(lineModel);
    });
    return lineList;
  }

  int? timeTagToTS(String timeTag) {
    if (timeTag.trim().isEmpty) {
      return null;
    }
    //Take out the value by regularization
    var value = valuePattern.firstMatch(timeTag)?.group(1) ?? "";
    if (value.isEmpty) {
      LyricsLog.logW("Did not get time value:$timeTag");
      return null;
    }
    var timeArray = value.split(".");
    var padZero = 3 - timeArray.last.length;
    var millisecond = timeArray.last.padRight(padZero, "0");
    //avoid weirdness
    if (millisecond.length > 3) {
      millisecond = millisecond.substring(0, 3);
    }
    var minAndSecArray = timeArray.first.split(":");
    return Duration(
            minutes: int.parse(minAndSecArray.first),
            seconds: int.parse(minAndSecArray.last),
            milliseconds: int.parse(millisecond))
        .inMilliseconds;
  }
}

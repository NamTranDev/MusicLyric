import 'package:flutter/material.dart';

///lyric UI base
///all lyric UI should be extends this file
abstract class LyricUI {
  ///Master Lyric Style (Play Row)
  TextStyle getPlayingMainTextStyle();

  ///Extended Lyric Style (Play Row)
  TextStyle getPlayingExtTextStyle();

  ///Master Lyric Style (Other Lines)
  TextStyle getOtherMainTextStyle();

  ///Extended Lyric Style (Other Lines)
  TextStyle getOtherExtTextStyle();

  ///Blank line default height
  double getBlankLineHeight() => 0;

  ///line height
  double getLineSpace();

  ///Inline spacing
  double getInlineSpace();

  ///Play row offset
  ///Offset from top to bottom, range: 0~1;
  ///eg:0.4
  double getPlayingLineBias();

  ///ending is too ugly when it is smaller than half size
  ///true will at least offset to the position of bias0.5, which will not be smaller than 0.5
  ///false unlimited will offset to bias0.5
  bool halfSizeLimit() => getPlayingLineBias() < 0.5;

  ///Lyric alignment direction
  ///Support left center right alignment
  LyricAlign getLyricHorizontalAlign();

  LyricBaseLine getBiasBaseLine() => LyricBaseLine.CENTER;

  ///The centering method after a single row is fully paved
  TextAlign getLyricTextAligin() {
    switch (getLyricHorizontalAlign()) {
      case LyricAlign.LEFT:
        return TextAlign.left;
      case LyricAlign.RIGHT:
        return TextAlign.right;
      case LyricAlign.CENTER:
        return TextAlign.center;
    }
  }

  ///Enable row animation
  bool enableLineAnimation() => true;

  bool enableHighlight() => true;

  //init progress animation scroll to position
  bool initAnimation() => false;

  HighlightDirection getHighlightDirection() => HighlightDirection.LTR;

  Color getLyricHightlightColor() => Colors.green.shade900;

  @override
  String toString() {
    return '${getPlayingMainTextStyle()}'
        '${getPlayingExtTextStyle()}'
        '${getOtherMainTextStyle()}'
        '${getOtherExtTextStyle()}'
        '${getBlankLineHeight()}'
        '${getLineSpace()}'
        '${getInlineSpace()}'
        '${getPlayingLineBias()}'
        '${getLyricHorizontalAlign()}'
        '${getLyricTextAligin()}'
        '${getBiasBaseLine()}';
  }
}

///lyric align enum
enum LyricAlign { LEFT, CENTER, RIGHT }

enum HighlightDirection { LTR, RTL }

///lyric base line enum
enum LyricBaseLine { MAIN_CENTER, CENTER, EXT_CENTER }

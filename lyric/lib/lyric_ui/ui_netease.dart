import 'package:flutter/material.dart';

import 'lyric_ui.dart';

///Sample Netease style
///should be extends LyricUI implementation your own UI.
///this property only for change UI,if not demand just only overwrite methods.
class UINetease extends LyricUI {
  double defaultSize;
  double defaultExtSize;
  double otherMainSize;
  double bias;
  double lineGap;
  double inlineGap;
  LyricAlign lyricAlign;
  LyricBaseLine lyricBaseLine;
  bool highlight;
  HighlightDirection highlightDirection;
  TextStyle? playingMainTextStyle;
  TextStyle? otherMainTextStyle;
  Color? highLightTextColor;

  UINetease(
      {this.defaultSize = 18,
      this.defaultExtSize = 14,
      this.otherMainSize = 16,
      this.bias = 0.5,
      this.lineGap = 25,
      this.inlineGap = 25,
      this.lyricAlign = LyricAlign.CENTER,
      this.lyricBaseLine = LyricBaseLine.CENTER,
      this.highlight = true,
      this.highlightDirection = HighlightDirection.LTR,
      this.playingMainTextStyle,
      this.otherMainTextStyle,
      this.highLightTextColor,});

  UINetease.clone(UINetease uiNetease)
      : this(
          defaultSize: uiNetease.defaultSize,
          defaultExtSize: uiNetease.defaultExtSize,
          otherMainSize: uiNetease.otherMainSize,
          bias: uiNetease.bias,
          lineGap: uiNetease.lineGap,
          inlineGap: uiNetease.inlineGap,
          lyricAlign: uiNetease.lyricAlign,
          lyricBaseLine: uiNetease.lyricBaseLine,
          highlight: uiNetease.highlight,
          highlightDirection: uiNetease.highlightDirection,
          playingMainTextStyle: uiNetease.playingMainTextStyle,
          otherMainTextStyle: uiNetease.otherMainTextStyle,
          highLightTextColor: uiNetease.highLightTextColor,
        );

  @override
  TextStyle getPlayingExtTextStyle() =>
      TextStyle(color: Colors.green.shade500, fontSize: defaultExtSize);

  @override
  TextStyle getOtherExtTextStyle() => TextStyle(
        color: Colors.green,
        fontSize: defaultExtSize,
      );

  @override
  TextStyle getOtherMainTextStyle() => otherMainTextStyle ??
      TextStyle(color: Colors.green.shade200, fontSize: otherMainSize);

  @override
  TextStyle getPlayingMainTextStyle() => playingMainTextStyle ?? TextStyle(
        color: Colors.green.shade200,
        fontSize: defaultSize,
      );

  @override
  double getInlineSpace() => inlineGap;

  @override
  double getLineSpace() => lineGap;

  @override
  double getPlayingLineBias() => bias;

  @override
  LyricAlign getLyricHorizontalAlign() => lyricAlign;

  @override
  Color getLyricHightlightColor() => highLightTextColor ?? Colors.black;

  @override
  LyricBaseLine getBiasBaseLine() => lyricBaseLine;

  @override
  bool enableHighlight() => highlight;

  @override
  HighlightDirection getHighlightDirection() => highlightDirection;
}

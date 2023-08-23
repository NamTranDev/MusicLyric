import 'package:flutter/widgets.dart';
import 'package:musiclyric/screen/main/main_screen.dart';
import 'package:musiclyric/screen/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  MainScreen.routeName: (context) => MainScreen(),
};
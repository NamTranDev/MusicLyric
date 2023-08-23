import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:musiclyric/logger.dart';
import 'package:musiclyric/screen/main/main_screen.dart';
import 'package:musiclyric/services/player_manager.dart';
import 'package:musiclyric/services/service_locator.dart';
import 'package:musiclyric/storage/db_provider.dart';
import 'package:musiclyric/storage/preference.dart';
import 'package:path_provider/path_provider.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = '/splash';

  const SplashScreen({super.key});

  Future initialize() async {
    var playManager = getIt<PlayerManager>();

    if (playManager.isPlaying()) {
      return;
    }

    final pref = getIt<Preference>();

    bool isSyncFireStoragePathToDB = pref.isSyncFireStoragePathToDB();

    logger(isSyncFireStoragePathToDB);

    if (isSyncFireStoragePathToDB != true) {
      final db = getIt<DBProvider>();

      final jsonString = await rootBundle.loadString('assets/data.json');
      final dataJson = json.decode(jsonString) as List<dynamic>;

      await db.insertListSong(dataJson);

      clearCache();
    }

    getIt<PlayerManager>().loadSong();
  }

  Future<void> clearCache() async {
    DefaultCacheManager().emptyCache();
    _deleteCacheDir();
    _deleteAppDir();
  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        initialData: false,
        future: initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.pushNamedAndRemoveUntil(
                  context, MainScreen.routeName, (route) => false);
            });
          }
          return buildSplashScreen(context);
        },
      ),
    );
  }

  Widget buildSplashScreen(BuildContext context) {
    return Center(
      child: Text('This is Splash Screen'),
    );
  }
}

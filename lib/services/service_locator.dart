import 'package:audio_service/audio_service.dart';
import 'package:musiclyric/storage/preference.dart';
import '../../services/audio_handler.dart';
import '../storage/db_provider.dart';

import 'package:get_it/get_it.dart';
import '../../services/player_manager.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<DBProvider>(await initDBProvider());
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerSingleton<Preference>(await initPreference());
  getIt.registerLazySingleton<PlayerManager>(() => PlayerManager());
}

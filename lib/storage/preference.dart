// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:shared_preferences/shared_preferences.dart';

import '../logger.dart';

Future<Preference> initPreference() async {
  Preference pref = Preference._();
  pref._init();
  return pref;
}

class Preference {
  Preference._();

  final _KEY_FIRST_LOAD_DB = 'KEY_FIRST_LOAD_DB';

  SharedPreferences? _prefs;

  Future _init() async => _prefs = await SharedPreferences.getInstance();

  bool isSyncFireStoragePathToDB(){
    bool value = _prefs?.getBool(_KEY_FIRST_LOAD_DB) ?? false;
    _prefs?.setBool(_KEY_FIRST_LOAD_DB, true).whenComplete(() => {
      logger('isSyncFireStoragePathToDB Complete')
    });
    return value;
  }
}

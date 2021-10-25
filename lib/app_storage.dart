import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  static final AppStorage _instance = AppStorage._default();
  factory AppStorage(){
    return _instance;
  }

  AppStorage._default();
  SharedPreferences? _preferences;

  init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  List<String> get allHistory{
    List<String> prev = [];
    try {
      prev = _preferences!.getStringList('results')?? [];
    } catch (e) {
      print("========********Error: =");
      print(e);
    }
    return prev;
  }

  Future updateHistory(List<String> recordings){
    return _preferences!.setStringList('results', recordings);
  }
}
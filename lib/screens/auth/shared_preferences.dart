import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {

  //Add values to shared preferences
  static void addStringToSF(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print('Value added to shared preferences-> $key , $value');
  }
  static void addIntToSF(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }
  static void addDoubleToSF(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }
  static void addBoolToSF(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }


  //Read values from shared preferences
  static Future<String> getStringValueSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString(key) ?? 'null';
    return stringValue;
  }
  static Future<int> getIntValueSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return int
    int intValue = prefs.getInt(key) ?? 0;
    return intValue;
  }
  static Future<double> getDoubleValueSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    double doubleValue = prefs.getDouble(key) ?? 0.00;
    return doubleValue;
  }
  static Future<bool> getBoolValueSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool(key) ?? false;
    return boolValue;
  }

  //Check if value exits
  static Future<bool> checkIfKeyExists(String key) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkValue = prefs.containsKey(key);
    return checkValue;
  }

  //Remove value
  static removeValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);

  }
}
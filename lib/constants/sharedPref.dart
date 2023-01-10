import 'package:shared_preferences/shared_preferences.dart';
import '../model/signIn.dart';


class SharedPref{

  Future<String?> getSharedPref(dynamic retrieveString) async {
    final pref = await SharedPreferences.getInstance();
    String? prefs = pref.getString(retrieveString);
    return prefs;
  }

  setSharedPref(dynamic key, dynamic value) async{
    final pref = await SharedPreferences.getInstance();
    pref.setString(key, value);
  }

  removeSharedPref(dynamic key) async{
    final pref = await SharedPreferences.getInstance();
    pref.remove(key);
  }
}


class UserPreferences{
  saveUser(SignInUser user) async{
    SharedPref().setSharedPref('username', user.username);
    SharedPref().setSharedPref('role', user.role);
    var id = await SharedPref().getSharedPref('username');
    //var userId = await sharedPref().getSharedPref('userId');
    print(id);
  }

  deleteUser(){
    SharedPref().removeSharedPref('username');
  }
}
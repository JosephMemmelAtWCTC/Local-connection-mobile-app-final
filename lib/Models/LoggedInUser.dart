import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:local_connection_first/Models/User.dart';
import 'package:local_connection_first/helpers/NetworkRequestsHelper.dart';

class LoggedInUser {

  String? username;
  String? profileImage;
  String? accessToken;
  String? refreshToken;
  int? expiresIn;

  bool isLoggedIn = false;
  bool stayLoggedIn = true;

  login(String username, String password) async {
    Response response = await NetworkRequestsHelper.postData("https://localconnectionsapi.azurewebsites.net/identity/login", bodyJson: {
      "email": username,
      "password": password
    });
    final responseData = jsonDecode(response.body);
    if(response.statusCode == 200 || response.statusCode == 201){
      this.username = username;
      isLoggedIn = true;
      accessToken = responseData["accessToken"];
      expiresIn = responseData["expiresIn"];
      refreshToken = responseData["refreshToken"];

      profileImage = User(username).profileImgPath;
      stayLoggedIn = true;
      return true;
    }else{
      return false;
    }

  }

  scheduleLoginRefresh() async {
    if(stayLoggedIn){
      Response response = await NetworkRequestsHelper.postData("https://localconnectionsapi.azurewebsites.net/identity/refresh", bodyJson: {
        "refreshToken": refreshToken,
      });
      final responseData = jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        accessToken = responseData["accessToken"];
        expiresIn = responseData["expiresIn"];
        refreshToken = responseData["refreshToken"];

        Timer(new Duration(seconds: expiresIn!-60), scheduleLoginRefresh);
      }else{
        logout();
      }
    }

  }

  logout(){
    isLoggedIn = false;
    stayLoggedIn = false;

    username = null;
    profileImage = null;
    accessToken = null;
    refreshToken = null;
    expiresIn = null;
  }
}
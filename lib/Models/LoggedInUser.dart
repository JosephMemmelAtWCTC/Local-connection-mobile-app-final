import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

  login(String username, String password) async {
    Response response = await NetworkRequestsHelper.postData("http://localhost:5177/identity/login", bodyJson: {
      "email": username,
      "password": password
    });
    final responseData = jsonDecode(response.body);
    if(response.statusCode == 200 || response.statusCode == 201){
      this.username = username;
      this.isLoggedIn = true;
      this.accessToken = responseData["accessToken"];
      this.expiresIn = responseData["expiresIn"];
      this.refreshToken = responseData["refreshToken"];

      this.profileImage = User(username).profileImgPath;
      return true;
    }else{
      return false;
    }

  }

  logout(){
    isLoggedIn = false;
    username = null;
    profileImage = null;
    accessToken = null;
    refreshToken = null;
    expiresIn = null;
  }
}
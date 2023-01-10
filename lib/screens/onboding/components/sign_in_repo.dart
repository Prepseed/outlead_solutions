import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../constants/sharedPref.dart';
import '../../../constants/toast_message.dart';
import '../../../constants/urls.dart';
import '../../../model/failure.dart';
import '../../../model/signIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/exception/customException.dart';

class SignInRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<Either<Failure, SignInUser>> fetchClientList(body) async {
    var response = await _helper.post(ApiUrls.signIn, body);

      if(response.runtimeType != int){
        var xpVal = response["user"]["xp"]["net"].toString();
        var streakVal = response["user"]["xp"]["streak"]["day"].toString();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('name',response["user"]["name"]);
        prefs.setString('username',response["user"]["username"]);
        // sharedPref().setSharedPref('token', response['token']);
        SharedPref().setSharedPref('token', response['token']);
        // sharedPref().setSharedPref('username', response['user']['username']);
        SharedPref().setSharedPref('username', response['user']['username']);
        // sharedPref().setSharedPref('phaseId', response['user']["subscriptions"][0]["subgroups"][0]["phases"][0]["phase"]["_id"]);
        SharedPref().setSharedPref('phaseId', response['user']["subscriptions"][0]["subgroups"][0]["phases"][0]["phase"]["_id"]);
        SharedPref().setSharedPref('stats', json.encode(response['user']['stats']));
        SharedPref().setSharedPref('subscriptions', json.encode(response['user']['subscriptions']));
        SharedPref().setSharedPref('topics', json.encode(response['topics']));

        SharedPref().setSharedPref('name',response["user"]["name"]);
        SharedPref().setSharedPref('username',response["user"]["username"]);
        SharedPref().setSharedPref('userId',response["user"]["_id"]);
        // sharedPref().setSharedPref('userId',response["user"]["_id"]);
        SharedPref().setSharedPref('role',response["user"]["role"]);
        // sharedPref().setSharedPref('role',response["user"]["role"]);
        SharedPref().setSharedPref('email',response["user"]["email"]);
        SharedPref().setSharedPref('xp',xpVal);
        SharedPref().setSharedPref('streak',streakVal);

        if(response["user"]["dp"] != null)
          SharedPref().setSharedPref('dp',response["user"]["dp"]);
        SharedPref().setSharedPref('mobileNumber',response["user"]["mobileNumber"]);

        // flutterToastMessage("Successfully Logged In");
        return Right(SignInUser.fromJson(response['user']));
      }

      return Left(Failure(response.statusCode.toString()));



    // Navigator.pushReplacementNamed(navigatorKey.currentState!.context, '/yourPref');

  }
}
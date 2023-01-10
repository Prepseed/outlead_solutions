import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/sharedPref.dart';
import '../../../model/failure.dart';
import '../../../model/signIn.dart';
import 'sign_in_repo.dart';

class SignInProvider extends ChangeNotifier{
  final _loginRepository = SignInRepository();
  bool isLoading = false;
  SignInUser _user = SignInUser();
  SignInUser get clients => _user;


  Future<SignInUser> grantAccess(body) async {
    isLoading = true;
    notifyListeners();

    var response = await _loginRepository.fetchClientList(body);
    print(response);

    response.fold((failure) => failure.toString(), (list) {
      _user = list;
      UserPreferences().saveUser(_user);
    });


    notifyListeners();
    return Future.value(_user);

  }
}
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../constants/sharedPref.dart';
import '../../constants/toast_message.dart';
import 'app_exception.dart';

class ApiBaseHelper {

  Future<dynamic> get(String url) async {
    var token = await SharedPref().getSharedPref('token');
    print('Api Get, url $url');
    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'authorization': 'Bearer $token',
    };
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url),headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api get recieved!');
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body) async {
    var token = await SharedPref().getSharedPref('token');
    print('Api Post, url $url');
    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'authorization': 'Bearer $token',
    };
    var responseJson;
    try {
      final response = await http.post(Uri.parse(url),
          headers: headers,
          body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api post.');
    return responseJson;
  }

  Future<dynamic> patch(String url, dynamic body) async {
    var token = await SharedPref().getSharedPref('token');
    print('Api Patch, url $url');
    Map<String,String> headers = {
      'Content-type' : 'application/json',
      'authorization': 'Bearer $token',
    };
    var responseJson;
    try {
      final response = await http.patch(Uri.parse(url),
          headers: headers,
          body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api patch.');
    return responseJson;
  }

  Future<dynamic> put(String url) async {
    var token =  await SharedPref().getSharedPref('token');
    var headers =  {
      'Content-type' : 'application/json',
      'authorization': 'Bearer $token',
    };
    print('Api Put, url $url');
    var responseJson;
    try {
      final response = await http.put(Uri.parse(url),headers: headers);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api put.');
    print(responseJson.toString());
    return responseJson;
  }

/*  Future<dynamic> put(String url, dynamic body) async {
    print('Api Put, url $url');
    var responseJson;
    try {
      final response = await http.put(Uri.parse(_baseUrl + url), body: body);
      responseJson = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api put.');
    print(responseJson.toString());
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    print('Api delete, url $url');
    var apiResponse;
    try {
      final response = await http.delete(Uri.parse(_baseUrl + url));
      apiResponse = _returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api delete.');
    return apiResponse;
  }*/
}

dynamic _returnResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      var responseJson;
      try {
        responseJson = json.decode(response.body.toString());
      } on FormatException catch (e) {
        responseJson = response.body.toString();
      }
      // var responseJson = json.decode(response.body.toString());
      print(responseJson);
      return responseJson;
    case 400:
      flutterToastMessage(json.decode(response.body)["error"]['message'] ?? "Something went wrong....");
      return response.statusCode;
      /* Fluttertoast.showToast(
          msg: json.decode(response.body)["error"]['message'] ?? "Something went wrong....",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );*/
      throw BadRequestException(response.body.toString());
    case 401:
    case 403:
      throw UnauthorisedException(response.body.toString());
    case 500:
    default:
      flutterToastMessage("Error occurred while Communication with Server with StatusCode : ${response.statusCode}");
      /*  Fluttertoast.showToast(
        msg: "Error occured while Communication with Server with StatusCode : ${response.statusCode}')",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );*/
      throw FetchDataException(
          'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
  }
}
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qaudit_tata_flutter/utils/app_modal.dart';
import 'package:toast/toast.dart';
//import '../view/login_screen.dart';
import '../view/login_screen.dart';
import 'app_exceptions.dart';
import 'constants.dart';

class ApiBaseHelper {
  final String _baseUrl = AppConstant.appBaseURL;
  final String _baseUrl1 = AppConstant.langURL;
  Future<dynamic> get(String url, BuildContext context) async {
    var responseJson;
    print(_baseUrl+url+'  API CALLED');
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'X-Requested-With':'XMLHttpRequest'
      });
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> getWithToken(String url, BuildContext context) async {
    var responseJson;
    print(_baseUrl+url+'  API CALLED');
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'X-Requested-With':'XMLHttpRequest',
        'Authorization':"Bearer "+AppModel.token
      });
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);
      if(decodedJson["message"]=="Failed to authenticate token." || decodedJson["message"]=="Your session has timed out! Please login again!")
      {
        _logOut(context);
      }
      else
      {
        responseJson = _returnResponse(response, context);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> getWithHeader(String url, var apiParams, BuildContext context) async {
    print(_baseUrl+url+'  API CALLED');
    print(AppModel.token);
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'X-Requested-With':'XMLHttpRequest',
        //'Authorization':"Bearer "+AppModel.token
        'Authorizations':AppModel.token
      });
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);
      if(decodedJson["message"]=="User not found" || decodedJson["message"]=="Your session has timed out! Please login again!")
      {
        _logOut(context);
      }
      else
      {
        responseJson = _returnResponse(response, context);
      }
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> postAPI(
      String url, var apiParams, BuildContext context) async {
    print(_baseUrl+url+'  API CALLED');
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest'
          }
          );
      print("HTML Response");
      log(response.toString());
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> newPostAPI(
      String url, var apiParams, BuildContext context) async {
    print(_baseUrl1+url+'  API CALLED');
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl1 + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest'
          }
      );
      print("HTML Response");
      log(response.toString());
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> postAPIWithHeader22(
      String url, var apiParams, BuildContext context) async {
    print(AppConstant.webURL+url+'  API CALLED');
    print("Token");
    print(AppModel.token);
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(AppConstant.webURL + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest',
            'X-Csrf-Token':"8mv0vEG7LmD3QKie1dT5mXbKiQPMvU2JTx4liZTT"
            /*'Authorizations':AppModel.token.toString()*/
          }
      );
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      if(decodedJson["message"]=="User not found" || decodedJson["message"]=="Your session has timed out! Please login again!")
      {
        _logOut(context);
      }
      else
      {
        responseJson = _returnResponse(response, context);
      }

    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> postAPIWithHeader(
      String url, var apiParams, BuildContext context) async {
    print(_baseUrl+url+'  API CALLED');
    print("Token");
    print(AppModel.token);
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(_baseUrl + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest',
            'Authorizations':AppModel.token.toString()
          }
      );
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      if(decodedJson["message"]=="User not found" || decodedJson["message"]=="Your session has timed out! Please login again!")
        {
          _logOut(context);

        }
      else
        {

          log("hjghgff");
          log(response.body.toString());
          responseJson = _returnResponse(response, context);
        }

    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  dynamic _returnResponse(http.Response response, BuildContext context) {
    var responseJson = jsonDecode(response.body.toString());
    print(response.statusCode.toString() +'Status Code******* ');
    log(responseJson.toString());

   // log('api helper response $response');
    switch (response.statusCode) {
      case 200:
        log(response.body.toString());
        return response;
      case 302:
        print(response.body.toString());
        return response;
      case 201:
        print(response.body.toString());
        return response;
      case 400:
        print(response.body.toString());
        return response;
      case 401:
        Toast.show('Unauthorized User!!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        throw BadRequestException(response.body.toString());
        break;
      case 403:
        Toast.show('Internal server error !!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        throw UnauthorisedException(response.body.toString());
      case 500:
        print(response.body.toString());
        return response;
        break;
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
  _logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Toast.show('Your session has expired, Please login to continue!',
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.blue);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }
}

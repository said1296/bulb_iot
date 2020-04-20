import 'package:http/http.dart';
import 'dart:async';
import 'utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../globals.dart' as globals;

class LevelRepository {
  String _url = globals.DOMAIN_NAME+'status/';
  final storage = FlutterSecureStorage();

  Future<bool> postLevel(level, isChanging) async {
    Response response;
    try{
      Headers _headers=Headers(globals.COOKIES_PATH);
      await _headers.setCsrf();
      String authToken = await storage.read(key: 'authToken');
      Map<String, dynamic> payload = {"level": level, "isChanging": isChanging, "Authorization": authToken.toString()};
      response = await post(_url,
          headers: _headers.headers, body: jsonEncode(payload)); // check the status code for the result 
    }catch(e){
      return null;
    }
    if (response.statusCode == 201) {
      return true;
    } else if(response.statusCode == 401) {
      return false;
    }
    return null;
  }

  getState() async {
    final storage = FlutterSecureStorage();
    Response response;
    try{
      Headers _headers = Headers(globals.COOKIES_PATH);
      await _headers.setCsrf();

      String authToken = await storage.read(key: 'authToken');
      if(authToken==null){
        return null;
      }
      String _urlGet=_url+'get/';
      response = await post(_urlGet, headers: _headers.headers, body: jsonEncode({'Authorization': authToken}));
    }catch(e){
      return null;
    }

    if(response.statusCode==201){
      return jsonDecode(response.body)['level'].toDouble();
    }else if(response.statusCode==401){
      return null;
    }
  }
}
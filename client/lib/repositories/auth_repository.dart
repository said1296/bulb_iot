import 'package:http/http.dart';
import 'utils.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../globals.dart' as globals;

class AuthRepository{
  login(username, password) async {
    Map<String, dynamic> body;
    String error;
    String authToken;
    final storage = FlutterSecureStorage();
    String _url = globals.DOMAIN_NAME+'auth/';
    Map<String, String> credentials={"username": username, "password": password};
    Response response;
    
    try{
      Headers _headers = Headers(globals.COOKIES_PATH);
      await _headers.setCsrf();

      response = await post(_url+'login/',
          headers: _headers.headers, body: jsonEncode(credentials));
    }catch(e){
      return "Couldn't connect to server";
    }

    body=jsonDecode(response.body);
    error=body['error'];

    if(error==''){
      authToken=body['authToken'];
      await storage.write(key: 'authToken', value: authToken);
    }

    return error;
  }

  static auth() async {
    String _url = globals.DOMAIN_NAME+'auth/login/';
    Headers _headers;
    try{
      _headers = Headers(globals.COOKIES_PATH);
      await _headers.setCsrf();
    }catch(e){
      throw(e);
    }
    final storage = FlutterSecureStorage();
    String authToken = await storage.read(key: 'authToken');
    if(authToken==null){
      return false;
    }else{
      _url = globals.DOMAIN_NAME+'auth/';
      Map <String, String> credentials = {'Authorization': authToken};
      try{
        Response response = await post(_url, headers: _headers.headers, body: jsonEncode(credentials));
        return jsonDecode(response.body)['isAuth'];
      }catch(e){
        throw e;
      }
    }
  }
}
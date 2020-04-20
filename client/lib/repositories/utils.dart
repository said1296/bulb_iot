import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Headers{
  Map<String, String> headers = {"Content-type": "application/json"};
  String url;
  Response response;
  final storage = FlutterSecureStorage();

  Headers(this.url);

  setCookies() async {
    try{
      response = await get (url);
    }catch(e){
      throw(e);
    }
    headers['cookie'] = response.headers['set-cookie'];
  }
  setCsrf()async{
    Map<String, String> allStorage= await storage.readAll();
    if(allStorage.containsKey('csrfExp') && allStorage.containsKey('cookies') && allStorage.containsKey('csrfToken')){
      String expString=allStorage['csrfExp'];
      DateTime expDate=DateTime.parse(expString);
      if(expDate.isAfter(DateTime.now())){
        String cookies=allStorage['cookies'];
        String csrfToken=allStorage['csrfToken'];
        headers['cookie']=cookies;
        headers['x-csrftoken']=csrfToken;
        return;
      }
    }
    try{
      await setCookies();
    }catch(e){
      throw(e);
    }
    List<String> cookies = response.headers['set-cookie'].split("=");
    var _tokenIndex = cookies.indexOf('csrftoken')+1;
    String csrfToken = cookies[_tokenIndex].split(";")[0];
    int maxAge = int.parse(cookies[_tokenIndex+2].split(";")[0]);
    DateTime expDate=DateTime.now().add(Duration(milliseconds: maxAge));
    await storage.write(key: 'cookies', value: response.headers['set-cookie']);
    await storage.write(key: 'csrfExp', value: expDate.toString());
    await storage.write(key: 'csrfToken', value: csrfToken);
    headers['cookie']=response.headers['set-cookie'];
    headers['x-csrftoken'] = csrfToken;
  }
}
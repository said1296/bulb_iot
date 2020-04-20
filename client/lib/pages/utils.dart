import '../repositories/auth_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

isAuth() async {
  try{
    bool isValid = await AuthRepository.auth();
    return isValid;
  }catch(e){
    return false;
  }
}

logout() async {
  final storage = FlutterSecureStorage();
  await storage.deleteAll();
}
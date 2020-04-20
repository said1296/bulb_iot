import 'dart:async';
import '../repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class AuthBloc{
  AuthRepository _authRepository = AuthRepository();

  final _stateController = StreamController<AuthState>();
  StreamSink<AuthState> get _in => _stateController.sink;
  Stream<AuthState> get out => _stateController.stream;

  final _eventController = StreamController<AuthEvent>();
  Sink<AuthEvent> get event => _eventController.sink;

  AuthBloc(){
    _eventController.stream.listen(_eventToState);
  }

  void _eventToState(AuthEvent event)async{
    if(event is LoginEvent){
      String error = await _authRepository.login(event.username, event.password);
      if(error==''){
        _in.add(LoginSuccess(event.successColor));
      }else{
        _in.add(LoginFail(error, event.errorColor));
      }
    }
    if(event is RedirectingEvent){
      _in.add(Redirecting(event.successColor));
    }
  }

  void dispose(){
    _stateController.close();
    _eventController.close();
  }
}

//States
abstract class AuthState {}

class NotAuthenticated extends AuthState {}

class Authenticated extends AuthState {}

class LoginWaiting extends AuthState {
  final Color color;
  final String error='';
  LoginWaiting(this.color);
}

class LoginFail extends AuthState {
  final String error;
  final Color color;
  LoginFail(this.error, this.color);
}

class Redirecting extends AuthState{
  String error='';
  final Color color;
  Redirecting(this.color);
}

class LoginSuccess extends AuthState {
  final Color color;
  final String error='';
  LoginSuccess(this.color);
}

//Events
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;
  final Color errorColor;
  final Color successColor;

  LoginEvent(this.username, this.password, this.successColor, this.errorColor);
}

class RedirectingEvent extends AuthEvent {
  final Color successColor;

  RedirectingEvent(this.successColor);
}

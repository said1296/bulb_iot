import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blocs/auth_bloc.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _authBloc=AuthBloc();
  final focusPassword = FocusNode();
  String username;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return StreamBuilder(
      stream: _authBloc.out,
      initialData: LoginWaiting(Theme.of(context).accentColor),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.data is LoginSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed("/", arguments: true);
          _authBloc.event.add(RedirectingEvent(Theme.of(context).focusColor));
        });
        }
        return Scaffold(
          backgroundColor: Theme.of(context).primaryColorDark,
          body: ListView(
            children: [
              Container(
                height: height*0.6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Theme.of(context).primaryColorLight, Theme.of(context).buttonColor,
                    ]
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.all(height*0.3*0.2),
                    child: Text(
                      "LOGIN",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(width*0.1, height*0.05, width*0.1, height*0.025),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8.0,
                      color: snapshot.data.color,
                    )
                  ]
                ),
                child: TextFormField(
                  onFieldSubmitted: (_username){
                    username=_username;
                    FocusScope.of(context).requestFocus(focusPassword);
                    },
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'User',
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    prefixIcon: Icon(Icons.alternate_email, color: Theme.of(context).primaryColor),
                  ),
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return value.contains('@') ? 'Do not use the @ char.' : null;
                  },
                )
              ),
              Container(
                margin: EdgeInsets.fromLTRB(width*0.1, 0, width*0.1, height*0.025),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8.0,
                      color: snapshot.data.color,
                    )
                  ]
                ),
                child: TextFormField(
                  obscureText: true,
                  focusNode: focusPassword,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                    prefixIcon: Icon(Icons.vpn_key, color: Theme.of(context).primaryColor),
                  ),
                  onFieldSubmitted: (String password) {
                    _authBloc.event.add(LoginEvent(username, password, Theme.of(context).focusColor, Theme.of(context).errorColor));
                  },
                  validator: (String value) {
                    return value.contains('@') ? 'Do not use the @ char.' : null;
                  },
                )
              ),
              Center(
                child: Text(snapshot.data.error,
                  style: TextStyle(
                    color: snapshot.data.color,
                    fontSize: 20,
                  )
                )
              ),
            ]
          )
        );
      }
    );
  }
}
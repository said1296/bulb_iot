import 'package:flutter/material.dart';
import 'pages/control.dart';
import 'pages/login.dart';
import 'pages/utils.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  isAuth().then((isValid) {
    runApp(MyApp(isValid));
  });
}

class MyApp extends StatelessWidget {
  bool isValid;
  Router router;
  MyApp(this.isValid){
    router=Router(isValid);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColorDark: Colors.blueGrey[900],
        primaryColorLight: Colors.blueGrey[600],
        primaryColor: Colors.blueGrey[800],
        errorColor: Colors.red[400],
        focusColor: Colors.green,
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 40,
            color: Colors.grey[50],
          )
        ),
        accentColor: Colors.lime[100],
        hintColor: Colors.blueGrey[800].withOpacity(0.3),
      ),
      initialRoute: '/',
      onGenerateRoute: router.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Router{
  bool isValid;

  Router(this.isValid);
  Route<dynamic> generateRoute(RouteSettings settings) {
    if(settings.arguments==true){
      isValid=true;
    }else if(settings.arguments==false){
      isValid=false;
    }

    switch (settings.name) {
      case '/':
        return _reroute(MaterialPageRoute(builder: (_) => Control()));
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}')
            ),
          )
        );
    }
  }

  _reroute(route){
    if(isValid){
      return route;
    }else{
      return MaterialPageRoute(builder: (_) => Login());
    }
  }
}
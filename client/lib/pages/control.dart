import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../blocs/level_bloc.dart';
import 'utils.dart';

class Control extends StatefulWidget {
  Control({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ControlState createState() => _ControlState();
}

class _ControlState extends State<Control> {
  final _levelBloc=LevelBloc();
  Stopwatch timer = Stopwatch();
  bool auth;

  _ControlState() {
    timer.start();
  }

  void handleClick(String value) {
      switch (value) {
        case 'Logout':
          logout();
          Navigator.pushNamedAndRemoveUntil(context, "/login", (r) => false, arguments: false);
          break;
        case 'Settings':
          break;
      }
  }
  

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return StreamBuilder(
      stream: _levelBloc.out,
      initialData: LevelState(0, false, true),
      builder: (BuildContext context, AsyncSnapshot snapshot){
      if(snapshot.data.auth == false || auth==false){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
      return Scaffold(
        appBar: AppBar(
          title: Text("Control light"),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              itemBuilder: (BuildContext context) {
                return {'Logout', 'Settings'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }
              ).toList();
            },
          ),
        ],
          backgroundColor: Colors.blueGrey[900 - (((snapshot.data.level / 10) * 8).round() * 100)],
        ),
        body: CustomPaint(
          painter: _BackgroundPainter(snapshot.data.level),
          child: Center(
                child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(width * 0.3, 0, 0, height * 0.1),
                      child: Slider.adaptive(
                        value: snapshot.data.level,
                        onChanged: (_newLevel) async {
                          _levelBloc.event.add(SliderChange(_newLevel));
                        },
                        onChangeEnd: (_newLevel) async {
                          _levelBloc.event.add(SliderFinal(_newLevel));
                        },
                        min: 0,
                        max: 10,
                        activeColor: Colors.cyan,
                        inactiveColor: Colors.grey[300],
                      ),
                    )
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding:
                            EdgeInsets.fromLTRB(width * 0.1, 0, 0, height * 0.01),
                        child: Switch(
                            value: snapshot.data.isOn,
                            onChanged: (switchBool) {
                              if(switchBool){
                                _levelBloc.event.add(SwitchOn());
                              }else{
                                _levelBloc.event.add(SwitchOff());
                              }
                            },
                            activeTrackColor: Colors.cyan,
                            inactiveTrackColor: Colors.grey[300],
                            activeColor: Colors.grey[300],
                          )
                      ),
                    ),
                  ),
                ],
              )
            )
          ),
        );
      }
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  double _level;
  int _shade;

  _BackgroundPainter(this._level);

  @override
  void paint(Canvas canvas, Size size) {
    _shade = 900 - (((_level / 10) * 8).round() * 100);
    Paint paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    paint.color = Colors.blueGrey[_shade];
    canvas.drawPath(mainBackground, paint);

    Path bulbPath = Path();
    bulbPath.moveTo(0, size.height * 0.2);
    bulbPath.quadraticBezierTo(size.width * 0.45, size.height * 0.25,
        size.width * 0.5, size.height * 0.5);
    bulbPath.quadraticBezierTo(
        size.width * 0.58, size.height * 0.8, size.width * 0.1, size.height);
    bulbPath.lineTo(0, size.height);
    bulbPath.close();

    paint.color = Colors.lime[_shade];
    canvas.drawPath(bulbPath, paint);
    canvas.drawShadow(bulbPath, Colors.yellow[_shade], 10.0, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
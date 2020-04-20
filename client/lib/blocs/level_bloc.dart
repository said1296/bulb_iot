import 'dart:async';

import '../repositories/level_repository.dart';

class LevelBloc{
  Stopwatch timer = Stopwatch();
  LevelRepository levelRepository = LevelRepository();
  bool isAuth=true;
  bool isOn=false;
  double level=0;
  bool isChanging;
  dynamic response=true;

  final _stateController = StreamController<LevelState>();
  StreamSink<LevelState> get _in => _stateController.sink;
  Stream<LevelState> get out => _stateController.stream;

  final _eventController = StreamController<LevelEvent>();
  Sink<LevelEvent> get event => _eventController.sink;

  LevelBloc(){
    _eventController.stream.listen(_mapEventToState);
    timer.start();

    event.add(GetState());
  }

  void _mapEventToState(LevelEvent event) async {
    if(event is SliderFinal || event is SwitchOn || event is SwitchOff){
      isChanging=false;
    }else{
      isChanging=true;
    }
    
    if(isChanging==false || (timer.elapsedMilliseconds>200  && event is GetState == false )){
      timer.reset();
      response = await levelRepository.postLevel(level, isChanging);
      if(response==false || response==null){
        isAuth=false;
      }else{
        isAuth=true;
      }
    }

    if(isAuth==true){
      if(event is SliderChange){
        level = event.level;
      }else if(event is SliderFinal){
        level=event.level;
      }else if(event is SwitchOff){
        level=event.level;
      }else if(event is SwitchOn){
        level=event.level;
      }else if(event is GetState){
        response = await levelRepository.getState();
        if(response==401 || response==null){
          isAuth=false;
        }else{
          level = response;
          isAuth=true;
        }
      }
      if(level==0){
        isOn=false;
      }else{
        isOn=true;
      }
    }

    _in.add(LevelState(level, isOn, isAuth));
  }

  void dispose(){
    _stateController.close();
    _eventController.close();
  }
}

class LevelState {
  double level;
  bool isOn;
  bool auth;

  LevelState(this.level, this.isOn, this.auth);
}

abstract class LevelEvent {
}

class SliderFinal extends LevelEvent {
  double level;
  SliderFinal(this.level);
}

class SliderChange extends LevelEvent {
  double level;
  SliderChange(this.level);
}

class SwitchOn extends LevelEvent {
  final double level=5;
}

class SwitchOff extends LevelEvent {
  final double level=0;
}

class GetState extends LevelEvent {}
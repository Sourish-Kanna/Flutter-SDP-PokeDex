import 'package:flutter/material.dart';
import 'package:pokemon/home_screen.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(Pokedex());
}

class Pokedex extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}
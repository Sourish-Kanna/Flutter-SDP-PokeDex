import 'package:flutter/material.dart';
import 'package:pokemon/home_screen.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;


void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const Pokedex());
}

class Pokedex extends StatelessWidget{
  const Pokedex({super.key});

  @override
  Widget build(BuildContext context){
      return const MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      );
  }
}
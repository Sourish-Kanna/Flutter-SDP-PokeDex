import 'package:flutter/material.dart';
import 'package:pokemon/home_screen.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:connectivity_plus/connectivity_plus.dart';

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
    // if (!await hasInternetConnection()) {
    // // Handle no internet case
    // print('No internet connection');
    // // Show a user-friendly message or handle it accordingly
    // // return;
    // }
    // else{
      return const MaterialApp(
        home: HomeScreen(),
      );
  //   }
  }

  Future<bool> hasInternetConnection() async {
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      return connectivityResult != ConnectivityResult.none;

    } on Exception catch (e) {
      print(11);
      print(e.toString());
      return false;
    }
  }
}
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:pokedex/pokedex.dart';

void main() {
    runApp(Welcome());
}

class Welcome extends StatelessWidget {
  const Welcome({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Welcome Text app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
          useMaterial3: true
        ),
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.cyan,
            title: const Text('Welcome to Our App'),
          ),
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowInfo()
              ],
            ),
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: _fetchData(),
          //   tooltip: 'Increment',
          //   child: const Icon(Icons.add),
          // ),
        )
    );
  }
}

String prettyJson(dynamic json) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(json);
}

class ShowInfo extends StatefulWidget {
  const ShowInfo({Key? key}) : super(key: key);

  @override
  _ShowInfoState createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {
  String name = "hi";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final pokedex = Pokedex();
    pokedex.pokemon.getAll().then((response) {
      setState(() {
        name = response.results.first.name;
        print(prettyJson(response));
      });
    });
    // final response = await pokedex.evolutionChains.get(10);
    // setState(() {
    //   name = response.chain.evolvesTo.first.species.name;
    //   print(prettyJson(response));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Center(
        child: Text(
          name,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

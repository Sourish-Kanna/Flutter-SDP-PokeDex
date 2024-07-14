import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon/pokemon_detail_screen.dart';
import 'package:pokedex/pokedex.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> pokedex = [];
  // late List pokedex;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchPokemonData();
    }
  }

  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -150,
            child: Image.asset(
              'images/pokeball.png', width: 400, fit: BoxFit.fitWidth,),
          ),
          Positioned(
              top: 100,
              left: 20,
              child: Text("Pokedex",
                style: TextStyle(fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),)
          ),
          Positioned(
            top: 150,
            bottom: 0,
            width: width,
            child: Column(
              children: [
                pokedex != null ? Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.4,
                      ),
                      itemCount: pokedex.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future: getPokemonWidget(index),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return snapshot.data!;
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        );
                      },
                    )
                ) : Center(
                  child: CircularProgressIndicator(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void fetchPokemonData() {
    Pokedex().pokemon.getPage(limit: 2).then((response) {
    // Pokedex().pokemon.getAll().then((response) {
      pokedex = response.results;
      // Pokedex().pokemon.get(name: response.results.first.name).then((response) {
      //     print(prettyJson(response.types.first.type.name));
      //     print(response.sprites.frontDefault);
      //   });
      setState(() {});
    });
  }

  String prettyJson(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  Color getColorByType(String? type) {
    switch (type) {
      case 'Grass':
        return Colors.greenAccent;
      case 'Fire':
        return Colors.redAccent;
      case 'Water':
        return Colors.blue;
      case 'Electric':
        return Colors.yellow;
      case 'Rock':
        return Colors.grey;
      case 'Ground':
        return Colors.brown;
      case 'Psychic':
        return Colors.indigo;
      case 'Fighting':
        return Colors.orange;
      case 'Bug':
        return Colors.lightGreenAccent;
      case 'Ghost':
        return Colors.deepPurple;
      case 'Normal':
        return Colors.blueGrey;
      case 'Poison':
        return Colors.deepPurpleAccent;
      default:
        return Colors.pinkAccent;
    }
  }

  // Future<dynamic> PokeDetail(List<dynamic> pokedex, int index) async {
  //   Pokedex().pokemon.get(name: pokedex[index].name).then((response) {
  //     print(prettyJson(response.types[0].type.name));
  //     return(response);
  //   });
  // }

  Future<Widget> getPokemonWidget(int index) async {
    var pokemonData = await fetchPokemonDetail(index);
    return buildPokemonWidget(pokemonData);
  }

  Future<dynamic> fetchPokemonDetail(int index) async {
    var pokemonName = pokedex[index].name;
    var response = await Pokedex().pokemon.get(name: pokemonName);
    return response;
  }

  Widget buildPokemonWidget(dynamic pokemonData) {
    // Extract necessary data from pokemonData and return the Widget
    var type = pokemonData.types[0].type.name;
    print(pokemonData);
    return InkWell(
        child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                // color: getColorByType(type),
                color: getColorByType(type),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Positioned(
                      bottom: -5,
                      right: -37,
                      child: Image.asset(
                          'images/pokeball.png',
                          height: 110,
                          fit: BoxFit.fitHeight)
                  ),
                  Positioned(
                      bottom: -5,
                      right: -37,
                      child: Image.asset(
                          'images/pokeball.png',
                          height: 110,
                          fit: BoxFit.fitHeight)
                  )
                ],
              ),
            )
        )
    );
  }

}

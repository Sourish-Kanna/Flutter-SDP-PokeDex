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

  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchPokemonData();
    }
  }

  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;
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
                pokedex != null ? Expanded(child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                  ), itemCount: pokedex.length,
                  itemBuilder: (context, index) {
                    var type = fetch_primary_type(pokedex, context, index).toString();
                    var img = fetch_image(pokedex, context, index).toString();
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: getColorByType(type),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                  bottom: -10,
                                  right: -50,
                                  child: Image.asset('images/pokeball.png',
                                    height: 100,
                                    fit: BoxFit.fitHeight,)),
                              Positioned(
                                top: 20,
                                left: 10,
                                child: Text(
                                  pokedex[index]['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 45,
                                left: 20,
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0,
                                        right: 8.0,
                                        top: 4,
                                        bottom: 4),
                                    child: Text(
                                      type.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20)),
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Hero(
                                  tag: index,
                                  child: CachedNetworkImage(
                                    imageUrl: img,
                                    errorWidget: (context, url, error) => Icon(Icons.error), // Handle image load errors
                                    height: 100,
                                    fit: BoxFit.fitHeight,
                                  )
                                ),
                              ),],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (_) =>
                            PokemonDetailScreen(
                              pokemonDetail: pokedex[index],
                              color: getColorByType(type),
                              heroTag: index,
                            )));
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
    // Pokedex().pokemon.getAll().then((response) {
    Pokedex().pokemon.getPage(offset: 0, limit: 1).then((response) {
      var name1 = response.results;
      pokedex = response.results;
      // print(prettyJson(name1));
      // Pokedex().pokemon.get(name: name1[0].name).then((response) {
      //   print(response.sprites.frontDefault);
      // });
      setState(() {});
    });
  }

  String prettyJson(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  Future<dynamic> fetch_primary_type(List<dynamic> pokedex, BuildContext context, int index) async {
    Pokedex().pokemon.get(name: pokedex[index].name).then((response) {
      // print(prettyJson(response.types[0].type.name));
      return(response.types[0].type.name);
    });
  }

  Future<String> fetch_image(List<dynamic> pokedex, BuildContext context, int index) async {
    Pokedex().pokemon.get(name: pokedex[index].name).then((response) {
      // print(response.sprites.frontDefault);
      return(response.sprites.frontDefault);
    });
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png';
  }

  Color getColorByType(String type) {
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

}
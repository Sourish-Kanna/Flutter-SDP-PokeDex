import 'dart:convert';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon/pokemon_detail_screen.dart';
import 'package:pokedex/pokedex.dart';
import 'package:string_capitalize/string_capitalize.dart';

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
    var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
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
    // Pokedex().pokemon.getPage(limit: 1).then((response) {
    Pokedex().pokemon.getAll().then((response) {
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

  dynamic parseJson(String jsonString) {
    return json.decode(jsonString);
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
    var pokemon = parseJson(prettyJson(pokemonData));
    String type = pokemon['types'][0]['type']['name'].toString().capitalize();
    String Pokename = pokemon['name'].toString().capitalize();
    String id = pokemon['id'].toString();
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
                      right: -45,
                      child: Image.asset(
                          'images/pokeball.png',
                          height: 100,
                          fit: BoxFit.fitHeight)
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: Hero(
                        tag: int.parse(id),
                          child: FutureBuilder<String>(
                            future: fetchImage(id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return CachedNetworkImage(
                                  height: 110,
                                  imageUrl: snapshot.data!,
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  fit: BoxFit.fitHeight,
                                );
                              } else {
                                return Center(child: CircularProgressIndicator());
                              }
                            },
                          )
                      ),
                  ),
                  Positioned(
                    top: 50,
                    left: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                        color: Colors.black38,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4,
                            top: 1, bottom: 1),
                        child: Text(
                          type,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)),
                        color: Colors.black12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, right: 4,
                            top: 1, bottom: 1),
                        child: Text(
                          Pokename,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
        onTap: () {
          Navigator.push(
            context, MaterialPageRoute(builder: (_) =>
            PokemonDetailScreen(
                pokemonDetail: pokemon[id],
                color: getColorByType(type),
                heroTag: int.parse(id),
            )
            )
          );
        }
    );
  }

  Future<String> fetchImage( String id) async {
    String url = 'https://pokeapi.co/api/v2/pokemon/'+id;
    // Make GET request
    http.Response response = await http.get(Uri.parse(url));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Successful response
      return(parseJson(response.body)['sprites']['other']['official-artwork']['front_default'].toString());
    } else {
      return(response.statusCode.toString());
    }
  }


}

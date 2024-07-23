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
  String searchQuery = '';
  List<dynamic> filteredPokedex = [];
  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchPokemonData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
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
              top: 80,
              left: 20,
              child: Text("Pokedex",
                style: TextStyle(fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),)
          ),
          Positioned(
            top: 150,
            left: 20,
            right: 120,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search Pokémon',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) => filterPokemon(query),
            ),
          ),
          Positioned(
            top: 200,
            bottom: 0,
            width: width,
            child: Scrollbar(
              trackVisibility: true,
              thickness: 5.0,
              child: Column(
                children: [
                  filteredPokedex != null ? Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.4,
                        ),
                        itemCount: filteredPokedex.length,
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
          ),
        ],
      ),
    );
  }


  void fetchPokemonData() {
    Pokedex().pokemon.getAll().then((response) {
      setState(() {
        pokedex = response.results;
        filteredPokedex = pokedex;
      });
    });
  }

  void filterPokemon(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredPokedex = pokedex;
      } else {
        filteredPokedex = pokedex.where((pokemon) {
          return pokemon.name.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }


  String prettyJson(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  dynamic parseJson(String jsonString) {
    return json.decode(jsonString);
  }

  Color getColorByType(String type) {
    const Map<String, Color> colours = {
      'normal': const Color(0xFFA8A77A),
      'fire': const Color(0xFFEE8130),
      'water': const Color(0xFF6390F0),
      'electric': const Color(0xFFF7D02C),
      'grass': const Color(0xFF7AC74C),
      'ice': const Color(0xFF96D9D6),
      'fighting': const Color(0xFFC22E28),
      'poison': const Color(0xFFA33EA1),
      'ground': const Color(0xFFE2BF65),
      'flying': const Color(0xFFA98FF3),
      'psychic': const Color(0xFFF95587),
      'bug': const Color(0xFFA6B91A),
      'rock': const Color(0xFFB6A136),
      'ghost': const Color(0xFF735797),
      'dragon': const Color(0xFF6F35FC),
      'dark': const Color(0xFF705746),
      'steel': const Color(0xFFB7B7CE),
      'fairy': const Color(0xFFD685AD),
    };

    Color TypeCode = colours[type.toLowerCase()]?? Colors.grey;
    return TypeCode;
  }

  Future<Widget> getPokemonWidget(int index) async {
    var pokemonData = await fetchPokemonDetail(filteredPokedex[index].name);
    return buildPokemonWidget(pokemonData);
  }

  Future<dynamic> fetchPokemonDetail(String name) async {
    var response = await Pokedex().pokemon.get(name: name);
    return response;
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

  Widget buildPokemonWidget(dynamic pokemonData) {
    // Extract necessary data from pokemonData and return the Widget
    var pokemon = parseJson(prettyJson(pokemonData));
    var typeNames = pokemon['types'].map((item) => item['type']['name']).toList();
    String type1 = typeNames.first.toString().capitalize();
    String type2 = typeNames.last.toString().capitalize();
    String type = typeNames.join('\n').toString().capitalizeEach();
    String id = pokemon['id'].toString();
    String Pokename = "#${id} ${pokemon['name'].toString().capitalize()}";
    return InkWell(
        child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                color: getColorByType(type1).withOpacity(0.85),
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
                      // child: Hero(
                      //   tag: int.parse(id),
                      //     child: FutureBuilder<String>(
                      //       future: fetchImage(id),
                      //       builder: (context, snapshot) {
                      //         if (snapshot.connectionState == ConnectionState.done) {
                      //           return CachedNetworkImage(
                      //             height: 110,
                      //             imageUrl: snapshot.data!,
                      //             errorWidget: (context, url, error) =>
                      //                 Icon(Icons.error),
                      //             fit: BoxFit.fitHeight,
                      //           );
                      //         } else {
                      //           return Center(child: CircularProgressIndicator());
                      //         }
                      //       },
                      //     )
                      // ),
                    child: FutureBuilder<String>(
                      future: fetchImage(id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return CachedNetworkImage(
                            height: 90,
                            imageUrl: snapshot.data!,
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.fitHeight,
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [getColorByType(type1), getColorByType(type2)],
                          transform: GradientRotation(1.0),
                          stops: [0.50,0.50],
                        ),
                      ),
                      child: Padding(
                        padding: typeNames.length==2 ?
                        const EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2) :
                        const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                        child: Text(type,
                          style: const TextStyle(color: Colors.white,
                            fontWeight: FontWeight.bold, fontSize: 12),
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
                pokemonDetail: pokemon,
                color: getColorByType(type),
                // heroTag: int.parse(id),
            )
            )
          );
        }
    );
  }

}

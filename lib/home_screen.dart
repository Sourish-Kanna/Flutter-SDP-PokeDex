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
  // var pokeApi = "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  late List pokedex;
  @override
  void initState() {
    super.initState();
    if(mounted){
      fetchPokemonData();
    }
  }
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children:[
          Positioned(
            top: -50,
            right: -150,
              child: Image.asset('images/pokeball.png', width: 400, fit: BoxFit.fitWidth,),
          ),
          Positioned(
            top: 100,
              left: 20,
              child: Text("Pokedex",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.grey),)
          ),

          Positioned(
            top: 150,
            bottom: 0,
            width: width,
            child: Column(
            children: [
              pokedex != null ? Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount
                      (crossAxisCount: 2,
                      childAspectRatio: 1.4,),
                    itemCount: pokedex.length,
                    itemBuilder: (context, index){
                        InkWell(
                        child: FutureBuilder<Pokemon>(
                            future: Pokedex().pokemon.get(name: pokedex[index].name),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Or a loading placeholder
                              }
                              else if (snapshot.hasError) {
                                return Container(); // Handle errors
                              }
                              else if (snapshot.hasData) {
                                final pokemon = snapshot.data!;
                                final type = pokemon.types[0].type.name;
                                final img = pokemon.sprites.frontDefault;
                                return (
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal:12 ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: type =='Grass' ? Colors.greenAccent : type == "Fire" ? Colors.redAccent : type == "Water" ? Colors.blue
                                            : type == "Electric" ? Colors.yellow : type == "Rock" ? Colors.grey : type == "Ground" ? Colors.brown
                                            : type =="Psychic" ? Colors.indigo : type == "Fighting" ? Colors.orange : type =="Bug" ? Colors.lightGreenAccent
                                            : type =="Ghost" ? Colors.deepPurple : type == "Normal" ? Colors.blueGrey : type == "Poison" ? Colors.deepPurpleAccent : Colors.pinkAccent,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                              bottom: -10,
                                              right: -50,
                                              child: Image.asset('images/pokeball.png',
                                                height: 100,
                                                fit:BoxFit.fitHeight,)),
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
                                                padding: const EdgeInsets.only(left: 8.0, right: 8.0,top: 4, bottom: 4),
                                                child: Text(
                                                  type.toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(20)),
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
                                                // imageUrl: pokedex[index]['img'],
                                                imageUrl: img ?? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/1.svg',
                                                height: 100,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  )
                                );
                              }
                            }
                            ),
                        onTap: (){
                          //TODO Navigate to new detail screen
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PokemonDetailScreen(
                            pokemonDetail: pokedex[index],
                            // color: type =='Grass' ? Colors.greenAccent : type == "Fire" ? Colors.redAccent : type == "Water" ? Colors.blue
                            //     : type == "Electric" ? Colors.yellow : type == "Rock" ? Colors.grey : type == "Ground" ? Colors.brown
                            //     : type =="Psychic" ? Colors.indigo : type == "Fighting" ? Colors.orange : type =="Bug" ? Colors.lightGreenAccent
                            //     : type =="Ghost" ? Colors.deepPurple : type == "Normal" ? Colors.blueGrey : type == "Poison" ? Colors.deepPurpleAccent : Colors.pinkAccent,
                            color: Colors.greenAccent,
                            heroTag: index,
                          )));
                        },
                      );
                },
              )
              ): Center(
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
    Pokedex().pokemon.getAll().then((response) {
      var name1 = response.results;
      pokedex = response.results;
      // print(prettyJson(name1));
      // print(name1[0].name);
      // Pokedex().pokemon.get(name: name1[0].name).then((response) {
      //   print(prettyJson(response.types));
      // });
      setState(() {});
    });

    // var url = Uri.https("raw.githubusercontent.com",
    //     "/Biuni/PokemonGO-Pokedex/master/pokedex.json");
    // http.get(url).then((value) {
    //   if(value.statusCode == 200) {
    //     var decodedJsonData = jsonDecode(value.body);
    //     pokedex = decodedJsonData['pokemon'];
    //     // print(prettyJson(decodedJsonData['pokemon']));
    //     setState(() {});
    //   }
    // });
  }
}

  String prettyJson(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  /*InkWell pokemon_homepage(List<dynamic> pokedex, BuildContext context, int index) {
  var pokemon;
    // Pokedex().pokemon.get(name: pokedex[index].name).then((response) {
    //     print(prettyJson(response.types[0].type.name));
    //     pokemon = response;
    //   });

  FutureBuilder<Pokemon>(
    future: Pokedex().pokemon.get(name: pokedex[index].name),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return CircularProgressIndicator(); // Or a loading placeholder
    } else if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}'); // Handle errors
    } else if (snapshot.hasData) {
    final pokemon = snapshot.data!;
    final type = pokemon.types[0].type.name;
    };});

  //   var type = pokedex[index]['type'][0];
  //   print(pokedex[index]['name'][0]);
  //   return InkWell(
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal:12 ),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             color: type =='Grass' ? Colors.greenAccent : type == "Fire" ? Colors.redAccent : type == "Water" ? Colors.blue
  //                 : type == "Electric" ? Colors.yellow : type == "Rock" ? Colors.grey : type == "Ground" ? Colors.brown
  //                 : type =="Psychic" ? Colors.indigo : type == "Fighting" ? Colors.orange : type =="Bug" ? Colors.lightGreenAccent
  //                 : type =="Ghost" ? Colors.deepPurple : type == "Normal" ? Colors.blueGrey : type == "Poison" ? Colors.deepPurpleAccent : Colors.pinkAccent,
  //             borderRadius: BorderRadius.all(Radius.circular(20)),
  //           ),
  //           child: Stack(
  //             children: [
  //               Positioned(
  //                   bottom: -10,
  //                   right: -50,
  //                   child: Image.asset('images/pokeball.png',
  //                     height: 100,
  //                     fit:BoxFit.fitHeight,)),
  //               Positioned(
  //                 top: 20,
  //                 left: 10,
  //                 child: Text(
  //                   pokedex[index]['name'],
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold, fontSize: 18,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                 top: 45,
  //                 left: 20,
  //                 child: Container(
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(left: 8.0, right: 8.0,top: 4, bottom: 4),
  //                     child: Text(
  //                       type.toString(),
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                   ),
  //                   decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.all(Radius.circular(20)),
  //                     color: Colors.black26,
  //                   ),
  //                 ),
  //               ),
  //               Positioned(
  //                 bottom: 5,
  //                 right: 5,
  //                 child: Hero(
  //                   tag: index,
  //                   child: CachedNetworkImage(
  //                     imageUrl: pokedex[index]['img'],
  //                     height: 100,
  //                     fit: BoxFit.fitHeight,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       onTap: (){
  //         //TODO Navigate to new detail screen
  //         Navigator.push(context, MaterialPageRoute(builder: (_) => PokemonDetailScreen(
  //           pokemonDetail: pokedex[index],
  //           color: type =='Grass' ? Colors.greenAccent : type == "Fire" ? Colors.redAccent : type == "Water" ? Colors.blue
  //               : type == "Electric" ? Colors.yellow : type == "Rock" ? Colors.grey : type == "Ground" ? Colors.brown
  //               : type =="Psychic" ? Colors.indigo : type == "Fighting" ? Colors.orange : type =="Bug" ? Colors.lightGreenAccent
  //               : type =="Ghost" ? Colors.deepPurple : type == "Normal" ? Colors.blueGrey : type == "Poison" ? Colors.deepPurpleAccent : Colors.pinkAccent,
  //           heroTag: index,
  //         )));
  //       },
  //
  //     );
  }*/
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:pokedex/pokedex.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonDetailScreen extends StatefulWidget {
  final dynamic pokemonDetail;
  final Color color;

  const PokemonDetailScreen({super.key, this.pokemonDetail, required this.color});

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var pokemon = widget.pokemonDetail;
    var Stats = parseJson(prettyJson(pokemon["stats"]));
    var Moves = parseJson(prettyJson(pokemon["moves"]));
    var typeNames = pokemon['types'].map((item) => item['type']['name']).toList();
    String type1 = typeNames.first.toString().capitalize();
    String type2 = typeNames.last.toString().capitalize();
    String type = typeNames.join(' | ').toString().capitalizeEach();
    String id = pokemon['id'].toString();
    String name = pokemon['name'].toString().capitalize();
    String pokeHeight = "${(pokemon['height'] / 10).toString()} m";
    String pokeWeight = "${(pokemon['weight'] / 10).toString()} Kg";
    String pokeAbility = "${pokemon["abilities"][0]["ability"]["name"]}".capitalize();
    String hp = "${Stats[0]["base_stat"]}";
    String attack = "${Stats[1]["base_stat"]}";
    String defence = "${Stats[2]["base_stat"]}";
    String speed = "${Stats[5]["base_stat"]}";
    String move1 = "${Moves[0]["move"]["name"]}".split("-").join(" ").capitalizeEach();
    String move2 = "${Moves[1]["move"]["name"]}".split("-").join(" ").capitalizeEach();
    String move3 = "${Moves[2]["move"]["name"]}".split("-").join(" ").capitalizeEach();
    String move4 = "${Moves[3]["move"]["name"]}".split("-").join(" ").capitalizeEach();

    return Scaffold(
      backgroundColor: getColorByType(type1).withOpacity(0.75),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: height * 0.15,
            left: -45,
            child: Image.asset(
              "images/pokeball.png",
              height: 275,
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            top: 30,
            left: 5,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 90,
            left: 20,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [getColorByType(type1), getColorByType(type2)],
                  transform: const GradientRotation(1.0),
                  stops: const [0.50, 0.50],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0, bottom: 4.0),
                child: Text(
                  type,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: height * 0.6,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(20)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            SizedBox(
                              width: width * 0.3,
                              child: const Text("ID", style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                            Text('#$id', style: const TextStyle(
                                color: Colors.black, fontSize: 18
                            ),),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            SizedBox(
                               width: width * 0.3,
                                 child: const Text("Name", style: TextStyle(
                                     color: Colors.blueGrey, fontSize: 18,
                                     fontWeight: FontWeight.bold
                                 ),),
                             ),
                            Text(name, style: const TextStyle(
                                color: Colors.black, fontSize: 18
                            ),),
                           ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            SizedBox(
                              width: width * 0.3,
                              child: const Text("Height", style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                            Text(pokeHeight, style: const TextStyle(
                                color: Colors.black, fontSize: 18
                            ),),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            SizedBox(
                              width: width * 0.3,
                              child: const Text("Weight", style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                            Text(pokeWeight, style: const TextStyle(
                                color: Colors.black, fontSize: 18
                            ),),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            SizedBox(
                              width: width * 0.3,
                              child: const Text("Ability", style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),
                            ),
                            Text(pokeAbility, style: const TextStyle(
                                color: Colors.black, fontSize: 18
                            ),),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            SizedBox(
                              width: width * 0.3,
                              child: const Text("Evolves",
                                style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),),
                            ),
                            FutureBuilder(
                              future: getPokemonWidget(pokemon['id']),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    return snapshot.data!;
                                  } else {
                                    return const Center(child: Text("No data found"));
                                  }
                                } else {
                                  return const Center(child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ],
                        ),
                      ),

                      Padding(padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            SizedBox(
                              width: width/5,
                              child: const Text("HP", style: TextStyle(
                                color: Colors.blueGrey, fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),),
                            SizedBox(
                              width: width/5,
                              child: const Text("Attack", style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),),
                            SizedBox(
                              width: width/5,
                              child: const Text("Defense", style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),),
                            SizedBox(
                              width: width/5,
                              child: const Text("Speed", style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),),),
                          ],),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              SizedBox(
                                width: width/5,
                                child: Text(hp, style: const TextStyle(
                                    color: Colors.black, fontSize: 18,
                                ),),),
                              SizedBox(
                                width: width/5,
                                child: Text(attack, style: const TextStyle(
                                  color: Colors.black, fontSize: 18,
                                ),),),
                              SizedBox(
                                width: width/5,
                                child: Text(defence, style: const TextStyle(
                                  color: Colors.black, fontSize: 18,
                                ),),),
                              SizedBox(
                                width: width/5,
                                child: Text(speed, style: const TextStyle(
                                  color: Colors.black, fontSize: 18,
                                ),),),
                            ],),
                          ],
                        ),
                      ),

                      Padding(padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                Text("Moves", style: TextStyle(
                                    color: Colors.blueGrey, fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),),
                              ],),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:[
                                SizedBox(
                                  width: width/5,
                                  child: Text(move1, style: const TextStyle(
                                    color: Colors.black, fontSize: 18,
                                  ),),),
                                SizedBox(
                                  width: width/5,
                                  child: Text(move2, style: const TextStyle(
                                    color: Colors.black, fontSize: 18,
                                  ),),),
                                SizedBox(
                                  width: width/5,
                                  child: Text(move3, style: const TextStyle(
                                    color: Colors.black, fontSize: 18,
                                  ),),),
                                SizedBox(
                                  width: width/5,
                                  child: Text(move4, style: const TextStyle(
                                    color: Colors.black, fontSize: 18,
                                  ),),),
                              ],),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.20,
            left: (width / 2) - 100,
            child: FutureBuilder<String>(
              future: fetchImage(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return CachedNetworkImage(
                      height: 200,
                      imageUrl: snapshot.data!,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.fitHeight,
                    );
                  } else {
                    return const Center(child: Text("No image found"));
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  dynamic parseJson(String jsonString) {
    return json.decode(jsonString);
  }

  String prettyJson(dynamic json) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  Color getColorByType(String type) {
    const Map<String, Color> colours = {
      'normal': Color(0xFFA8A77A),
      'fire': Color(0xFFEE8130),
      'water': Color(0xFF6390F0),
      'electric': Color(0xFFF7D02C),
      'grass': Color(0xFF7AC74C),
      'ice': Color(0xFF96D9D6),
      'fighting': Color(0xFFC22E28),
      'poison': Color(0xFFA33EA1),
      'ground': Color(0xFFE2BF65),
      'flying': Color(0xFFA98FF3),
      'psychic': Color(0xFFF95587),
      'bug': Color(0xFFA6B91A),
      'rock': Color(0xFFB6A136),
      'ghost': Color(0xFF735797),
      'dragon': Color(0xFF6F35FC),
      'dark': Color(0xFF705746),
      'steel': Color(0xFFB7B7CE),
      'fairy': Color(0xFFD685AD),
    };

    return colours[type.toLowerCase()] ?? Colors.grey;
  }

  Future<String> fetchImage(String id) async {
    String url = 'https://pokeapi.co/api/v2/pokemon/$id';
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return parseJson(response.body)['sprites']['other']['official-artwork']['front_default'].toString();
    } else {
      return response.statusCode.toString();
    }
  }

  Future<dynamic> fetchPokemonEvolution(int index) async {
    var response = await Pokedex().evolutionChains.get(index);
    return response;
  }

  Future<dynamic> fetchPokemonDetail(int index) async {
    var response = await Pokedex().pokemon.get(id: index);
    return response;
  }

  Future<Widget> getPokemonWidget(int index) async {
    var pokemonEvoData = await fetchPokemonEvolution(index);
    var pokemon = parseJson(prettyJson(pokemonEvoData));
    String newPoke = pokemon['chain']['evolves_to'].first['species']['url'].toString().split('/').reversed.elementAt(1);
    // print(prettyJson(pokemon));
    // print(newPoke);
    var pokemonData = await fetchPokemonDetail(int.parse(newPoke));
    var pokemon1 = parseJson(prettyJson(pokemonData));
    // print(prettyJson(pokemon1));
    // print(newPoke);
    return buildPokemonWidget(pokemonEvoData,pokemonData);
  }

  Widget buildPokemonWidget(dynamic pokemonEvoData, dynamic pokemonData) {
    var pokemon = parseJson(prettyJson(pokemonEvoData));
    var pokemon1 = parseJson(prettyJson(pokemonData));
    // print(prettyJson(pokemon));
    String id = (pokemon1['id']).toString();
    String pokeName = "#$id ${pokemon['chain']['evolves_to'].first['species']['name'].toString().capitalize()}";

    return Text(
      pokeName,
      style: const TextStyle(color: Colors.black, fontSize: 18),
    );
  }
}

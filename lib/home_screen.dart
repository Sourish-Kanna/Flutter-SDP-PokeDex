import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon/pokemon_detail_screen.dart';
import 'package:pokedex/pokedex.dart';
import 'package:string_capitalize/string_capitalize.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> pokedex = [];
  String searchQuery = '';
  List<dynamic> filteredPokedex = [];
  final TextEditingController _searchController = TextEditingController();

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
          const Positioned(
              top: 80,
              left: 20,
              child: Text("Pokedex",
                style: TextStyle(fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),)
          ),
          Positioned(
            top: 150,
            left: 10,
            right: 5,
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Pokémon Name/Id',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      // prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: _performSearch,
                    child: const Icon(Icons.search,
                      color: Colors.blue,),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () async {
                      Widget detailScreen = await randomPokemon();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => detailScreen),
                      );
                    },
                    child: const Icon(Icons.explore_outlined,
                      color: Colors.blue,),
                  ),
                )
              ],
            )),
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
                  Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                return const CircularProgressIndicator();
                              }
                            },
                          );
                        },
                      )
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

  void _performSearch() {
    FocusScope.of(context).unfocus();
    final query = _searchController.text;
    filterPokemon(query); // Replace this with your actual search function
  }

  bool isInteger(String str) {
    return int.tryParse(str) != null;
  }

  List<int> findNumbersContainingDigit(List<int> numbers, int digit) {
    return numbers.where((number) => number.toString().contains(digit.toString())).toList();
  }

  void filterPokemon(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredPokedex = pokedex;
      } else {
        if (isInteger(query)) {
          int id = int.parse(query);
          List<int> numbers = List.generate(pokedex.length, (index) => index);;
          int digitToFind = id;
          List<int> result = findNumbersContainingDigit(numbers, digitToFind);
          filteredPokedex = result.map((index) => pokedex[index-1]).toList();
        } else {
          filteredPokedex = pokedex.where((pokemon) {
            return pokemon.name.toLowerCase().contains(query.toLowerCase());
          }).toList();
        }
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

    Color typeColour = colours[type.toLowerCase()]?? Colors.grey;
    return typeColour;
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
    String url = 'https://pokeapi.co/api/v2/pokemon/$id';
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
    String pokeName = "#$id ${pokemon['name'].toString().capitalize()}";
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
                                const Icon(Icons.error),
                            fit: BoxFit.fitHeight,
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
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
                          transform: const GradientRotation(1.0),
                          stops: const [0.50,0.50],
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
                          pokeName,
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
          FocusScope.of(context).unfocus();
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

  Future<Widget> randomPokemon() async {
    Random random = Random();
    int randomInt = random.nextInt(pokedex.length);
    var pokemonData = await fetchPokemonDetail(pokedex[randomInt].name);
    var pokemon = parseJson(prettyJson(pokemonData));
    String type = pokemon['types'].map((item) => item['type']['name'])
        .toList().join('\n').toString().capitalizeEach();
    return PokemonDetailScreen(
      pokemonDetail: pokemon,
      color: getColorByType(type),
    );
  }
}

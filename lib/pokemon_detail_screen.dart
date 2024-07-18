import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PokemonDetailScreen extends StatefulWidget {
 final pokemonDetail;
 final Color color;
 // final int heroTag;

  const PokemonDetailScreen({super.key, this.pokemonDetail, required this.color});  //, required this.heroTag});

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var pokemon = widget.pokemonDetail;
    var typeNames = pokemon['types'].map((item) => item['type']['name']).toList();
    String type1 = typeNames.first.toString().capitalize();
    String type2 = typeNames.last.toString().capitalize();
    String type = typeNames.join(' | ').toString().capitalizeEach();
    String id = pokemon['id'].toString();
    String name = pokemon['name'].toString().capitalize();
    String PokeHeight = "${(pokemon['height'] / 10).toString()} m";
    String PokeWeight = "${(pokemon['weight'] / 10).toString()} Kg";

    return Scaffold(
      backgroundColor: getColorByType(type1).withOpacity(0.75),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 30,
            left: 5,
            child: IconButton( icon: Icon(Icons.arrow_back, color: Colors.white,
              size: 30,),onPressed: (){ Navigator.pop(context);
            }),
          ),

          Positioned(
            top: 90,
              left: 20,
              child: Text(name,style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold,
                fontSize: 30, ),)
          ),

          Positioned(
            top: 140,
              left: 20,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0,
                      top: 4.0,bottom: 4.0),
                  child: Text(type,style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold, ),),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [getColorByType(type1), getColorByType(type2)],
                    transform: GradientRotation(1.0),
                    stops: [0.50,0.50],
                  ),
                ),
              ),
          ),

          Positioned(
            top: height * 0.15,
            right: -20,
            child: Image.asset("images/pokeball.png", height: 275,
              fit: BoxFit.fitHeight,),
          ),

          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: height * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(20)),
                color: Colors.white,
              ),

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                             Container(
                               width: width * 0.3,
                                 child: Text("Name", style: TextStyle(
                                   color: Colors.blueGrey, fontSize: 18,
                                 ),),
                             ),
                            Container(
                              child: Text(name, style: TextStyle(
                                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold
                              ),),
                            ),
                           ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            Container(
                              width: width * 0.3,
                              child: Text("Height", style: TextStyle(
                                color: Colors.blueGrey, fontSize: 18,
                              ),),
                            ),
                            Container(
                              child: Text(PokeHeight, style: TextStyle(
                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold
                              ),),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:[
                            Container(
                              width: width * 0.3,
                              child: Text("Weight", style: TextStyle(
                                color: Colors.blueGrey, fontSize: 18,
                              ),),
                            ),
                            Container(
                              child: Text(PokeWeight, style: TextStyle(
                                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold
                              ),),
                            ),
                          ],
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children:[
                      //       Container(
                      //         width: width * 0.3,
                      //         child: Text("Spawn Time", style: TextStyle(
                      //           color: Colors.blueGrey, fontSize: 18,
                      //         ),),
                      //       ),
                      //       Container(
                      //         child: Text(widget.pokemonDetail['spawn_time'], style: TextStyle(
                      //             color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold
                      //         ),),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children:[
                      //       Container(
                      //         width: width * 0.3,
                      //         child: Text("Weakness", style: TextStyle(
                      //           color: Colors.blueGrey, fontSize: 18,
                      //         ),),
                      //       ),
                      //       Container(
                      //         child: Text(widget.pokemonDetail['weaknesses'].join(","), style: TextStyle(
                      //             color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold
                      //         ),),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children:[
                      //       Container(
                      //         width: width * 0.3,
                      //         child: Text("Pre Form", style: TextStyle(
                      //           color: Colors.blueGrey, fontSize: 18,
                      //         ),),
                      //       ),
                      //       widget.pokemonDetail['prev_evolution'] != null ?
                      //       SizedBox(
                      //         height: 20,
                      //         width: width * 0.55,
                      //         child: ListView.builder(
                      //           scrollDirection: Axis.horizontal,
                      //           itemCount: widget.pokemonDetail['prev_evolution'].length,
                      //           itemBuilder: (context, index){
                      //             return Padding(
                      //               padding: const EdgeInsets.only(right: 8.0),
                      //               child: Text(widget.pokemonDetail['prev_evolution'][index]['name'], style: TextStyle(
                      //                   color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold
                      //               ),),
                      //             );
                      //           },
                      //         ),
                      //       ): Text('just Hatched', style: TextStyle(
                      //           color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold
                      //       ),)
                      //     ],
                      //   ),
                      // ),


                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children:[
                      //       Container(
                      //         width: width * 0.3,
                      //         child: Text("Evolution", style: TextStyle(
                      //           color: Colors.blueGrey, fontSize: 18,
                      //         ),),
                      //       ),
                      //       widget.pokemonDetail['next_evolution'] != null ?
                      //       SizedBox(
                      //         height: 20,
                      //         width: width * 0.55,
                      //         child: ListView.builder(
                      //           scrollDirection: Axis.horizontal,
                      //             itemCount: widget.pokemonDetail['next_evolution'].length,
                      //             itemBuilder: (context, index){
                      //               return Padding(
                      //                 padding: const EdgeInsets.only(right: 8.0),
                      //                 child: Text(widget.pokemonDetail['next_evolution'][index]['name'], style: TextStyle(
                      //                     color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold
                      //                 ),),
                      //               );
                      //             },
                      //         ),
                      //       ): Text('Maxed Out', style: TextStyle(
                      //           color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold
                      //       ),)
                      //     ],
                      //   ),
                      // ),


                    ],
                  ),
              ),
              ),
            ),

          Positioned(
              top: height * 0.20,
              left: (width/2)-100,
              // child: Hero(
              //     tag: int.parse(id),
              //     child: FutureBuilder<String>(
              //       future: fetchImage(id),
              //       builder: (context, snapshot) {
              //         if (snapshot.connectionState == ConnectionState.done) {
              //           return CachedNetworkImage(
              //             height: 200,
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
              // )
              child: FutureBuilder<String>(
                future: fetchImage(id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return CachedNetworkImage(
                      height: 200,
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
          )

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

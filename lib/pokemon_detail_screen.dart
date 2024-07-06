import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
class PokemonDetailScreen extends StatefulWidget {
 final pokemonDetail;
 final Color color;
 final int heroTag;

  const PokemonDetailScreen({super.key, this.pokemonDetail, required this.color, required this.heroTag});

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}
//hello world
class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: widget.color,
      body: Stack(
        children: [
          Positioned(
            top: 30,
            left: 5,
            child: IconButton( icon: Icon(Icons.arrow_back, color: Colors.white, size: 30,),onPressed: (){ Navigator.pop(context);
            }),
          ),
          Positioned(
            top: 90,
              left: 20,
              child: Text(widget.pokemonDetail['name'],style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold,
                fontSize: 30,
              ),)),
          Positioned(
            top: height * 0.24,
            right: -105,
            child: Image.asset("images/pokeball.png", height: 200, fit: BoxFit.fitHeight,),
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
            ),
          ),
          Positioned(
            
              top: height * 0.2,
              left: (width/2)-75,
              child: CachedNetworkImage(
            imageUrl: widget.pokemonDetail['img'],
          ))

        ],
      ),

    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:string_capitalize/string_capitalize.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Map<String, dynamic> pokemonDetail;
  final Color color;

  const PokemonDetailScreen({
    super.key,
    required this.pokemonDetail,
    required this.color,
  });

  @override
  PokemonDetailScreenState createState() => PokemonDetailScreenState();
}

class PokemonDetailScreenState extends State<PokemonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    Color headerTextColor = widget.color.computeLuminance() > 0.6
        ? Colors.black87
        : Colors.white;

    final pokemon = widget.pokemonDetail;
    final List<dynamic> stats = pokemon['stats'];
    final List<dynamic> moves = pokemon['moves'];
    final List<dynamic> types = pokemon['types'];

    var typeNames = types.map((item) => item['type']['name']).toList();

    String type1 = typeNames.first.toString().capitalize();
    String type = typeNames.join(' | ').toString().capitalizeEach();
    String id = pokemon['id'].toString();
    String name = pokemon['name'].toString().capitalize();
    String pokeHeight = "${(pokemon['height'] / 10).toString()} m";
    String pokeWeight = "${(pokemon['weight'] / 10).toString()} Kg";

    final List<dynamic> abilities = pokemon['abilities'];
    String pokeAbility = (abilities.isNotEmpty)
        ? abilities.first['ability']['name'].toString().capitalize()
        : "None";

    String hp = stats[0]['base_stat'].toString();
    String attack = stats[1]['base_stat'].toString();
    String defence = stats[2]['base_stat'].toString();
    String speed = stats[5]['base_stat'].toString();

    String move1 = (moves.isNotEmpty)
        ? moves[0]['move']['name']
              .toString()
              .split("-")
              .join(" ")
              .capitalizeEach()
        : "";
    String move2 = (moves.length > 1)
        ? moves[1]['move']['name']
              .toString()
              .split("-")
              .join(" ")
              .capitalizeEach()
        : "";
    String move3 = (moves.length > 2)
        ? moves[2]['move']['name']
              .toString()
              .split("-")
              .join(" ")
              .capitalizeEach()
        : "";
    String move4 = (moves.length > 3)
        ? moves[3]['move']['name']
              .toString()
              .split("-")
              .join(" ")
              .capitalizeEach()
        : "";

    String? imageUrl =
        pokemon['sprites']['other']?['official-artwork']?['front_default'] ??
        pokemon['sprites']['front_default'];

    return Scaffold(
      backgroundColor: widget.color,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: height * 0.16,
            left: width * 0.17,
            child: Image.asset(
              "images/pokeball.png",
              height: 275,
              fit: BoxFit.fitHeight,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
          // Enforces device structural safe zones around control headers and titles
          SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  left: 5,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: headerTextColor,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 55,
                  left: 20,
                  child: Text(
                    name,
                    style: TextStyle(
                      color: headerTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Positioned(
                  top: 105,
                  left: 20,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.black12,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                        top: 4.0,
                        bottom: 4.0,
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          color: headerTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: height * 0.55,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      buildDetailRow(width, "ID", '#$id'),
                      buildDetailRow(width, "Name", name),
                      buildDetailRow(width, "Height", pokeHeight),
                      buildDetailRow(width, "Weight", pokeWeight),
                      buildDetailRow(width, "Ability", pokeAbility),
                      const SizedBox(height: 20),

                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Text(
                                "HP",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Attack",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Defense",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Speed",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                hp,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                attack,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                defence,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                speed,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),

                      Column(
                        children: [
                          const Text(
                            "Featured Moves",
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              if (move1.isNotEmpty) buildMoveBadge(move1),
                              if (move2.isNotEmpty) buildMoveBadge(move2),
                              if (move3.isNotEmpty) buildMoveBadge(move3),
                              if (move4.isNotEmpty) buildMoveBadge(move4),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.18,
            child: Hero(
              tag: 'pokemon-image-$id',
              child: (imageUrl != null && imageUrl.isNotEmpty)
                  ? CachedNetworkImage(
                      height: 200,
                      imageUrl: imageUrl,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, size: 50),
                      fit: BoxFit.fitHeight,
                    )
                  : const Icon(Icons.help_outline, size: 100),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow(double width, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.3,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildMoveBadge(String moveName) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        moveName,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}

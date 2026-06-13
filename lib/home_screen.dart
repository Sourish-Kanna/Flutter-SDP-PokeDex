import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:PokeDex_Flutter/pokemon_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_capitalize/string_capitalize.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<dynamic> pokedex = [];
  List<dynamic> filteredPokedex = [];
  bool isLoading = true;
  bool showScrollFAB = false;
  bool isNearBottom = false;

  final SearchController _searchController = SearchController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          filteredPokedex = pokedex;
        });
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        double offset = _scrollController.offset;
        double maxScroll = _scrollController.position.maxScrollExtent;

        bool shouldShow = offset > 300;
        bool nearBottom = offset > (maxScroll / 2);

        if (shouldShow != showScrollFAB || nearBottom != isNearBottom) {
          setState(() {
            showScrollFAB = shouldShow;
            isNearBottom = nearBottom;
          });
        }
      }
    });

    fetchPokemonData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void handleScrollAction() {
    if (_scrollController.hasClients) {
      if (isNearBottom) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  Future<void> fetchPokemonData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cachedData = prefs.getString('pokedex_cache_all_gens');

      if (cachedData != null) {
        final List<dynamic> decodedCache = json.decode(cachedData);
        setState(() {
          pokedex = decodedCache;
          filteredPokedex = pokedex;
          isLoading = false;
        });

        _backgroundFetchFreshData(prefs);
        return;
      }

      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=2000');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        await prefs.setString('pokedex_cache_all_gens', json.encode(results));

        setState(() {
          pokedex = results;
          filteredPokedex = results;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data from server');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Failed to load global Pokédex data. Using offline storage if available.",
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _backgroundFetchFreshData(SharedPreferences prefs) async {
    try {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=2000');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        await prefs.setString('pokedex_cache_all_gens', json.encode(results));
      }
    } catch (_) {}
  }

  /// Helper method to extract the Pokémon ID string from its PokéAPI URL endpoint
  /// Example input: "https://pokeapi.co/api/v2/pokemon/25/" -> Output: "25"
  String _extractIdFromUrl(String url) {
    try {
      final segments = Uri.parse(url).pathSegments;
      // The ID is the second to last segment because of the trailing slash
      return segments[segments.length - 2];
    } catch (_) {
      return '';
    }
  }

  void filterPokemon(String query) {
    final cleanQuery = query.trim().toLowerCase();

    setState(() {
      if (cleanQuery.isEmpty) {
        filteredPokedex = pokedex;
      } else {
        filteredPokedex = pokedex.where((pokemon) {
          final name = pokemon['name'].toString().toLowerCase();
          final id = _extractIdFromUrl(pokemon['url'].toString());

          // Matches if the name contains the search term OR if the ID matches exactly
          return name.contains(cleanQuery) || id == cleanQuery;
        }).toList();
      }
    });
  }

  Future<void> goToRandomPokemon() async {
    if (pokedex.isEmpty) return;

    try {
      Random random = Random();
      int randomInt = random.nextInt(pokedex.length);
      String pokemonName = pokedex[randomInt]['name'];

      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> pokemonDetail = json.decode(response.body);
        final List<dynamic> types = pokemonDetail['types'];
        String type1 = types.first['type']['name'].toString();

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PokemonDetailScreen(
                pokemonDetail: pokemonDetail,
                color: getColorByType(type1),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error fetching random Pokémon details"),
          ),
        );
      }
    }
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
      'stellar': Color(0xFF7CC7B2),
      'unknown': Color(0xFF68A090),
    };
    return colours[type.toLowerCase()] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: showScrollFAB
          ? FloatingActionButton(
              onPressed: handleScrollAction,
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 4.0,
              tooltip: isNearBottom ? 'Scroll to top' : 'Scroll to bottom',
              child: Icon(
                isNearBottom
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
              ),
            )
          : null,
      body: Stack(
        children: [
          Positioned(
            top: -65,
            right: -70,
            child: Image.asset(
              'images/pokeball.png',
              height: 250,
              fit: BoxFit.fitWidth,
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                const Positioned(
                  top: 20,
                  left: 20,
                  child: Text(
                    "Pokedex",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  left: 15,
                  right: 15,
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchAnchor.bar(
                          searchController: _searchController,
                          barHintText: 'Search by name or ID...',
                          barElevation: WidgetStateProperty.all(1.0),
                          barBackgroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                          barShape: WidgetStateProperty.all(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                          ),
                          onChanged: (String text) {
                            filterPokemon(text);
                          },
                          onSubmitted: (String text) {
                            _searchController.closeView(text);
                            filterPokemon(text);
                          },
                          suggestionsBuilder:
                              (
                                BuildContext context,
                                SearchController controller,
                              ) {
                                final keyword = controller.text
                                    .trim()
                                    .toLowerCase();

                                // Updated suggestions filter to evaluate both name matches and precise ID matches
                                final limitedMatches = pokedex
                                    .where((p) {
                                      final name = p['name']
                                          .toString()
                                          .toLowerCase();
                                      final id = _extractIdFromUrl(
                                        p['url'].toString(),
                                      );
                                      return name.contains(keyword) ||
                                          id == keyword;
                                    })
                                    .take(25)
                                    .toList();

                                return limitedMatches.map((pokemon) {
                                  final pokeId = _extractIdFromUrl(
                                    pokemon['url'].toString(),
                                  );
                                  return ListTile(
                                    leading: Text(
                                      '#$pokeId',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black38,
                                      ),
                                    ),
                                    title: Text(
                                      pokemon['name'].toString().capitalize(),
                                      style: const TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    onTap: () {
                                      controller.closeView(
                                        pokemon['name'].toString(),
                                      );
                                      filterPokemon(pokemon['name'].toString());
                                    },
                                  );
                                }).toList();
                              },
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: goToRandomPokemon,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                        icon: const Icon(Icons.explore_outlined),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 165,
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.redAccent,
                          ),
                        )
                      : filteredPokedex.isEmpty
                      ? const Center(
                          child: Text(
                            "No Pokémon matches your search.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        )
                      : Scrollbar(
                          controller: _scrollController,
                          trackVisibility: true,
                          thickness: 5.0,
                          child: GridView.builder(
                            controller: _scrollController,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 1.5,
                                ),
                            itemCount: filteredPokedex.length,
                            itemBuilder: (context, index) {
                              return PokemonGridCard(
                                key: ValueKey(filteredPokedex[index]['name']),
                                pokemonName: filteredPokedex[index]['name'],
                                getColorByType: getColorByType,
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PokemonGridCard extends StatefulWidget {
  final String pokemonName;
  final Color Function(String) getColorByType;

  const PokemonGridCard({
    super.key,
    required this.pokemonName,
    required this.getColorByType,
  });

  @override
  State<PokemonGridCard> createState() => _PokemonGridCardState();
}

class _PokemonGridCardState extends State<PokemonGridCard> {
  Future<Map<String, dynamic>>? _detailFuture;
  static final Map<String, Map<String, dynamic>> _detailMemoryCache = {};

  @override
  void initState() {
    super.initState();
    _detailFuture = _fetchDetail();
  }

  Future<Map<String, dynamic>> _fetchDetail() async {
    if (_detailMemoryCache.containsKey(widget.pokemonName)) {
      return _detailMemoryCache[widget.pokemonName]!;
    }

    final url = Uri.parse(
      'https://pokeapi.co/api/v2/pokemon/${widget.pokemonName}',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      _detailMemoryCache[widget.pokemonName] = data;
      return data;
    }
    throw Exception('Failed to load detail');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.redAccent),
          );
        }

        final pokemon = snapshot.data!;
        final List<dynamic> types = pokemon['types'];

        var typeNames = types.map((item) => item['type']['name']).toList();
        String type1 = typeNames.first.toString().capitalize();
        String type = typeNames.join('\n').toString().capitalizeEach();
        String id = pokemon['id'].toString();
        String pokeName = "#$id ${pokemon['name'].toString().capitalize()}";

        String? imageUrl =
            pokemon['sprites']?['other']?['official-artwork']?['front_default'] ??
            pokemon['sprites']?['front_default'];

        return InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PokemonDetailScreen(
                  pokemonDetail: pokemon,
                  color: widget.getColorByType(type1),
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: widget.getColorByType(type1).withOpacity(0.85),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: -15,
                    child: Image.asset(
                      'images/pokeball.png',
                      height: 115,
                      fit: BoxFit.fitHeight,
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Hero(
                      tag: 'pokemon-image-$id',
                      child: (imageUrl != null && imageUrl.isNotEmpty)
                          ? CachedNetworkImage(
                              height: 85,
                              imageUrl: imageUrl,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error, color: Colors.white),
                              fit: BoxFit.fitHeight,
                            )
                          : const Icon(
                              Icons.help_outline,
                              size: 40,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  Positioned(
                    top: 45,
                    left: 10,
                    child: Text(
                      type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 5,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.black26,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        child: Text(
                          pokeName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

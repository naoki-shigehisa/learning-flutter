import 'package:flutter/material.dart';
import '../api/pokeapi.dart';

class PokemonsNotifier extends ChangeNotifier {
  final Map<int, Pokemon?> _pokeMap = {};

  Map<int, Pokemon?> get pokes => _pokeMap;

  void addPokemon(Pokemon poke) {
    _pokeMap[poke.id] = poke;
    notifyListeners();
  }

  void fetchPokemon(int id) async {
    _pokeMap[id] = null;
    addPokemon(await fetchPokemonFromApi(id));
  }

  Pokemon? byId(int id) {
    if (!_pokeMap.containsKey(id)) {
      fetchPokemon(id);
    }
    return _pokeMap[id];
  }
}

class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<String> typesToList(dynamic types) {
      List<String> ret = [];
      for (int i = 0; i < types.length; i++) {
        ret.add(types[i]['type']['name']);
      }
      return ret;
    }

    return Pokemon(
      id: json['id'],
      name: json['name'],
      types: typesToList(json['types']),
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
    );
  }
}

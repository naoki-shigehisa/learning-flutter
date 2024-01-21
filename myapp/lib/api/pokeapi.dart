import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';
import '../const/pokeapi.dart';

Future<Pokemon> fetchPokemonFromApi(int id) async {
  final response = await http.get(Uri.parse('$pokeApiRoute/pokemon/$id'));
  if (response.statusCode == 200) {
    return Pokemon.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Pokemon');
  }
}

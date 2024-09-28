import 'dart:convert';

import 'package:firebaseconn3/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  String urlBase = "https://pokeapi.co/api/v2/";

  Future getPokemonInfo() async {
    Uri url = Uri.parse("$urlBase/pokemon/");
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      PokemonModel _auxPokemonModel = PokemonModel.fromJson(data);
      print(_auxPokemonModel.results);
    }
    return null;
  }
}

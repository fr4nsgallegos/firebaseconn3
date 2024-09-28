import 'dart:convert';

import 'package:firebaseconn3/models/pokemon_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  String urlBase = "https://pokeapi.co/api/v2/";
  String urlBase2 = "https://fakestoreapi.com/";

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

  Future<void> postProductFakeApi() async {
    Uri url = Uri.parse("${urlBase2}products");
    http.Response response = await http.post(
      url,
      headers: {
        'Conten-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          "id": 159,
          "title": "uinformacno la vamos a ver",
          "price": 15.5,
          "description": "dfeasdasdasd",
          "category": "zapats",
          "image": "www.google.com",
          "rating": {
            "rate": 45.6,
            "count": 259,
          }
        },
      ),
    );
    if (response.statusCode == 200) {
      print("se inserto bien");
      print(response.body);
    } else {
      print("nO SE REALIZO CORREACTAMENTE LA INSECIÓN");
      print(response.statusCode);
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  String urlBase = "https://pokeapi.co/api/v2/";

  Future getPokemonInfo() async {
    Uri url = Uri.parse(urlBase);
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      print(data);
    }
    return null;
  }
}

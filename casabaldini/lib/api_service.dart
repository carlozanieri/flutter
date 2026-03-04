import 'dart:convert';
import 'package:http/http.dart' as http;
import 'slider_model.dart';
import 'package:casabaldini/models/menu_model.dart';

class ApiService {
  static const String baseUrl = "https://json.casabaldini.eu/api/v1";

  Future<List<SliderModel>> fetchSliders() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/slider'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => SliderModel.fromJson(item)).toList();
      }

      throw "Errore stato server: ${response.statusCode}";
    } catch (e) {
      throw "Errore di rete: $e";
    }
  }
}

Future<List<MenuEntry>> fetchMenu() async {
  final response = await http.get(
    Uri.parse("https://json.casabaldini.eu/api/v1/menu"),
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => MenuEntry.fromJson(data)).toList();
  } else {
    throw Exception('Errore nel caricamento del menu');
  }
}

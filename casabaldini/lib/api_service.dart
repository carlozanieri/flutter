import 'dart:convert';
import 'package:http/http.dart' as http;
import 'slider_model.dart';

class ApiService {
  static const String baseUrl = "http://json.casabaldini.eu/api/v1";

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

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/amiibo_model.dart';

class ApiService {
  static const String baseUrl = 'https://www.amiiboapi.com';

  // Get all amiibos
  static Future<List<Amiibo>> getAllAmiibos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/amiibo'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['amiibo'] as List)
            .map((json) => Amiibo.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load amiibos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Get amiibo by head
  static Future<List<Amiibo>> getAmiiboByHead(String head) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/amiibo/?head=$head'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['amiibo'] as List)
            .map((json) => Amiibo.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load amiibos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;


class RMApiService {
  static const _base = 'https://rickandmortyapi.com/api';


  Future<Map<String, dynamic>> getCharactersPage(int page) async {
    final uri = Uri.parse('$_base/character?page=$page');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load page=$page');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }
}
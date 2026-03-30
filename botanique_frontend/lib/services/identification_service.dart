import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class IdentificationService {
  static final String _baseUrl = ApiConstants.baseUrl;

  static Future<List<dynamic>> getHistory(String authToken) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/identification/history'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error fetching history: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception fetching history: $e');
      return [];
    }
  }
}

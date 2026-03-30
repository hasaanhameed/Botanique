import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../schemas/user_schema.dart';

class AuthService {
  static final String _baseUrl = ApiConstants.baseUrl;

  static Future<Map<String, dynamic>> signup(SignUpRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    return jsonDecode(response.body);
  }

  static Future<SignInResponse?> signin(SignInRequest request) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/signin'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );
    final data = jsonDecode(response.body);
    if (data.containsKey('access_token')) {
      return SignInResponse.fromJson(data);
    }
    return null;
  }

  static Future<UserProfile?> getProfile(String authToken) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromJson(data);
    }
    return null;
  }

  static Future<bool> updatePassword(String token, String currentPassword, String newPassword) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/update-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
      }),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteAccount(String token) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/user/delete'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }
}

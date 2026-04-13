import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class PlantService {
  static final String _baseUrl = ApiConstants.baseUrl;

  static Future<Map<String, dynamic>?> identifyPlant(
    XFile imageFile, {
    String? authToken,
  }) async {
    print('PlantService: Starting identification for ${imageFile.name}');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl/plant/identify'),
    );

    if (authToken != null) {
      request.headers['Authorization'] = 'Bearer $authToken';
    }

    print('PlantService: Reading bytes from XFile...');
    final bytes = await imageFile.readAsBytes();

    print('PlantService: Adding multipart file from bytes...');
    request.files.add(
      http.MultipartFile.fromBytes('image', bytes, filename: imageFile.name),
    );

    try {
      print('PlantService: Sending request to $_baseUrl/plant/identify ...');
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 90),
      );
      print(
        'PlantService: Streamed response received: ${streamedResponse.statusCode}',
      );

      final response = await http.Response.fromStream(streamedResponse);
      print('PlantService: Full response received: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 429) {
        print('Rate limit reached');
        return {'error': 'rate_limit'};
      } else {
        print('Error identifying plant: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception identifying plant: $e');
      return null;
    }
  }
}

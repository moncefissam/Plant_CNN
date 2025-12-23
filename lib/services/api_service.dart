import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import '../config/app_config.dart';
import '../models/prediction_result.dart';

/// Service for communicating with the Plant Detection API
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Check if the API is available
  Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.apiBaseUrl}${AppConfig.healthEndpoint}'))
          .timeout(Duration(seconds: AppConfig.connectionTimeout));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Send image bytes to the API for plant prediction
  /// Works cross-platform (web, mobile, desktop)
  Future<PredictionResult> predictPlant({
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    final uri = Uri.parse(
      '${AppConfig.apiBaseUrl}${AppConfig.predictEndpoint}',
    );

    // Create multipart request
    final request = http.MultipartRequest('POST', uri);

    // Determine content type from filename
    String mimeType = 'image/jpeg';
    if (fileName.toLowerCase().endsWith('.png')) {
      mimeType = 'image/png';
    } else if (fileName.toLowerCase().endsWith('.gif')) {
      mimeType = 'image/gif';
    } else if (fileName.toLowerCase().endsWith('.webp')) {
      mimeType = 'image/webp';
    }

    // Add file to request
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      ),
    );

    try {
      final streamedResponse = await request.send().timeout(
        Duration(seconds: AppConfig.receiveTimeout),
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PredictionResult.fromJson(jsonData);
      } else {
        final errorData = json.decode(response.body);
        throw ApiException(
          message: errorData['detail'] ?? 'Unknown error occurred',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Failed to connect to server: ${e.toString()}',
        statusCode: null,
      );
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

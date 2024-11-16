import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/travel.dart';

class TravelService {
  static const String baseUrl = 'http://localhost:3000/api/v1/travels';
  final String? authToken;

  TravelService({this.authToken});

  Future<List<Travel>> getTravel() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Travel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load travels');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  Future<Travel> createTravel(Map<String, dynamic> travelData) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(travelData),
      );

      if (response.statusCode == 201) {
        return Travel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create travel');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  Future<List<Travel>> searchTravels({
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? preferences,
  }) async {
    try {
      final queryParams = <String, String>{};

      if (destination != null) {
        queryParams['destination'] = destination;
      }

      if (startDate != null) {
        queryParams['startDate'] = startDate.toIso8601String();
      }

      if (endDate != null) {
        queryParams['endDate'] = endDate.toIso8601String();
      }

      if (preferences != null && preferences.isNotEmpty) {
        queryParams['preferences'] = preferences.join(',');
      }

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Travel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search travels');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}

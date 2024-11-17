import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/travel.dart';

class TravelService {
  String? _token;
  static const String baseUrl = 'http://localhost:3000/api/v1';

  TravelService({String? token}) : _token = token;

  void updateToken(String? token) {
    _token = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<List<Travel>> searchTravels({
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? preferences,
    int page = 1,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/travels').replace(
          queryParameters: {
            if (destination != null) 'destination': destination,
            if (startDate != null) 'startDate': startDate.toIso8601String(),
            if (endDate != null) 'endDate': endDate.toIso8601String(),
            'page': page.toString(),
          },
        ),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['travels'] as List)
            .map((json) => Travel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load travels');
      }
    } catch (e) {
      throw Exception('Error searching travels: $e');
    }
  }

  Future<Travel> createTravel(Travel travel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/travels'),
        headers: _headers,
        body: json.encode(travel.toJson()),
      );

      if (response.statusCode == 201) {
        return Travel.fromJson(json.decode(response.body));
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to create travel');
      }
    } catch (e) {
      throw Exception('Error creating travel: $e');
    }
  }

  Future<Travel> updateTravel(Travel travel) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/travels/${travel.id}'),
        headers: _headers,
        body: json.encode(travel.toJson()),
      );

      if (response.statusCode == 200) {
        return Travel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update travel');
      }
    } catch (e) {
      throw Exception('Error updating travel: $e');
    }
  }

  Future<List<Travel>> getTravels() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/travels'), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Fetched travels data: $data'); // Add this line
        return (data['travels'] as List)
            .map((json) => Travel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load travels');
      }
    } catch (e) {
      throw Exception('Error fetching travels: $e');
    }
  }

  Future<Map<String, dynamic>> getUserPreferences(String userId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/preferences'),
        headers: _headers);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user preferences');
    }
  }
}

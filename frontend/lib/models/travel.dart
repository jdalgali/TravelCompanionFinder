import '../models/travel_preferences.dart';

class Travel {
  final String id;
  final String title;
  final String description;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int maxCompanions;
  final List<String> currentCompanions;
  final TravelPreferences preferences;
  final String status;
  final String creatorId;
  final DateTime createdAt;

  Travel({
    required this.id,
    required this.title,
    required this.description,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.maxCompanions,
    required this.currentCompanions,
    required this.preferences,
    required this.status,
    required this.creatorId,
    required this.createdAt,
  });

  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      id: json['_id'] ?? '',
      title: json['title'],
      description: json['description'],
      destination: json['destination'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      maxCompanions: json['maxCompanions'],
      currentCompanions: List<String>.from(json['currentCompanions'] ?? []),
      preferences: TravelPreferences.fromJson(json['preferences']),
      status: json['status'],
      creatorId: json['creator'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'maxCompanions': maxCompanions,
      'preferences': preferences.toJson(),
    };
  }
}

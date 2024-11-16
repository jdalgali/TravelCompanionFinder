class Travel {
  final String id;
  final String title;
  final String description;
  final String userId;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int maxCompanions;
  final List<String> preferences;
  final double estimatedCost;
  final List<String> activities;
  final String status; // 'open', 'closed', 'in-progress'
  final List<String> applicants;
  final List<String> acceptedCompanions;
  final DateTime createdAt;

  Travel({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.maxCompanions,
    required this.preferences,
    required this.estimatedCost,
    required this.activities,
    required this.status,
    required this.applicants,
    required this.acceptedCompanions,
    required this.createdAt,
  });

  factory Travel.fromJson(Map<String, dynamic> json) {
    return Travel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['userId'],
      destination: json['destination'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      maxCompanions: json['maxCompanions'],
      preferences: List<String>.from(json['preferences']),
      estimatedCost: json['estimatedCost'].toDouble(),
      activities: List<String>.from(json['activities']),
      status: json['status'],
      applicants: List<String>.from(json['applicants']),
      acceptedCompanions: List<String>.from(json['acceptedCompanions']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'maxCompanions': maxCompanions,
      'preferences': preferences,
      'estimatedCost': estimatedCost,
      'activities': activities,
      'status': status,
      'applicants': applicants,
      'acceptedCompanions': acceptedCompanions,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

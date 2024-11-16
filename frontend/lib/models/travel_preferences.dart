class TravelPreferences {
  final String activityLevel;
  final String budget;
  final List<String> travelStyle;

  TravelPreferences({
    required this.activityLevel,
    required this.budget,
    required this.travelStyle,
  });

  factory TravelPreferences.fromJson(Map<String, dynamic> json) {
    return TravelPreferences(
      activityLevel: json['activityLevel'] ?? '',
      budget: json['budget'] ?? '',
      travelStyle: List<String>.from(json['travelStyle'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityLevel': activityLevel,
      'budget': budget,
      'travelStyle': travelStyle,
    };
  }
}

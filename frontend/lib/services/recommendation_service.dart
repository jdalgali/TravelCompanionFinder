// lib/services/recommendation_service.dart
import 'travel_service.dart';
import '../models/travel.dart';

class RecommendationService {
  final TravelService _travelService;

  RecommendationService(this._travelService);

  Future<List<Travel>> getRecommendedTravels(String userId) async {
    final travels = await _travelService.getTravels();
    final userPreferences = await _travelService.getUserPreferences(userId);

    print('Fetched travels: $travels');
    print('User preferences: $userPreferences');

    // Simple recommendation logic based on matching preferences
    return travels.where((travel) {
      int score = 0;
      if (travel.preferences.activityLevel ==
          userPreferences['activityLevel']) {
        score++;
      }
      if (travel.preferences.budget == userPreferences['budget']) {
        score++;
      }
      if (travel.preferences.travelStyle == userPreferences['travelStyle']) {
        score++;
      }
      return score > 0;
    }).toList();
  }
}

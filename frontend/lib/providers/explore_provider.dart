import 'package:flutter/foundation.dart';
import '../services/recommendation_service.dart';
import '../models/travel.dart';

class ExploreProvider with ChangeNotifier {
  final RecommendationService _recommendationService;
  List<Travel> _recommendedTravels = [];
  bool _isLoading = false;
  String? _error;

  ExploreProvider(this._recommendationService);

  List<Travel> get recommendedTravels => [..._recommendedTravels];
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRecommendedTravels(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('Fetching recommended travels for user: $userId');
      _recommendedTravels =
          await _recommendationService.getRecommendedTravels(userId);
      print('Fetched recommended travels: $_recommendedTravels');
      _error = null;
    } catch (error) {
      _error = error.toString();
      print('Error fetching recommended travels: $_error');
    }

    _isLoading = false;
    notifyListeners();
  }
}

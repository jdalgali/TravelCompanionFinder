import 'package:flutter/foundation.dart';
import '../services/travel_service.dart';
import '../models/travel.dart';

class TravelProvider with ChangeNotifier {
  final TravelService _travelService;
  List<Travel> _travels = [];
  bool _isLoading = false;
  String? _error;

  TravelProvider({required String? token})
      : _travelService = TravelService(token: token);

  List<Travel> get travels => [..._travels];
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Update service token when auth changes
  void updateToken(String? token) {
    _travelService.updateToken(token);
  }

  Future<void> fetchTravels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _travels = await _travelService.searchTravels();
      _error = null;
    } catch (error) {
      _error = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTravel(Travel travel) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newTravel = await _travelService.createTravel(travel);
      _travels.add(newTravel);
      _error = null;
    } catch (error) {
      _error = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchTravels({
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    Map<String, dynamic>? preferences,
    int page = 1,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final travels = await _travelService.searchTravels(
        destination: destination,
        startDate: startDate,
        endDate: endDate,
        preferences: preferences,
        page: page,
      );
      _travels = travels;
      _error = null;
    } catch (error) {
      _error = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTravel(Travel travel) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedTravel = await _travelService.updateTravel(travel);
      final index = _travels.indexWhere((t) => t.id == travel.id);
      if (index >= 0) {
        _travels[index] = updatedTravel;
      }
      _error = null;
    } catch (error) {
      _error = error.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

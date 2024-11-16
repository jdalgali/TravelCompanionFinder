import 'package:flutter/foundation.dart';
import '../models/travel.dart';
import '../services/travel_service.dart';

class TravelProvider with ChangeNotifier {
  final TravelService _travelService;
  List<Travel> _travels = [];
  bool _isLoading = false;
  String? _error;

  TravelProvider(String? authToken)
      : _travelService = TravelService(authToken: authToken);

  List<Travel> get travels => _travels;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTravels() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _travels = await _travelService.getTravel();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createTravel(Map<String, dynamic> travelData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newTravel = await _travelService.createTravel(travelData);
      _travels.add(newTravel);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchTravels({
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? preferences,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _travels = await _travelService.searchTravels(
        destination: destination,
        startDate: startDate,
        endDate: endDate,
        preferences: preferences,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

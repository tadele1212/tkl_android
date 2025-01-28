import 'package:flutter/foundation.dart';
import '../models/service_response.dart';
import '../services/api_service.dart';

class ServiceProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  ServiceResponse? _serviceResponse;
  String? _currentServiceNumber;
  bool _isLoading = false;
  String? _error;

  ServiceResponse? get serviceResponse => _serviceResponse;
  String? get currentServiceNumber => _currentServiceNumber;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadService(String serviceNumber) async {
    _isLoading = true;
    _error = null;
    _currentServiceNumber = serviceNumber;
    notifyListeners();

    try {
      _serviceResponse = await _apiService.getServiceDetails(serviceNumber);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearService() {
    _serviceResponse = null;
    _currentServiceNumber = null;
    _error = null;
    notifyListeners();
  }
} 
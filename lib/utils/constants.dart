import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF007BFF);
  static const Color background = Color(0xFFF0F0F0);
  static const Color error = Color(0xFFDC3545);
  static const Color text = Color(0xFF333333);
}

class ApiConstants {
  static const String baseUrl = 'https://render-test-dc5j.onrender.com';
  static const String healthEndpoint = '/api/health';
  static const String showStopEndpoint = '/api/show_stop';
  static const String nearestStopEndpoint = '/api/nearest_stop';
  static const String locationUpdateEndpoint = '/location/update';
}

class AppConstants {
  static const int locationUpdateInterval = 5; // seconds
  static const Duration cacheExpiration = Duration(hours: 24);
  static const String lastServiceNumberKey = 'last_service_number';
} 
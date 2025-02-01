import 'dart:convert';
import 'dart:async';  // Add this import for TimeoutException
import 'package:http/http.dart' as http;
import '../models/service_response.dart';
import '../models/bus_stop.dart';
import '../utils/constants.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<ServiceResponse> getServiceDetails(String serviceNumber) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.showStopEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_no': serviceNumber,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out. Please check your connection.');
        },
      );

      if (response.statusCode == 200) {
        return ServiceResponse.fromJson(json.decode(response.body));
      } else {
        print('Response body: ${response.body}');
        throw Exception('Server returned status code: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<BusStop?> getNearestStop(double lat, double lng, String serviceNo, String lastStop) async {
    try {
      final response = await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.nearestStopEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_no': serviceNo,
          'gx': lat,
          'gy': lng,
          'last_stop': lastStop,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Bus Stop'] != null) {
          data['Bus_Stop'] = data['Bus Stop'];
        }
        return BusStop.fromJson(data);
      } else {
        print('Response body: ${response.body}');
        throw Exception('Failed to find nearest stop');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<bool> checkHealth() async {
    try {
      final response = await _client.get(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.healthEndpoint}'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    try {
      await _client.post(
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.locationUpdateEndpoint}'),
        body: json.encode({'latitude': latitude, 'longitude': longitude}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      throw Exception('Failed to update location: $e');
    }
  }
}
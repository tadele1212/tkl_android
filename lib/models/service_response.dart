import 'bus_stop.dart';

class ServiceResponse {
  final List<BusStop> stops;

  ServiceResponse({required this.stops});

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      stops: (json['stops'] as List)
          .map((stop) => BusStop.fromJson(stop))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stops': stops.map((stop) => stop.toJson()).toList(),
    };
  }
} 
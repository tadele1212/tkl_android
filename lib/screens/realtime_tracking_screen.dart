import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bus_stop.dart';
import '../services/api_service.dart';
import '../utils/location_service.dart';
import '../utils/constants.dart';
import '../widgets/current_stop_card.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/stops_table_modal.dart';

class RealtimeTrackingScreen extends StatefulWidget {
  final String serviceNumber;

  const RealtimeTrackingScreen({
    super.key,
    required this.serviceNumber,
  });

  @override
  State<RealtimeTrackingScreen> createState() => _RealtimeTrackingScreenState();
}

class _RealtimeTrackingScreenState extends State<RealtimeTrackingScreen> {
  final _locationService = LocationService();
  final _apiService = ApiService();
  Timer? _updateTimer;
  List<BusStop>? _stops;
  BusStop? _currentStop;
  BusStop? _nextStop;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeTracking();
  }

  Future<void> _initializeTracking() async {
    try {
      final response = await _apiService.getServiceDetails(widget.serviceNumber);
      setState(() {
        _stops = response.stops;
        _isLoading = false;
      });
      _startLocationUpdates();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _startLocationUpdates() {
    _updateTimer = Timer.periodic(
      Duration(seconds: AppConstants.locationUpdateInterval),
      (_) => _updateLocation(),
    );
  }

  Future<void> _updateLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      final nearestStop = await _apiService.getNearestStop(
        position.latitude,
        position.longitude,
        widget.serviceNumber,
        _currentStop?.name ?? '',
      );

      if (nearestStop != null) {
        setState(() {
          _currentStop = nearestStop;
          // Find next stop based on sequence
          if (_stops != null) {
            _nextStop = _stops!
                .where((stop) => stop.seq == nearestStop.seq + 1)
                .firstOrNull;
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _showStopsTable() {
    final ScrollController scrollController = ScrollController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (_, controller) => StopsTableModal(
          stops: _stops ?? [],
          controller: scrollController,
          currentStop: _currentStop,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: LoadingSpinner(message: 'Initializing tracking...'),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Service ${widget.serviceNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _showStopsTable,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              if (_currentStop != null)
                CurrentStopCard(stop: _currentStop!),
              if (_nextStop != null)
                CurrentStopCard(
                  stop: _nextStop!,
                  isNext: true,
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: const Text('Stop Tracking'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
} 
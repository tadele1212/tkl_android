import 'package:flutter/material.dart';
import '../models/bus_stop.dart';

class StopsTableModal extends StatelessWidget {
  final List<BusStop> stops;
  final ScrollController controller;
  final BusStop? currentStop;

  const StopsTableModal({
    super.key,
    required this.stops,
    required this.controller,
    this.currentStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: ListView.builder(
        controller: controller,
        itemCount: stops.length,
        itemBuilder: (context, index) {
          final stop = stops[index];
          final isCurrent = currentStop?.seq == stop.seq;
          return ListTile(
            title: Text(stop.name),
            subtitle: Text('Distance: ${stop.km.toStringAsFixed(2)} km'),
            tileColor: isCurrent ? Colors.blue.withOpacity(0.1) : null,
            leading: isCurrent ? const Icon(Icons.location_on, color: Colors.blue) : null,
          );
        },
      ),
    );
  }
} 
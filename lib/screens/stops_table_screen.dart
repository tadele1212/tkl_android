import 'package:flutter/material.dart';
import '../models/bus_stop.dart';
import '../utils/constants.dart';

class StopsTableModal extends StatelessWidget {
  final List<BusStop> stops;
  final BusStop? currentStop;

  const StopsTableModal({
    super.key,
    required this.stops,
    this.currentStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: AppColors.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Route Stops',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: stops.length,
              itemBuilder: (context, index) {
                final stop = stops[index];
                final isCurrentStop = stop.id == currentStop?.id;

                return Container(
                  color: isCurrentStop ? AppColors.primary.withOpacity(0.1) : null,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      stop.name,
                      style: TextStyle(
                        fontWeight:
                            isCurrentStop ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      'Estimated: ${stop.estimatedArrival}',
                      style: TextStyle(
                        color: AppColors.text.withOpacity(0.7),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 
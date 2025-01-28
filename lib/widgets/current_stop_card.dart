import 'package:flutter/material.dart';
import '../models/bus_stop.dart';

class CurrentStopCard extends StatelessWidget {
  final BusStop? stop;
  final bool isNext;

  const CurrentStopCard({
    super.key,
    required this.stop,
    this.isNext = false,
  });

  @override
  Widget build(BuildContext context) {
    if (stop == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current/Next Stop label
            Text(
              isNext ? 'Next Stop' : 'Current Stop',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            
            // Stop Name
            Text(
              stop!.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Sequence Number
                Text(
                  '${stop!.seq}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                
                // Distance
                Text(
                  '${stop!.km.toStringAsFixed(1)} km',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import '../models/bus_stop.dart';
import '../utils/constants.dart';

class StopsTableModal extends StatelessWidget {
  final List<BusStop> stops;
  final ScrollController controller;
  final BusStop? currentStop;
  final String serviceNumber;

  const StopsTableModal({
    super.key,
    required this.stops,
    required this.controller,
    required this.serviceNumber,
    this.currentStop,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: AppColors.primary,
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Bus Service $serviceNumber Route',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    'Seq',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Bus Stop',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'Distance',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: stops.length,
              itemBuilder: (context, index) {
                final stop = stops[index];
                final isCurrent = currentStop?.seq == stop.seq;
                return Container(
                  color: isCurrent ? Colors.blue.withOpacity(0.1) : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(
                            '${stop.seq}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            stop.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text(
                            '${stop.km.toStringAsFixed(1)} km',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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
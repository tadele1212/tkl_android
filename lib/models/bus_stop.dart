class BusStop {
  final int seq;
  final String name;
  final double km;

  BusStop({
    required this.seq,
    required this.name,
    required this.km,
  });

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      seq: json['Seq'] as int,
      name: json['Bus_Stop'] as String,  // or 'Bus Stop' for nearest_stop endpoint
      km: (json['KM'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Seq': seq,
      'Bus_Stop': name,
      'KM': km,
    };
  }
} 
import 'dart:math';

final _random = Random();

/// Simulates network latency for mock data sources (300–600ms).
Future<void> simulateLatency() =>
    Future.delayed(Duration(milliseconds: 300 + _random.nextInt(300)));

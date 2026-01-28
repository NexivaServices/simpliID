import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final batteryProvider = Provider<Battery>((ref) => Battery());

final batteryLevelProvider = FutureProvider<int>((ref) async {
  final battery = ref.watch(batteryProvider);
  return battery.batteryLevel;
});

final batteryStateProvider = StreamProvider<BatteryState>((ref) {
  final battery = ref.watch(batteryProvider);
  return battery.onBatteryStateChanged;
});

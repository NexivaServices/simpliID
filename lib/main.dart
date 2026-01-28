import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'main/app.dart';
import 'core/notifications/local_notifications_service.dart';
import 'core/storage/hive_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initHive();
  await LocalNotificationsService.instance.init();

  // Initialize screenshot prevention
  await _initScreenshotPrevention();

  runApp(const ProviderScope(child: App()));
}

Future<void> _initScreenshotPrevention() async {
  if (Platform.isAndroid) {
    // For Android, use platform channel to set FLAG_SECURE
    try {
      const platform = MethodChannel('com.simpliid.app/screenshot');
      await platform.invokeMethod('enableScreenshotPrevention');
    } catch (e) {
      debugPrint('Failed to enable screenshot prevention on Android: $e');
    }
  }
  // iOS screenshot prevention is handled natively in AppDelegate.swift
}

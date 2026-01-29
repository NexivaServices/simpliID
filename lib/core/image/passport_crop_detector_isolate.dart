import 'dart:io';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

/// Async (non-blocking) ML Kit face detection for passport cropping.
/// 
/// NOTE: ML Kit uses platform channels and CANNOT run in isolates.
/// This class runs on the main thread but uses async/await to avoid blocking.
/// Heavy image processing (crop/encode) happens in isolates separately.
class PassportCropDetectorAsync {
  PassportCropDetectorAsync._();
  
  static final _instance = PassportCropDetectorAsync._();
  static PassportCropDetectorAsync get instance => _instance;

  FaceDetector? _detector;

  FaceDetector get _getDetector {
    return _detector ??= FaceDetector(
      options: FaceDetectorOptions(
        performanceMode: FaceDetectorMode.fast,
        enableContours: false,
        enableLandmarks: false,
        enableTracking: false,
        minFaceSize: 0.12,
      ),
    );
  }

  /// Returns crop rect or null if no face found.
  /// Runs asynchronously on main thread (ML Kit requires platform channels).
  Future<Rect?> suggestCrop({
    required String imagePath,
    double targetAspectRatio = 35 / 45,
    double headTopMarginFactor = 0.45,
    double chinBottomMarginFactor = 0.65,
    double sideMarginFactor = 0.55,
  }) async {
    try {
      debugPrint('🔍 Starting ML Kit face detection for: $imagePath');
      
      // Get image dimensions (lightweight, can run on main thread).
      final bytes = await File(imagePath).readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        debugPrint('❌ Failed to decode image');
        return null;
      }

      final width = decoded.width.toDouble();
      final height = decoded.height.toDouble();
      debugPrint('📐 Image dimensions: ${width}x$height');

      // Run ML Kit face detection (must be on main thread).
      final faces = await _getDetector.processImage(
        InputImage.fromFilePath(imagePath),
      );
      
      debugPrint('👤 Detected ${faces.length} face(s)');
      
      if (faces.isEmpty) {
        debugPrint('⚠️ No faces detected - returning null crop');
        return null;
      }

      // Pick largest face.
      faces.sort(
        (a, b) => (b.boundingBox.width * b.boundingBox.height).compareTo(
          a.boundingBox.width * a.boundingBox.height,
        ),
      );
      final face = faces.first;
      final box = face.boundingBox;
      debugPrint('📦 Face bounding box: $box');

      // Expand face box into a "passport" crop box.
      final left = box.left - box.width * sideMarginFactor;
      final right = box.right + box.width * sideMarginFactor;
      final top = box.top - box.height * headTopMarginFactor;
      final bottom = box.bottom + box.height * chinBottomMarginFactor;

      var crop = Rect.fromLTRB(left, top, right, bottom);
      debugPrint('📏 Initial expanded crop: $crop');

      // Enforce aspect ratio by expanding the smaller dimension.
      crop = _expandToAspect(crop, targetAspectRatio);
      debugPrint('📐 After aspect ratio adjustment: $crop');

      // Clamp to image.
      crop = _clampToBounds(crop, width: width, height: height);
      debugPrint('🔒 After clamping to bounds: $crop');

      // If clamping broke aspect too much, do a final adjust inside bounds.
      crop = _fitAspectInsideBounds(
        crop,
        width: width,
        height: height,
        aspect: targetAspectRatio,
      );
      debugPrint('✅ Final passport crop rect: $crop');

      return crop;
    } catch (e) {
      debugPrint('❌ ML Kit face detection error: $e');
      return null;
    }
  }

  Future<void> dispose() async {
    await _detector?.close();
    _detector = null;
  }
}

Rect _expandToAspect(Rect rect, double aspect) {
  final w = rect.width;
  final h = rect.height;
  final current = w / h;

  if ((current - aspect).abs() < 0.0001) {
    return rect;
  }

  if (current < aspect) {
    // Too tall/narrow -> expand width.
    final targetW = h * aspect;
    final delta = (targetW - w) / 2;
    return Rect.fromLTRB(
      rect.left - delta,
      rect.top,
      rect.right + delta,
      rect.bottom,
    );
  } else {
    // Too wide -> expand height.
    final targetH = w / aspect;
    final delta = (targetH - h) / 2;
    return Rect.fromLTRB(
      rect.left,
      rect.top - delta,
      rect.right,
      rect.bottom + delta,
    );
  }
}

Rect _clampToBounds(
  Rect rect, {
  required double width,
  required double height,
}) {
  final left = rect.left.clamp(0.0, width);
  final top = rect.top.clamp(0.0, height);
  final right = rect.right.clamp(0.0, width);
  final bottom = rect.bottom.clamp(0.0, height);

  final clamped = Rect.fromLTRB(left, top, max(left, right), max(top, bottom));
  if (clamped.width < 2 || clamped.height < 2) {
    return Rect.fromLTWH(0, 0, width, height);
  }
  return clamped;
}

Rect _fitAspectInsideBounds(
  Rect rect, {
  required double width,
  required double height,
  required double aspect,
}) {
  var crop = rect;

  // Ensure crop is within bounds.
  crop = _clampToBounds(crop, width: width, height: height);

  // Fit aspect by shrinking (never expanding outside bounds).
  final current = crop.width / crop.height;
  if ((current - aspect).abs() < 0.0001) {
    return crop;
  }

  if (current > aspect) {
    // Too wide, shrink width.
    final targetW = crop.height * aspect;
    final dx = (crop.width - targetW) / 2;
    return Rect.fromLTRB(
      crop.left + dx,
      crop.top,
      crop.right - dx,
      crop.bottom,
    );
  } else {
    // Too tall, shrink height.
    final targetH = crop.width / aspect;
    final dy = (crop.height - targetH) / 2;
    return Rect.fromLTRB(
      crop.left,
      crop.top + dy,
      crop.right,
      crop.bottom - dy,
    );
  }
}

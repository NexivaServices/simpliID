import 'dart:math';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

/// Suggests a passport-style crop rectangle using on-device ML Kit face detection.
///
/// This is intentionally fast and offline-friendly:
/// - Detects the largest face
/// - Builds a crop rect around it
/// - Enforces an aspect ratio (default: 35x45mm ~= 0.777...)
/// - Clamps to the image bounds
class PassportCropDetector {
  PassportCropDetector({FaceDetectorOptions? options})
      : _detector = FaceDetector(
          options: options ??
              FaceDetectorOptions(
                performanceMode: FaceDetectorMode.fast,
                enableContours: false,
                enableLandmarks: false,
                enableTracking: false,
                minFaceSize: 0.12,
              ),
        );

  final FaceDetector _detector;

  Future<void> dispose() => _detector.close();

  /// Returns a crop rectangle in image pixel coordinates.
  ///
  /// If no face is found, returns null.
  Future<Rect?> suggestCrop({
    required String imagePath,
    double targetAspectRatio = 35 / 45,
    double headTopMarginFactor = 0.45,
    double chinBottomMarginFactor = 0.65,
    double sideMarginFactor = 0.55,
  }) async {
    final bytes = await File(imagePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return null;
    }

    final width = decoded.width.toDouble();
    final height = decoded.height.toDouble();

    final faces = await _detector.processImage(InputImage.fromFilePath(imagePath));
    if (faces.isEmpty) {
      return null;
    }

    // Pick largest face.
    faces.sort((a, b) => (b.boundingBox.width * b.boundingBox.height).compareTo(a.boundingBox.width * a.boundingBox.height));
    final face = faces.first;
    final box = face.boundingBox;

    // Expand face box into a "passport" crop box.
    // Rough heuristic: more space above head and below chin.
    final left = box.left - box.width * sideMarginFactor;
    final right = box.right + box.width * sideMarginFactor;
    final top = box.top - box.height * headTopMarginFactor;
    final bottom = box.bottom + box.height * chinBottomMarginFactor;

    var crop = Rect.fromLTRB(left, top, right, bottom);

    // Enforce aspect ratio by expanding the smaller dimension.
    crop = _expandToAspect(crop, targetAspectRatio);

    // Clamp to image.
    crop = _clampToBounds(crop, width: width, height: height);

    // If clamping broke aspect too much, do a final adjust inside bounds.
    crop = _fitAspectInsideBounds(crop, width: width, height: height, aspect: targetAspectRatio);

    return crop;
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
    return Rect.fromLTRB(rect.left - delta, rect.top, rect.right + delta, rect.bottom);
  } else {
    // Too wide -> expand height.
    final targetH = w / aspect;
    final delta = (targetH - h) / 2;
    return Rect.fromLTRB(rect.left, rect.top - delta, rect.right, rect.bottom + delta);
  }
}

Rect _clampToBounds(Rect rect, {required double width, required double height}) {
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

Rect _fitAspectInsideBounds(Rect rect, {required double width, required double height, required double aspect}) {
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
    return Rect.fromLTRB(crop.left + dx, crop.top, crop.right - dx, crop.bottom);
  } else {
    // Too tall, shrink height.
    final targetH = crop.width / aspect;
    final dy = (crop.height - targetH) / 2;
    return Rect.fromLTRB(crop.left, crop.top + dy, crop.right, crop.bottom - dy);
  }
}

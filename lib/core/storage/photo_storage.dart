import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class PhotoStorage {
  static const _photoKeyName = 'photo_aes_key_b64';

  Future<Uint8List>? _photoKeyFuture;

  Future<Directory> _baseDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${dir.path}/photos');
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    return photosDir;
  }

  Future<Directory> _orderDir(String orderId) async {
    final base = await _baseDir();
    final orderDir = Directory('${base.path}/$orderId');
    if (!await orderDir.exists()) {
      await orderDir.create(recursive: true);
    }
    return orderDir;
  }

  Future<Uint8List> _getOrCreatePhotoEncryptionKey() {
    return _photoKeyFuture ??= () async {
      const storage = FlutterSecureStorage();
      final existing = await storage.read(key: _photoKeyName);
      if (existing != null) {
        return Uint8List.fromList(base64Decode(existing));
      }

      // 256-bit key.
      final key = encrypt.Key.fromSecureRandom(32);
      await storage.write(key: _photoKeyName, value: base64Encode(key.bytes));
      return Uint8List.fromList(key.bytes);
    }();
  }

  /// Schedules a background job that compresses and encrypts the JPEG at rest.
  ///
  /// The returned path is where the encrypted file will be written.
  /// This is intended to keep the UI responsive; you typically should not await it.
  Future<String> scheduleCompressAndEncrypt({
    required String orderId,
    required String studentId,
    required String inputJpgPath,
    int maxLongSide = 1200,
    int jpegQuality = 85,
  }) async {
    final orderDir = await _orderDir(orderId);
    final outputPath = '${orderDir.path}/${studentId}_high.enc';
    final key = await _getOrCreatePhotoEncryptionKey();

    // Fire-and-forget isolate work.
    // ignore: discarded_futures
    compute(_compressAndEncryptToFile, <String, dynamic>{
      'inputJpgPath': inputJpgPath,
      'outputEncPath': outputPath,
      'key': key,
      'maxLongSide': maxLongSide,
      'jpegQuality': jpegQuality,
    });

    return outputPath;
  }

  /// A UI-friendly variant of [writePassportPhotosFromFile] that offloads
  /// decode/crop/encode work to a background isolate.
  Future<({String highResPath, String thumbnailPath})>
  writePassportPhotosFromFileBackground({
    required String orderId,
    required String studentId,
    required String sourceImagePath,
    Rect? crop,
    double targetAspectRatio = 35 / 45,
    int highQuality = 92,
    int thumbnailWidth = 200,
    int thumbnailQuality = 70,
  }) async {
    final orderDir = await _orderDir(orderId);
    final bytes = await File(sourceImagePath).readAsBytes();

    final cropMap = (crop == null)
        ? null
        : <String, double>{
            'left': crop.left,
            'top': crop.top,
            'right': crop.right,
            'bottom': crop.bottom,
          };

    final encoded = await compute(_cropAndEncodePassportPhotos, {
      'bytes': bytes,
      'crop': cropMap,
      'aspect': targetAspectRatio,
      'highQuality': highQuality,
      'thumbnailWidth': thumbnailWidth,
      'thumbnailQuality': thumbnailQuality,
    });

    final highResPath = '${orderDir.path}/${studentId}_high.jpg';
    final thumbnailPath = '${orderDir.path}/${studentId}_thumb.jpg';

    await File(highResPath).writeAsBytes(encoded.highBytes, flush: true);
    await File(thumbnailPath).writeAsBytes(encoded.thumbBytes, flush: true);

    return (highResPath: highResPath, thumbnailPath: thumbnailPath);
  }

  /// Writes a passport-style cropped photo and a thumbnail.
  ///
  /// If [crop] is null, it falls back to a centered crop using [targetAspectRatio].
  Future<({String highResPath, String thumbnailPath})>
  writePassportPhotosFromFile({
    required String orderId,
    required String studentId,
    required String sourceImagePath,
    Rect? crop,
    double targetAspectRatio = 35 / 45,
    int highQuality = 92,
    int thumbnailWidth = 200,
    int thumbnailQuality = 70,
  }) async {
    final orderDir = await _orderDir(orderId);
    final bytes = await File(sourceImagePath).readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw StateError('Failed to decode captured image');
    }

    final safeCrop = _resolveCrop(
      crop,
      width: decoded.width,
      height: decoded.height,
      aspect: targetAspectRatio,
    );

    final cropped = img.copyCrop(
      decoded,
      x: safeCrop.left.toInt(),
      y: safeCrop.top.toInt(),
      width: safeCrop.width.toInt(),
      height: safeCrop.height.toInt(),
    );

    final thumb = img.copyResize(cropped, width: thumbnailWidth);

    final highBytes = Uint8List.fromList(
      img.encodeJpg(cropped, quality: highQuality),
    );
    final thumbBytes = Uint8List.fromList(
      img.encodeJpg(thumb, quality: thumbnailQuality),
    );

    final highResPath = '${orderDir.path}/${studentId}_high.jpg';
    final thumbnailPath = '${orderDir.path}/${studentId}_thumb.jpg';

    await File(highResPath).writeAsBytes(highBytes, flush: true);
    await File(thumbnailPath).writeAsBytes(thumbBytes, flush: true);

    return (highResPath: highResPath, thumbnailPath: thumbnailPath);
  }

  Future<void> overwritePhotosFromEditedBytes({
    required String highResPath,
    required String thumbnailPath,
    required Uint8List editedBytes,
    int highQuality = 92,
    int thumbnailWidth = 200,
    int thumbnailQuality = 70,
  }) async {
    final decoded = img.decodeImage(editedBytes);
    if (decoded == null) {
      throw StateError('Failed to decode edited image');
    }

    final highBytes = Uint8List.fromList(
      img.encodeJpg(decoded, quality: highQuality),
    );
    final thumb = img.copyResize(decoded, width: thumbnailWidth);
    final thumbBytes = Uint8List.fromList(
      img.encodeJpg(thumb, quality: thumbnailQuality),
    );

    await File(highResPath).writeAsBytes(highBytes, flush: true);
    await File(thumbnailPath).writeAsBytes(thumbBytes, flush: true);
  }

  /// UI-friendly overwrite that offloads recompress + thumbnail to an isolate.
  Future<void> overwritePhotosFromEditedBytesBackground({
    required String highResPath,
    required String thumbnailPath,
    required Uint8List editedBytes,
    int highQuality = 92,
    int thumbnailWidth = 200,
    int thumbnailQuality = 70,
  }) async {
    final encoded = await compute(_encodeHighAndThumbFromBytes, {
      'bytes': editedBytes,
      'highQuality': highQuality,
      'thumbnailWidth': thumbnailWidth,
      'thumbnailQuality': thumbnailQuality,
    });

    await File(highResPath).writeAsBytes(encoded.highBytes, flush: true);
    await File(thumbnailPath).writeAsBytes(encoded.thumbBytes, flush: true);
  }

  Future<({String highResPath, String thumbnailPath})> writeDummyPhotos({
    required String orderId,
    required String studentId,
  }) async {
    final orderDir = await _orderDir(orderId);

    final highRes = img.Image(width: 1200, height: 1600);
    img.fill(highRes, color: img.ColorRgb8(240, 240, 240));

    final thumb = img.copyResize(highRes, width: 200);

    final highBytes = Uint8List.fromList(img.encodeJpg(highRes, quality: 92));
    final thumbBytes = Uint8List.fromList(img.encodeJpg(thumb, quality: 70));

    final highResPath = '${orderDir.path}/${studentId}_high.jpg';
    final thumbnailPath = '${orderDir.path}/${studentId}_thumb.jpg';

    await File(highResPath).writeAsBytes(highBytes, flush: true);
    await File(thumbnailPath).writeAsBytes(thumbBytes, flush: true);

    return (highResPath: highResPath, thumbnailPath: thumbnailPath);
  }

  Future<String> readFileBase64(String path) async {
    final bytes = await File(path).readAsBytes();
    return base64Encode(bytes);
  }
}

/// Top-level for `compute`.
Future<void> _compressAndEncryptToFile(Map<String, dynamic> args) async {
  final inputJpgPath = args['inputJpgPath'] as String;
  final outputEncPath = args['outputEncPath'] as String;
  final keyBytes = args['key'] as Uint8List;
  final maxLongSide = (args['maxLongSide'] as int?) ?? 1200;
  final jpegQuality = (args['jpegQuality'] as int?) ?? 85;

  final inputBytes = await File(inputJpgPath).readAsBytes();
  final decoded = img.decodeImage(inputBytes);
  if (decoded == null) {
    return;
  }

  img.Image working = decoded;
  final longSide = working.width > working.height
      ? working.width
      : working.height;
  if (longSide > maxLongSide) {
    if (working.width >= working.height) {
      working = img.copyResize(working, width: maxLongSide);
    } else {
      working = img.copyResize(working, height: maxLongSide);
    }
  }

  final compressedJpg = Uint8List.fromList(
    img.encodeJpg(working, quality: jpegQuality),
  );

  // AES-GCM encrypt; write as: 4-byte magic + 12-byte nonce + ciphertext.
  final key = encrypt.Key(keyBytes);
  final iv = encrypt.IV.fromSecureRandom(12);
  final encrypter = encrypt.Encrypter(
    encrypt.AES(key, mode: encrypt.AESMode.gcm),
  );
  final encrypted = encrypter.encryptBytes(compressedJpg, iv: iv);

  final out = BytesBuilder(copy: false)
    ..add([0x53, 0x49, 0x44, 0x31])
    ..add(iv.bytes)
    ..add(encrypted.bytes);

  await File(outputEncPath).writeAsBytes(out.takeBytes(), flush: true);
}

typedef _EncodedPhotos = ({Uint8List highBytes, Uint8List thumbBytes});

/// Top-level for `compute`: decode/crop/encode (passport) in an isolate.
Future<_EncodedPhotos> _cropAndEncodePassportPhotos(
  Map<String, dynamic> args,
) async {
  final bytes = args['bytes'] as Uint8List;
  final crop = args['crop'] as Map<String, dynamic>?;
  final aspect = (args['aspect'] as num).toDouble();
  final highQuality = (args['highQuality'] as int?) ?? 92;
  final thumbnailWidth = (args['thumbnailWidth'] as int?) ?? 200;
  final thumbnailQuality = (args['thumbnailQuality'] as int?) ?? 70;

  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw StateError('Failed to decode captured image');
  }

  final resolved = _resolveCropPrimitive(
    crop,
    width: decoded.width,
    height: decoded.height,
    aspect: aspect,
  );

  final cropped = img.copyCrop(
    decoded,
    x: resolved.$1,
    y: resolved.$2,
    width: resolved.$3,
    height: resolved.$4,
  );
  final thumb = img.copyResize(cropped, width: thumbnailWidth);

  final highBytes = Uint8List.fromList(
    img.encodeJpg(cropped, quality: highQuality),
  );
  final thumbBytes = Uint8List.fromList(
    img.encodeJpg(thumb, quality: thumbnailQuality),
  );

  return (highBytes: highBytes, thumbBytes: thumbBytes);
}

/// Top-level for `compute`: recompress + thumbnail in an isolate.
Future<_EncodedPhotos> _encodeHighAndThumbFromBytes(
  Map<String, dynamic> args,
) async {
  final bytes = args['bytes'] as Uint8List;
  final highQuality = (args['highQuality'] as int?) ?? 92;
  final thumbnailWidth = (args['thumbnailWidth'] as int?) ?? 200;
  final thumbnailQuality = (args['thumbnailQuality'] as int?) ?? 70;

  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw StateError('Failed to decode edited image');
  }

  final highBytes = Uint8List.fromList(
    img.encodeJpg(decoded, quality: highQuality),
  );
  final thumb = img.copyResize(decoded, width: thumbnailWidth);
  final thumbBytes = Uint8List.fromList(
    img.encodeJpg(thumb, quality: thumbnailQuality),
  );

  return (highBytes: highBytes, thumbBytes: thumbBytes);
}

/// Returns (x, y, w, h) as ints within bounds and matching [aspect].
(int, int, int, int) _resolveCropPrimitive(
  Map<String, dynamic>? crop, {
  required int width,
  required int height,
  required double aspect,
}) {
  double left;
  double top;
  double right;
  double bottom;

  if (crop == null) {
    final center = _centerCropPrimitive(
      width: width,
      height: height,
      aspect: aspect,
    );
    left = center.$1;
    top = center.$2;
    right = center.$3;
    bottom = center.$4;
  } else {
    left = (crop['left'] as num).toDouble();
    top = (crop['top'] as num).toDouble();
    right = (crop['right'] as num).toDouble();
    bottom = (crop['bottom'] as num).toDouble();
  }

  // Clamp to bounds.
  left = left.clamp(0.0, width.toDouble());
  top = top.clamp(0.0, height.toDouble());
  right = right.clamp(0.0, width.toDouble());
  bottom = bottom.clamp(0.0, height.toDouble());

  // Ensure sane rect.
  if (right - left < 2 || bottom - top < 2) {
    left = 0;
    top = 0;
    right = width.toDouble();
    bottom = height.toDouble();
  }

  // Enforce aspect by shrinking within the rect.
  final w = right - left;
  final h = bottom - top;
  final current = w / h;
  if ((current - aspect).abs() >= 0.0001) {
    if (current > aspect) {
      final targetW = h * aspect;
      final dx = (w - targetW) / 2;
      left += dx;
      right -= dx;
    } else {
      final targetH = w / aspect;
      final dy = (h - targetH) / 2;
      top += dy;
      bottom -= dy;
    }
  }

  // Convert to ints and re-clamp.
  var x = left.round().clamp(0, width - 1);
  var y = top.round().clamp(0, height - 1);
  var cw = (right - left).round().clamp(1, width - x);
  var ch = (bottom - top).round().clamp(1, height - y);

  // Final aspect correction if rounding drifted.
  final rc = cw / ch;
  if ((rc - aspect).abs() > 0.01) {
    if (rc > aspect) {
      final targetW = (ch * aspect).round().clamp(1, width - x);
      final dx = ((cw - targetW) / 2).round();
      x = (x + dx).clamp(0, width - 1);
      cw = targetW.clamp(1, width - x);
    } else {
      final targetH = (cw / aspect).round().clamp(1, height - y);
      final dy = ((ch - targetH) / 2).round();
      y = (y + dy).clamp(0, height - 1);
      ch = targetH.clamp(1, height - y);
    }
  }

  return (x, y, cw, ch);
}

(double, double, double, double) _centerCropPrimitive({
  required int width,
  required int height,
  required double aspect,
}) {
  final w = width.toDouble();
  final h = height.toDouble();
  final current = w / h;
  if (current > aspect) {
    final targetW = h * aspect;
    final left = (w - targetW) / 2;
    return (left, 0, left + targetW, h);
  } else {
    final targetH = w / aspect;
    final top = (h - targetH) / 2;
    return (0, top, w, top + targetH);
  }
}

Rect _resolveCrop(
  Rect? crop, {
  required int width,
  required int height,
  required double aspect,
}) {
  Rect c = crop ?? _centerCrop(width: width, height: height, aspect: aspect);

  // Clamp to bounds.
  final left = c.left.clamp(0.0, width.toDouble());
  final top = c.top.clamp(0.0, height.toDouble());
  final right = c.right.clamp(0.0, width.toDouble());
  final bottom = c.bottom.clamp(0.0, height.toDouble());
  c = Rect.fromLTRB(left, top, right, bottom);

  // Ensure minimum size.
  if (c.width < 2 || c.height < 2) {
    c = Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble());
  }

  // Ensure aspect by shrinking within the rect.
  final current = c.width / c.height;
  if ((current - aspect).abs() < 0.0001) return c;
  if (current > aspect) {
    final targetW = c.height * aspect;
    final dx = (c.width - targetW) / 2;
    return Rect.fromLTRB(c.left + dx, c.top, c.right - dx, c.bottom);
  } else {
    final targetH = c.width / aspect;
    final dy = (c.height - targetH) / 2;
    return Rect.fromLTRB(c.left, c.top + dy, c.right, c.bottom - dy);
  }
}

Rect _centerCrop({
  required int width,
  required int height,
  required double aspect,
}) {
  final w = width.toDouble();
  final h = height.toDouble();
  final current = w / h;
  if (current > aspect) {
    // Too wide: crop width.
    final targetW = h * aspect;
    final left = (w - targetW) / 2;
    return Rect.fromLTWH(left, 0, targetW, h);
  } else {
    // Too tall: crop height.
    final targetH = w / aspect;
    final top = (h - targetH) / 2;
    return Rect.fromLTWH(0, top, w, targetH);
  }
}

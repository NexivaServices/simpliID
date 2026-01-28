import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Lossless “compression” via PNG re-encode with max zlib level.
///
/// This keeps pixels identical but can reduce file size for some PNGs.
Uint8List losslessPngReencode(Uint8List bytes, {int level = 9}) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    throw const FormatException('Unsupported image format');
  }

  return Uint8List.fromList(img.encodePng(decoded, level: level));
}

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:image_background_remover/image_background_remover.dart';

import '../providers/capture_providers.dart';
import 'capture_photo_flow.dart';

class CapturePhotoPreviewPage extends HookConsumerWidget {
  const CapturePhotoPreviewPage({
    super.key,
    required this.studentName,
    required this.orderId,
    required this.studentId,
    required this.sourceImagePath,
    this.suggestedCrop,
    this.backgroundColor = Colors.white,
  });

  final String studentName;
  final String orderId;
  final String studentId;
  final String sourceImagePath;
  final Rect? suggestedCrop;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saving = useState(false);
    final processing = useState(true);
    final removingBackground = useState(false);
    final highResPath = useState<String?>(null);
    final thumbnailPath = useState<String?>(null);
    final error = useState<String?>(null);
    final originalHighResPath = useState<String?>(null);
    final backgroundRemoved = useState(false);

    Future<void> processImage() async {
      processing.value = true;
      error.value = null;

      try {
        final photoStorage = ref.read(photoStorageProvider);
        final photos = await photoStorage.writePassportPhotosFromFileBackground(
          orderId: orderId,
          studentId: studentId,
          sourceImagePath: sourceImagePath,
          crop: suggestedCrop,
        );

        highResPath.value = photos.highResPath;
        thumbnailPath.value = photos.thumbnailPath;
        processing.value = false;
      } catch (e) {
        error.value = e.toString();
        processing.value = false;
      }
    }

    useEffect(() {
      BackgroundRemover.instance.initializeOrt();
      processImage();
      return () {
        if (backgroundRemoved.value && originalHighResPath.value != null) {
          try {
            File(originalHighResPath.value!).deleteSync();
          } catch (_) {}
        }
        BackgroundRemover.instance.dispose();
      };
    }, []);

    Future<void> applyBackgroundRemoval() async {
      if (highResPath.value == null) return;

      removingBackground.value = true;

      try {
        final imageFile = File(highResPath.value!);
        final originalBytes = await imageFile.readAsBytes();

        final resultImage = await BackgroundRemover.instance.removeBg(originalBytes);

        final byteData = await resultImage.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) throw Exception('Failed to convert image to bytes');
        final pngBytes = byteData.buffer.asUint8List();

        final finalBytes = await BackgroundRemover.instance.addBackground(
          image: pngBytes,
          bgColor: Colors.red,
        );

        if (!backgroundRemoved.value) {
          originalHighResPath.value = highResPath.value;
        }
        
        final dir = imageFile.parent;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final tempFile = File('${dir.path}/temp_bg_removed_$timestamp.jpg');
        
        await tempFile.writeAsBytes(finalBytes);

        final oldPath = highResPath.value;
        highResPath.value = tempFile.path;
        backgroundRemoved.value = true;

        if (oldPath != null) {
          FileImage(File(oldPath)).evict();
        }

        final photoStorage = ref.read(photoStorageProvider);
        await photoStorage.overwritePhotosFromEditedBytesBackground(
          highResPath: highResPath.value!,
          thumbnailPath: thumbnailPath.value!,
          editedBytes: finalBytes,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Background removed (tap Undo to revert)'),
              backgroundColor: Colors.green.shade700,
              action: SnackBarAction(
                label: 'Undo',
                textColor: Colors.white,
                onPressed: () {
                  if (originalHighResPath.value != null && backgroundRemoved.value) {
                    try {
                      File(highResPath.value!).deleteSync();
                    } catch (_) {}

                    highResPath.value = originalHighResPath.value;
                    backgroundRemoved.value = false;
                    originalHighResPath.value = null;

                    FileImage(File(highResPath.value!)).evict();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Background removal reverted'),
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Background removal failed: $e'),
              backgroundColor: Colors.red.shade700,
            ),
          );
        }
      } finally {
        removingBackground.value = false;
      }
    }

    Future<void> usePhoto() async {
      if (highResPath.value == null || thumbnailPath.value == null) return;

      saving.value = true;

      try {
        if (backgroundRemoved.value && originalHighResPath.value != null) {
          try {
            File(originalHighResPath.value!).deleteSync();
            originalHighResPath.value = null;
          } catch (_) {}
        }

        final photoStorage = ref.read(photoStorageProvider);
        
        await photoStorage.scheduleCompressAndEncrypt(
          orderId: orderId,
          studentId: studentId,
          inputJpgPath: highResPath.value!,
          maxLongSide: 1200,
          jpegQuality: 85,
        );

        await photoStorage.scheduleCompressAndEncrypt(
          orderId: orderId,
          studentId: '${studentId}_compressed',
          inputJpgPath: highResPath.value!,
          maxLongSide: 800,
          jpegQuality: 75,
        );

        if (!context.mounted) return;

        Navigator.of(context).pop(
          CapturePhotoResult(
            highResPath: highResPath.value!,
            thumbnailPath: thumbnailPath.value!,
            crop: suggestedCrop,
            absent: false,
          ),
        );
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to process photo: $e')),
        );
      } finally {
        saving.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Preview \u2022 $studentName'),

      ),
      body: Stack(
        children: [
          if (processing.value)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(height: 16),
                  Text('Processing image...'),
                ],
              ),
            )
          else if (error.value != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Processing failed:\n${error.value}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: processImage,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (highResPath.value != null)
            Center(
              child: AspectRatio(
                aspectRatio: 35 / 45,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.file(
                    File(highResPath.value!),
                    fit: BoxFit.cover,
                    key: ValueKey(highResPath.value! + DateTime.now().millisecondsSinceEpoch.toString()),
                  ),
                ),
              ),
            ),
          if (saving.value || removingBackground.value)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator.adaptive(),
                    const SizedBox(height: 16),
                    Text(
                      removingBackground.value ? 'Removing background...' : 'Saving...',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: processing.value || error.value != null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (backgroundColor != Colors.transparent)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: saving.value || removingBackground.value
                                ? null
                                : applyBackgroundRemoval,
                            icon: removingBackground.value
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.auto_fix_high),
                            label: Text(removingBackground.value
                                ? 'Removing background...'
                                : 'Remove Background'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue,
                              side: const BorderSide(color: Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: saving.value || removingBackground.value
                                ? null
                                : () {
                                    Navigator.of(context).pop(null);
                                  },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Retake'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: saving.value || removingBackground.value ? null : usePhoto,
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Use photo'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class EditorPage extends HookConsumerWidget {
  const EditorPage({
    super.key,
    required this.filePath,
    required this.studentName,
    required this.orderId,
    required this.studentId,
    required this.suggestedCrop,
  });

  final String filePath;
  final String studentName;
  final String orderId;
  final String studentId;
  final Rect? suggestedCrop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final removingBackground = useState(false);
    final currentImagePath = useState<String?>(filePath);
    final originalImagePath = useState<String?>(filePath);
    final backgroundRemoved = useState(false);
    final selectedBgColor = useState<Color>(Colors.white);

    useEffect(() {
      BackgroundRemover.instance.initializeOrt();
      return () {
        if (backgroundRemoved.value && currentImagePath.value != originalImagePath.value) {
          try {
            File(currentImagePath.value!).deleteSync();
          } catch (_) {}
        }
        BackgroundRemover.instance.dispose();
      };
    }, []);

    Future<void> removeBackground() async {
      final selectedColor = await showDialog<Color>(
        context: context,
        builder: (context) => _BackgroundColorPickerDialog(
          initialColor: selectedBgColor.value,
        ),
      );

      if (selectedColor == null) return;

      selectedBgColor.value = selectedColor;
      removingBackground.value = true;

      try {
        final imageFile = File(currentImagePath.value!);
        final originalBytes = await imageFile.readAsBytes();

        final resultImage = await BackgroundRemover.instance.removeBg(originalBytes);

        final byteData = await resultImage.toByteData(format: ui.ImageByteFormat.png);
        if (byteData == null) throw Exception('Failed to convert image to bytes');
        final pngBytes = byteData.buffer.asUint8List();

        final finalBytes = await BackgroundRemover.instance.addBackground(
          image: pngBytes,
          bgColor: selectedBgColor.value,
        );

        final tempFile = File('${currentImagePath.value!}_bg_removed_${DateTime.now().millisecondsSinceEpoch}.jpg');
        await tempFile.writeAsBytes(finalBytes);

        currentImagePath.value = tempFile.path;
        backgroundRemoved.value = true;

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Background removed'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Background removal failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        removingBackground.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Photo'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop({
              'retake': true,
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_fix_high),
            tooltip: 'Remove Background',
            onPressed: removingBackground.value ? null : removeBackground,
          ),
        ],
      ),
      body: Stack(
        children: [
          ProImageEditor.file(
            currentImagePath.value!,
            key: ValueKey(currentImagePath.value),
            callbacks: ProImageEditorCallbacks(
              onImageEditingComplete: (Uint8List bytes) async {
                Navigator.of(context).pop({
                  'bytes': bytes,
                  'retake': false,
                });
              },
              removeBackground: removeBackground,
            ),
          ),
          if (removingBackground.value)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator.adaptive(),
                    SizedBox(height: 16),
                    Text(
                      'Removing background...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Background color picker dialog with quick colors and custom color picker
class _BackgroundColorPickerDialog extends HookWidget {
  const _BackgroundColorPickerDialog({
    required this.initialColor,
  });

  final Color initialColor;

  static final List<Color> _quickColors = [
    Colors.white,
    const Color(0xFFE3F2FD),
    const Color(0xFFF5F5F5),
    const Color(0xFF90CAF9),
    const Color(0xFFE1F5FE),
    const Color(0xFFFFEBEE),
    const Color(0xFFFFF3E0),
    const Color(0xFFF1F8E9),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedColor = useState(initialColor);

    void showCustomColorPicker() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pick Custom Color'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ColorSlider(
                  label: 'Red',
                  value: (selectedColor.value.r * 255.0).round(),
                  color: Colors.red,
                  onChanged: (value) {
                    selectedColor.value = Color.fromARGB(
                      255,
                      value.round(),
                      (selectedColor.value.g * 255.0).round(),
                      (selectedColor.value.b * 255.0).round(),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ColorSlider(
                  label: 'Green',
                  value: (selectedColor.value.g * 255.0).round(),
                  color: Colors.green,
                  onChanged: (value) {
                    selectedColor.value = Color.fromARGB(
                      255,
                      (selectedColor.value.r * 255.0).round(),
                      value.round(),
                      (selectedColor.value.b * 255.0).round(),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _ColorSlider(
                  label: 'Blue',
                  value: (selectedColor.value.b * 255.0).round(),
                  color: Colors.blue,
                  onChanged: (value) {
                    selectedColor.value = Color.fromARGB(
                      255,
                      (selectedColor.value.r * 255.0).round(),
                      (selectedColor.value.g * 255.0).round(),
                      value.round(),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: selectedColor.value,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    }
    return AlertDialog(
      title: const Text('Select Background Color'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Colors',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _quickColors.map((color) {
                final isSelected = selectedColor.value == color;
                return GestureDetector(
                  onTap: () => selectedColor.value = color,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: isSelected ? 3 : 2,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                      ],
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                            size: 24,
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            // Custom color picker button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: showCustomColorPicker,
                icon: const Icon(Icons.color_lens),
                label: const Text('Custom Color'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Selected: ',
                  style: TextStyle(fontSize: 14),
                ),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: selectedColor.value,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(selectedColor.value),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

/// Color slider widget for RGB values
class _ColorSlider extends StatelessWidget {
  const _ColorSlider({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  final String label;
  final int value;
  final Color color;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.3),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 255,
            divisions: 255,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

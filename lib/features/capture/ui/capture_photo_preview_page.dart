import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:image_background_remover/image_background_remover.dart';

import '../providers/capture_providers.dart';
import 'capture_photo_flow.dart';

class CapturePhotoPreviewPage extends ConsumerStatefulWidget {
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
  ConsumerState<CapturePhotoPreviewPage> createState() =>
      _CapturePhotoPreviewPageState();
}

class _CapturePhotoPreviewPageState
    extends ConsumerState<CapturePhotoPreviewPage> {
  bool _saving = false;
  bool _processing = true;
  bool _removingBackground = false;
  String? _highResPath;
  String? _thumbnailPath;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Initialize ONNX runtime for background removal
    BackgroundRemover.instance.initializeOrt();
    _processImage();
  }

  @override
  void dispose() {
    BackgroundRemover.instance.dispose();
    super.dispose();
  }

  /// Process image in background isolate (crop/encode).
  Future<void> _processImage() async {
    setState(() {
      _processing = true;
      _error = null;
    });

    try {
      final photoStorage = ref.read(photoStorageProvider);
      // This runs crop/encode in an isolate (off main thread).
      final photos = await photoStorage.writePassportPhotosFromFileBackground(
        orderId: widget.orderId,
        studentId: widget.studentId,
        sourceImagePath: widget.sourceImagePath,
        crop: widget.suggestedCrop,
      );

      if (mounted) {
        setState(() {
          _highResPath = photos.highResPath;
          _thumbnailPath = photos.thumbnailPath;
          _processing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _processing = false;
        });
      }
    }
  }

  /// Apply background removal with selected color
  Future<void> _applyBackgroundRemoval() async {
    if (_highResPath == null) return;

    setState(() => _removingBackground = true);

    try {
      // Read the image file
      final imageFile = File(_highResPath!);
      final originalBytes = await imageFile.readAsBytes();

      // Step 1: Remove background using the package
      final resultImage = await BackgroundRemover.instance.removeBg(originalBytes);

      // Step 2: Convert ui.Image to bytes
      final byteData = await resultImage.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw Exception('Failed to convert image to bytes');
      final pngBytes = byteData.buffer.asUint8List();

      // Step 3: Add background color using the package (set to red for testing)
      final finalBytes = await BackgroundRemover.instance.addBackground(
        image: pngBytes,
        bgColor: Colors.red,
      );

      // Clear image cache before saving
      imageFile.deleteSync();
      
      // Save the processed image (overwrite original)
      await imageFile.writeAsBytes(finalBytes);

      // Clear Flutter's image cache
      await imageFile.exists(); // Ensure file exists
      
      // Regenerate thumbnail with the new background
      final photoStorage = ref.read(photoStorageProvider);
      await photoStorage.overwritePhotosFromEditedBytesBackground(
        highResPath: _highResPath!,
        thumbnailPath: _thumbnailPath!,
        editedBytes: finalBytes,
      );

      if (mounted) {
        // Clear the image cache for this file
        FileImage(imageFile).evict();
        
        // Force widget rebuild to reload the image with new timestamp
        setState(() {});
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Background set to Red (testing). Size: ${finalBytes.length} bytes'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Background removal failed: $e'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _removingBackground = false);
    }
  }

  Future<void> _editImage() async {
    if (_highResPath == null || _thumbnailPath == null) return;

    final editedBytes = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(builder: (_) => _EditorPage(filePath: _highResPath!)),
    );

    if (editedBytes == null) return;

    setState(() => _saving = true);
    try {
      await ref
          .read(photoStorageProvider)
          .overwritePhotosFromEditedBytesBackground(
            highResPath: _highResPath!,
            thumbnailPath: _thumbnailPath!,
            editedBytes: editedBytes,
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Edit save failed: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _usePhoto() async {
    if (_highResPath == null || _thumbnailPath == null) return;

    setState(() => _saving = true);

    try {
      // Generate compressed and encrypted versions in background
      final photoStorage = ref.read(photoStorageProvider);
      
      // Schedule compression and encryption for high-res (original)
      await photoStorage.scheduleCompressAndEncrypt(
        orderId: widget.orderId,
        studentId: widget.studentId,
        inputJpgPath: _highResPath!,
        maxLongSide: 1200,
        jpegQuality: 85,
      );

      // Schedule compression and encryption for compressed copy
      await photoStorage.scheduleCompressAndEncrypt(
        orderId: widget.orderId,
        studentId: '${widget.studentId}_compressed',
        inputJpgPath: _highResPath!,
        maxLongSide: 800,
        jpegQuality: 75,
      );

      if (!mounted) return;

      Navigator.of(context).pop(
        CapturePhotoResult(
          highResPath: _highResPath!,
          thumbnailPath: _thumbnailPath!,
          crop: widget.suggestedCrop,
          absent: false,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process photo: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview • ${widget.studentName}'),
        actions: [
          if (!_processing && _highResPath != null)
            TextButton.icon(
              onPressed: _saving ? null : _editImage,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
            ),
        ],
      ),
      body: Stack(
        children: [
          if (_processing)
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
          else if (_error != null)
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
                      'Processing failed:\n$_error',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _processImage,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else if (_highResPath != null)
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
                    File(_highResPath!),
                    fit: BoxFit.cover,
                    // Use unique key to force reload when file changes
                    key: ValueKey(_highResPath! + DateTime.now().millisecondsSinceEpoch.toString()),
                  ),
                ),
              ),
            ),
          if (_saving || _removingBackground)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator.adaptive(),
                    const SizedBox(height: 16),
                    Text(
                      _removingBackground ? 'Removing background...' : 'Saving...',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _processing || _error != null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Background removal button
                    if (widget.backgroundColor != Colors.transparent)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _saving || _removingBackground
                                ? null
                                : _applyBackgroundRemoval,
                            icon: _removingBackground
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.auto_fix_high),
                            label: Text(_removingBackground
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
                            onPressed: _saving || _removingBackground
                                ? null
                                : () {
                                    // Return null to signal retake - camera will not save
                                    Navigator.of(context).pop(null);
                                  },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Retake'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _saving || _removingBackground ? null : _usePhoto,
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

class _EditorPage extends StatelessWidget {
  const _EditorPage({required this.filePath});

  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProImageEditor.file(
        filePath,
        callbacks: ProImageEditorCallbacks(
          onImageEditingComplete: (Uint8List bytes) async {
            Navigator.of(context).pop(bytes);
          },
        ),
      ),
    );
  }
}

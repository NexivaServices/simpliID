import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/image/passport_crop_detector_isolate.dart';
import 'capture_photo_preview_page.dart';

class CapturePhotoResult {
  const CapturePhotoResult({
    required this.highResPath,
    required this.thumbnailPath,
    required this.crop,
    required this.absent,
  });

  final String highResPath;
  final String thumbnailPath;
  final Rect? crop;
  final bool absent;

  const CapturePhotoResult.absent()
    : highResPath = '',
      thumbnailPath = '',
      crop = null,
      absent = true;
}

class CapturePhotoFlowPage extends HookConsumerWidget {
  const CapturePhotoFlowPage({
    super.key,
    required this.orderId,
    required this.studentId,
    required this.studentName,
    required this.studentAdmNo,
  });

  final String orderId;
  final String studentId;
  final String studentName;
  final String studentAdmNo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final capturing = useState(false);
    final showFilters = useState(false);
    final brightness = useState(0.0);
    final saturation = useState(0.0);
    final selectedBgColor = useState<Color>(Colors.white);
    final showBgColorPicker = useState(false);
    
    final saveConfig = useMemoized(
      () => SaveConfig.photo(
        pathBuilder: (sensors) async {
          final dir = await getTemporaryDirectory();
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          return SingleCaptureRequest('${dir.path}/capture_$timestamp.jpg', sensors.first);
        },
      ),
    );

    Future<void> markAbsent() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Mark absent?'),
            content: Text(
              'This will mark $studentName (Adm: $studentAdmNo) as absent and move to the next student.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Mark absent'),
              ),
            ],
          );
        },
      );

      if (confirmed == true && context.mounted) {
        Navigator.of(context).pop(const CapturePhotoResult.absent());
      }
    }

    return WillPopScope(
      onWillPop: () async {
        if (showFilters.value) {
          showFilters.value = false;
          return false;
        }
        if (showBgColorPicker.value) {
          showBgColorPicker.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CameraAwesomeBuilder.awesome(
        saveConfig: saveConfig,
        sensorConfig: SensorConfig.single(
          sensor: Sensor.position(SensorPosition.back),
          aspectRatio: CameraAspectRatios.ratio_16_9,
        ),
        enablePhysicalButton: true,
        onMediaCaptureEvent: (mediaCapture) async {
          // Only process successful captures
          if (mediaCapture.status != MediaCaptureStatus.success) return;
          if (capturing.value) return;
          
          capturing.value = true;

          try {
            final file = mediaCapture.captureRequest.when(
              single: (single) => single.file,
              multiple: (_) => null,
            );

            if (file == null || !context.mounted) {
              capturing.value = false;
              return;
            }

            final path = file.path;

            // Run ML Kit face detection
            final crop = await PassportCropDetectorAsync.instance.suggestCrop(
              imagePath: path,
            );

            if (!context.mounted) {
              capturing.value = false;
              return;
            }

            // Navigate to preview
            final result = await Navigator.of(context).push<CapturePhotoResult>(
              MaterialPageRoute(
                builder: (_) => CapturePhotoPreviewPage(
                  studentName: studentName,
                  orderId: orderId,
                  studentId: studentId,
                  sourceImagePath: path,
                  suggestedCrop: crop,
                  backgroundColor: selectedBgColor.value,
                ),
              ),
            );

            if (!context.mounted) {
              capturing.value = false;
              return;
            }

            if (result != null) {
              Navigator.of(context).pop(result);
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Capture failed: $e'),
                  backgroundColor: Colors.red.shade700,
                ),
              );
            }
          } finally {
            capturing.value = false;
          }
        },
        progressIndicator: const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        topActionsBuilder: (state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Background color selector
                  GestureDetector(
                    onTap: () => showBgColorPicker.value = !showBgColorPicker.value,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: selectedBgColor.value,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.palette,
                        color: selectedBgColor.value.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        middleContentBuilder: (state) {
          return const SizedBox.shrink();
        },
        bottomActionsBuilder: (state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Student info card above capture button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    // Avatar circle with initials
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFF2196F3),
                      child: Text(
                        _getInitials(studentName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Name and admission number
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            studentName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Adm No: $studentAdmNo',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Absent button
                    TextButton(
                      onPressed: capturing.value ? null : markAbsent,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'ABSENT',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Bottom action buttons
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Center(
                        child: AwesomeFlashButton(state: state),
                      ),
                    ),
                    AwesomeCaptureButton(state: state),
                    Expanded(
                      child: Center(
                        child: IconButton(
                          onPressed: () => showFilters.value = !showFilters.value,
                          icon: Icon(
                            Icons.tune,
                            color: showFilters.value ? Colors.blue : Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      // Camera filter controls overlay
      if (showFilters.value)
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _CameraFilterControls(
            brightness: brightness,
            saturation: saturation,
            onClose: () => showFilters.value = false,
          ),
        ),
      // Background color picker overlay
      if (showBgColorPicker.value)
        Positioned(
          top: 80,
          right: 16,
          child: _BackgroundColorPicker(
            selectedColor: selectedBgColor,
            onClose: () => showBgColorPicker.value = false,
          ),
        ),
    ],
  ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1))
        .toUpperCase();
  }
}

/// Camera filter controls widget
class _CameraFilterControls extends StatelessWidget {
  final ValueNotifier<double> brightness;
  final ValueNotifier<double> saturation;
  final VoidCallback onClose;

  const _CameraFilterControls({
    required this.brightness,
    required this.saturation,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Camera Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _FilterSlider(
              label: 'Brightness',
              icon: Icons.brightness_6,
              value: brightness,
              min: -1.0,
              max: 1.0,
            ),
            const SizedBox(height: 16),
            _FilterSlider(
              label: 'Saturation',
              icon: Icons.palette,
              value: saturation,
              min: -1.0,
              max: 1.0,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                brightness.value = 0.0;
                saturation.value = 0.0;
              },
              child: const Text('Reset to Default'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Filter slider widget
class _FilterSlider extends HookWidget {
  final String label;
  final IconData icon;
  final ValueNotifier<double> value;
  final double min;
  final double max;

  const _FilterSlider({
    required this.label,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              value.value.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.white24,
            thumbColor: Colors.white,
            overlayColor: Colors.blue.withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value.value,
            min: min,
            max: max,
            onChanged: (newValue) => value.value = newValue,
          ),
        ),
      ],
    );
  }
}

/// Background color picker widget
class _BackgroundColorPicker extends StatelessWidget {
  final ValueNotifier<Color> selectedColor;
  final VoidCallback onClose;

  const _BackgroundColorPicker({
    required this.selectedColor,
    required this.onClose,
  });

  static final List<Color> _colors = [
    Colors.white,
    const Color(0xFFF5F5F5), // Light gray
    const Color(0xFF2196F3), // Blue
    const Color(0xFF90CAF9), // Light blue
    const Color(0xFFE3F2FD), // Very light blue
    const Color(0xFFFF5722), // Red
    const Color(0xFF4CAF50), // Green
    const Color(0xFFFFC107), // Amber
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Background',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onClose,
                icon: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _colors.map((color) {
              return GestureDetector(
                onTap: () => selectedColor.value = color,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColor.value == color
                          ? Colors.blue
                          : Colors.white.withValues(alpha: 0.3),
                      width: selectedColor.value == color ? 3 : 2,
                    ),
                  ),
                  child: selectedColor.value == color
                      ? Icon(
                          Icons.check,
                          color: color.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                          size: 20,
                        )
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

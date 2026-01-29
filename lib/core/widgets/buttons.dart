import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable Primary Button Widget matching UI design
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          isFullWidth ? double.infinity : 120,
          height ?? 56,
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
              ),
            )
          : Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppTheme.iconSmall),
                  const SizedBox(width: AppTheme.spaceSmall),
                ],
                Text(label),
              ],
            ),
    );

    return isFullWidth ? button : button;
  }
}

/// Secondary/Outlined Button Widget
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.height,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(
          isFullWidth ? double.infinity : 100,
          height ?? 48,
        ),
      ),
      child: isLoading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
              ),
            )
          : Row(
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppTheme.iconSmall),
                  const SizedBox(width: AppTheme.spaceSmall),
                ],
                Text(label),
              ],
            ),
    );
  }
}

/// Icon Button with Background (for camera, checkmark, etc.)
class IconButtonWithBackground extends StatelessWidget {
  const IconButtonWithBackground({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.iconSize,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? AppColors.primaryBlue,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            color: iconColor ?? AppColors.textPrimary,
            size: iconSize ?? AppTheme.iconMedium,
          ),
        ),
      ),
    );
  }
}

/// Status Badge (for warnings, checkmarks on student list)
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size = 24,
  });

  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.success,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: iconColor ?? AppColors.textPrimary,
        size: size * 0.6,
      ),
    );
  }
}

/// Bottom Sheet Action Button (for "Retake", "Save", "Mark")
class BottomSheetActionButton extends StatelessWidget {
  const BottomSheetActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spaceMedium,
          vertical: AppTheme.spaceSmall,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.iconPrimary,
              size: AppTheme.iconMedium,
            ),
            const SizedBox(height: AppTheme.spaceXSmall),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dropdown Button styled for the app
class StyledDropdownButton<T> extends StatelessWidget {
  const StyledDropdownButton({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceMedium,
        vertical: AppTheme.spaceSmall,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(
          color: AppColors.borderPrimary,
          width: 1.5,
        ),
      ),
      child: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        hint: hint != null
            ? Text(
                hint!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        dropdownColor: AppColors.cardDark,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.iconSecondary,
        ),
      ),
    );
  }
}

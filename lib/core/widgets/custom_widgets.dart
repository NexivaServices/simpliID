import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom Text Field Widget matching UI design
class StyledTextField extends StatelessWidget {
  const StyledTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final bool enabled;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      enabled: enabled,
      maxLines: maxLines,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

/// Search Bar Widget (like in Student List)
class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onVoiceSearch,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onVoiceSearch;

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
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: AppColors.iconSecondary,
            size: AppTheme.iconMedium,
          ),
          const SizedBox(width: AppTheme.spaceSmall),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textTertiary,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (onVoiceSearch != null) ...[
            const SizedBox(width: AppTheme.spaceSmall),
            InkWell(
              onTap: onVoiceSearch,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              child: const Padding(
                padding: EdgeInsets.all(AppTheme.spaceXSmall),
                child: Icon(
                  Icons.mic,
                  color: AppColors.iconSecondary,
                  size: AppTheme.iconMedium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Student Card Widget (for list items)
class StudentCard extends StatelessWidget {
  const StudentCard({
    super.key,
    required this.name,
    required this.admissionNo,
    required this.className,
    this.photoUrl,
    this.status = StudentStatus.pending,
    this.onTap,
    this.onCameraTap,
  });

  final String name;
  final String admissionNo;
  final String className;
  final String? photoUrl;
  final StudentStatus status;
  final VoidCallback? onTap;
  final VoidCallback? onCameraTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceMedium),
          child: Row(
            children: [
              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.cardDarkElevated,
                    backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
                    child: photoUrl == null
                        ? const Icon(
                            Icons.person,
                            color: AppColors.iconSecondary,
                            size: AppTheme.iconMedium,
                          )
                        : null,
                  ),
                  // Status badge
                  if (status != StudentStatus.pending)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.backgroundDark,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          status == StudentStatus.completed
                              ? Icons.check_circle
                              : Icons.warning,
                          color: status == StudentStatus.completed
                              ? AppColors.success
                              : AppColors.warning,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppTheme.spaceMedium),
              // Student info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceXSmall),
                    Text(
                      'Adm: $admissionNo • $className',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Action button
              IconButton(
                onPressed: onCameraTap,
                icon: Icon(
                  status == StudentStatus.completed
                      ? Icons.cloud_upload
                      : Icons.camera_alt,
                  color: status == StudentStatus.completed
                      ? AppColors.success
                      : AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum StudentStatus {
  pending,
  warning,
  completed,
}

/// Bottom Navigation Item
class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSmall),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryBlue : AppColors.iconTertiary,
              size: AppTheme.iconMedium,
            ),
            const SizedBox(height: AppTheme.spaceXSmall),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primaryBlue : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// App Bar with custom styling
class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  const StyledAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBackButton = false,
  });

  final String? title;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading ?? (showBackButton ? const BackButton() : null),
      title: subtitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                Text(
                  subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            )
          : title != null
              ? Text(title!)
              : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

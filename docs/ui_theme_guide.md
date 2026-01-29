# UI Theme & Components Implementation

## Overview
This project now uses a **dark theme** with **Montserrat font** matching the UI design from the screenshots. All buttons, text fields, and components follow the established color scheme and design patterns.

## Color Scheme

### Primary Colors
- **Primary Blue**: `#2E5CFF` - Used for buttons, active states, primary actions
- **Primary Blue Dark**: `#1E4DE6` - Pressed/hover states
- **Primary Blue Light**: `#4E7CFF` - Light variants

### Backgrounds
- **Background Dark**: `#0F1419` - Main app background
- **Surface Dark**: `#1A1F2E` - Surface elements (app bar, bottom nav)
- **Card Dark**: `#242845` - Card backgrounds
- **Card Dark Elevated**: `#2D3349` - Elevated cards, dropdowns

### Text Colors
- **Text Primary**: `#FFFFFF` - Headings, primary text
- **Text Secondary**: `#B0B3C1` - Secondary text, labels
- **Text Tertiary**: `#7A7E8F` - Hints, placeholders
- **Text Disabled**: `#4A4E5F` - Disabled text

### Status Colors
- **Success**: `#00D9A3` - Completed, success states
- **Warning**: `#FFAB2E` - Warning badges
- **Error**: `#FF4E4E` - Error messages
- **Info**: `#2E9CFF` - Info messages

## Font Setup

### 1. Download Montserrat Font
Visit `assets/fonts/README.md` for detailed instructions.

**Quick steps:**
1. Go to https://fonts.google.com/specimen/Montserrat
2. Download the font family
3. Extract and copy these files to `assets/fonts/`:
   - Montserrat-Thin.ttf (100)
   - Montserrat-ExtraLight.ttf (200)
   - Montserrat-Light.ttf (300)
   - Montserrat-Regular.ttf (400)
   - Montserrat-Medium.ttf (500)
   - Montserrat-SemiBold.ttf (600)
   - Montserrat-Bold.ttf (700)
   - Montserrat-ExtraBold.ttf (800)
   - Montserrat-Black.ttf (900)

### 2. Font Weights
```dart
// Use semantic font weights
Text('Heading', style: TextStyle(fontWeight: FontWeight.w700)) // Bold
Text('Subheading', style: TextStyle(fontWeight: FontWeight.w600)) // SemiBold
Text('Body', style: TextStyle(fontWeight: FontWeight.w400)) // Regular
```

## Using the Theme

### Accessing Colors
```dart
import 'package:simpliid/core/theme/app_theme.dart';

// In your widgets
Container(
  color: AppColors.backgroundDark,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
```

### Using Theme Extensions
```dart
// Access from context
final textTheme = Theme.of(context).textTheme;
final colorScheme = Theme.of(context).colorScheme;

Text(
  'Display Text',
  style: textTheme.displayLarge, // 32px, Bold
)
```

## Components

### 1. Primary Button
Large, full-width blue button for primary actions (Login, Submit, etc.)

```dart
import 'package:simpliid/core/widgets/widgets.dart';

PrimaryButton(
  onPressed: () => print('Pressed'),
  label: 'Log In',
  icon: Icons.arrow_forward, // Optional
  isLoading: false, // Shows loading spinner
  isFullWidth: true, // Full width or auto-size
  height: 56, // Custom height (default 56)
)
```

**Example from Login Screen:**
```dart
PrimaryButton(
  onPressed: _handleLogin,
  label: 'Log In',
  icon: Icons.login,
  isLoading: isLoggingIn,
)
```

### 2. Secondary Button
Outlined button for secondary actions

```dart
SecondaryButton(
  onPressed: () => print('Pressed'),
  label: 'Cancel',
  icon: Icons.close,
  isFullWidth: false,
  height: 48,
)
```

### 3. Icon Button with Background
Square/rounded button with icon (camera, settings, etc.)

```dart
IconButtonWithBackground(
  icon: Icons.camera_alt,
  onPressed: () => print('Capture'),
  backgroundColor: AppColors.primaryBlue,
  iconColor: AppColors.textPrimary,
  size: 48,
  iconSize: 24,
)
```

### 4. Bottom Sheet Action Buttons
Icon + label buttons for bottom sheets (Retake, Save, Mark)

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    BottomSheetActionButton(
      icon: Icons.replay,
      label: 'Retake',
      onPressed: () => print('Retake'),
    ),
    BottomSheetActionButton(
      icon: Icons.save,
      label: 'Save',
      onPressed: () => print('Save'),
    ),
    BottomSheetActionButton(
      icon: Icons.check_circle,
      label: 'Mark',
      onPressed: () => print('Mark'),
    ),
  ],
)
```

### 5. Text Fields
Styled input fields matching the dark theme

```dart
StyledTextField(
  controller: usernameController,
  hintText: 'Photographer ID',
  prefixIcon: Icon(Icons.person),
  keyboardType: TextInputType.text,
  textInputAction: TextInputAction.next,
)

// Password field
StyledTextField(
  controller: passwordController,
  hintText: 'Password',
  prefixIcon: Icon(Icons.lock),
  obscureText: !isPasswordVisible,
  suffixIcon: IconButton(
    icon: Icon(
      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
    ),
    onPressed: () => isPasswordVisible = !isPasswordVisible,
  ),
)
```

### 6. Search Bar
Search input with voice icon (Student List)

```dart
SearchBar(
  controller: searchController,
  hintText: 'Search Name, Adm No, or Class...',
  onChanged: (query) => print('Search: $query'),
  onVoiceSearch: () => print('Voice search'),
)
```

### 7. Student Card
List item for student data

```dart
StudentCard(
  name: 'John Doe',
  admissionNo: '10234',
  className: 'Class 10-A',
  photoUrl: 'https://...', // Optional
  status: StudentStatus.completed, // pending, warning, completed
  onTap: () => print('View student'),
  onCameraTap: () => print('Capture photo'),
)
```

### 8. Dropdown
Styled dropdown matching the theme

```dart
StyledDropdownButton<String>(
  value: selectedClass,
  hint: 'All Classes',
  items: [
    DropdownMenuItem(value: 'all', child: Text('All Classes')),
    DropdownMenuItem(value: '10-A', child: Text('Class 10-A')),
    DropdownMenuItem(value: '10-B', child: Text('Class 10-B')),
  ],
  onChanged: (value) => print('Selected: $value'),
)
```

### 9. App Bar
Custom app bar with subtitle support

```dart
StyledAppBar(
  title: 'Review Photo',
  subtitle: 'ID: 84920-A • Offline Mode',
  showBackButton: true,
  actions: [
    TextButton(
      onPressed: () => print('Reset'),
      child: Text('Reset'),
    ),
  ],
)
```

### 10. Status Badge
Circular badge for warnings/checkmarks

```dart
StatusBadge(
  icon: Icons.check,
  backgroundColor: AppColors.success,
  iconColor: AppColors.textPrimary,
  size: 24,
)

// Warning badge
StatusBadge(
  icon: Icons.warning,
  backgroundColor: AppColors.warning,
  size: 24,
)
```

## Complete Screen Examples

### Login Screen
```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simpliid/core/theme/app_theme.dart';
import 'package:simpliid/core/widgets/widgets.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isPasswordVisible = useState(false);
    final isLoading = useState(false);

    return Scaffold(
      appBar: StyledAppBar(
        title: 'ID Capture Pro',
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: AppTheme.spaceSmall),
            Text(
              'Enter your photographer credentials to begin.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spaceXLarge),
            
            StyledTextField(
              controller: usernameController,
              hintText: 'Photographer ID',
              prefixIcon: Icon(Icons.badge),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppTheme.spaceMedium),
            
            StyledTextField(
              controller: passwordController,
              hintText: 'Password',
              prefixIcon: Icon(Icons.lock),
              obscureText: !isPasswordVisible.value,
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible.value 
                    ? Icons.visibility 
                    : Icons.visibility_off,
                ),
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
              ),
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: AppTheme.spaceXLarge),
            
            PrimaryButton(
              onPressed: () {
                // Login logic
              },
              label: 'Log In',
              icon: Icons.login,
              isLoading: isLoading.value,
            ),
            
            const SizedBox(height: AppTheme.spaceLarge),
            Text(
              'Version 4.2.0 • Build 8921',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
```

### Student List Screen
```dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simpliid/core/theme/app_theme.dart';
import 'package:simpliid/core/widgets/widgets.dart';

class StudentListScreen extends HookWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final selectedClass = useState<String>('all');
    final selectedDivision = useState<String>('all');

    return Scaffold(
      appBar: StyledAppBar(
        title: 'Student List',
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spaceMedium),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StyledDropdownButton<String>(
                        value: selectedClass.value,
                        hint: 'All Classes',
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('All Classes')),
                          DropdownMenuItem(value: '10-A', child: Text('Class 10-A')),
                        ],
                        onChanged: (value) => selectedClass.value = value!,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spaceMedium),
                    Expanded(
                      child: StyledDropdownButton<String>(
                        value: selectedDivision.value,
                        hint: 'All Divisions',
                        items: [
                          DropdownMenuItem(value: 'all', child: Text('All Divisions')),
                        ],
                        onChanged: (value) => selectedDivision.value = value!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spaceMedium),
                SearchBar(
                  controller: searchController,
                  hintText: 'Search Name, Adm No, or Class...',
                  onVoiceSearch: () {},
                ),
                const SizedBox(height: AppTheme.spaceMedium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'STUDENTS (156)',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Select Multiple'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return StudentCard(
                  name: 'Student ${index + 1}',
                  admissionNo: '1023${index + 4}',
                  className: 'Class 10-A',
                  status: index % 3 == 0 
                    ? StudentStatus.completed 
                    : (index % 3 == 1 ? StudentStatus.warning : StudentStatus.pending),
                  onTap: () {},
                  onCameraTap: () {},
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.person_add),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          border: Border(
            top: BorderSide(
              color: AppColors.divider,
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSmall),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BottomNavItem(
                  icon: Icons.list,
                  label: 'List',
                  isSelected: true,
                  onTap: () {},
                ),
                BottomNavItem(
                  icon: Icons.sync,
                  label: 'Sync',
                  isSelected: false,
                  onTap: () {},
                ),
                BottomNavItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  isSelected: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## Spacing & Sizing Constants

```dart
// Use AppTheme constants for consistency
AppTheme.spaceXSmall  // 4px
AppTheme.spaceSmall   // 8px
AppTheme.spaceMedium  // 16px
AppTheme.spaceLarge   // 24px
AppTheme.spaceXLarge  // 32px

AppTheme.radiusSmall   // 8px
AppTheme.radiusMedium  // 12px
AppTheme.radiusLarge   // 16px
AppTheme.radiusXLarge  // 24px

AppTheme.iconSmall   // 20px
AppTheme.iconMedium  // 24px
AppTheme.iconLarge   // 32px
AppTheme.iconXLarge  // 48px
```

## Best Practices

1. **Always use AppColors** instead of hardcoding colors
2. **Use AppTheme spacing constants** for margins/padding
3. **Prefer semantic text styles** from Theme.of(context).textTheme
4. **Use provided widgets** (PrimaryButton, StyledTextField) for consistency
5. **Follow Montserrat font weights**: 400 (regular), 500 (medium), 600 (semibold), 700 (bold)
6. **Test on dark backgrounds** to ensure proper contrast

## Migration Checklist

- [ ] Download and place Montserrat fonts in `assets/fonts/`
- [ ] Run `flutter pub get`
- [ ] Replace all `ElevatedButton` with `PrimaryButton`
- [ ] Replace all `TextField` with `StyledTextField`
- [ ] Replace hardcoded colors with `AppColors.*`
- [ ] Update custom AppBars to use `StyledAppBar`
- [ ] Use `StudentCard` for list items
- [ ] Test all screens in dark mode

# Montserrat Font - Using Google Fonts Package

**✅ No manual font files needed!**

This project uses the `google_fonts` package to automatically load and use the Montserrat font family.

## What's Configured

The app is already set up to use Montserrat font with the following configuration:

- **Package**: `google_fonts: ^8.0.0` (installed)
- **Font**: Montserrat (all weights 100-900)
- **Implementation**: Automatically applied via `AppTheme.darkTheme`

## How It Works

The `google_fonts` package:
1. Downloads fonts on-demand from Google Fonts
2. Caches them locally for offline use
3. Applies them automatically to all text in the app

## Usage in Code

```dart
// Already applied globally via theme
// No manual font specification needed!

// If you need to use it manually:
import 'package:google_fonts/google_fonts.dart';

Text(
  'Hello',
  style: GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
)
```

## Testing

Just run the app:
```bash
flutter clean
flutter pub get
flutter run
```

All text will automatically use Montserrat font!

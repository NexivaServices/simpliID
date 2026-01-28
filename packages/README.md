# Local Packages

This directory contains local copies of packages for customization.

## CamerAwesome

**Version**: 2.5.0  
**Original Source**: https://pub.dev/packages/camerawesome

### Why Local?
The CamerAwesome package is copied locally to allow custom modifications that cannot be done through pub.dev configuration.

### Structure
```
packages/
└── camerawesome/
    ├── lib/
    │   ├── camerawesome_plugin.dart    # Main entry point
    │   ├── pigeon.dart                 # Platform channel definitions
    │   └── src/
    │       ├── camera_characteristics/ # Camera properties
    │       ├── orchestrator/          # Core camera logic
    │       ├── photofilters/         # Image filters
    │       └── widgets/              # UI components (customize here!)
    ├── android/                       # Android native code
    ├── ios/                          # iOS native code
    └── pubspec.yaml                  # Package dependencies

```

### How to Customize

1. **UI Components**: Modify files in `lib/src/widgets/`
   - Customize camera UI
   - Change button layouts
   - Modify preview styles

2. **Camera Behavior**: Edit files in `lib/src/orchestrator/`
   - Change capture logic
   - Modify camera state management

3. **Filters**: Customize `lib/src/photofilters/`
   - Add custom photo filters
   - Modify existing filters

4. **Native Code**: 
   - Android: `android/src/main/kotlin/`
   - iOS: `ios/Classes/`

### Important Notes

⚠️ **Do NOT commit the example folder errors** - The example app in the package has errors because it's not part of your app. This is normal and won't affect your application.

✅ **Your app uses**: `packages/camerawesome` (not the example)

### Updating Dependencies

After modifying the local package, run:
```bash
flutter pub get
```

### Version Control

Consider adding to `.gitignore` if you don't want to commit the entire package:
```
# If you want to exclude the local package
# packages/camerawesome/
```

Or keep it in version control to share customizations with your team.

### Reverting to Pub.dev Version

To use the pub.dev version instead:
1. Edit `pubspec.yaml`
2. Change:
   ```yaml
   camerawesome:
     path: packages/camerawesome
   ```
   To:
   ```yaml
   camerawesome: ^2.5.0
   ```
3. Run `flutter pub get`

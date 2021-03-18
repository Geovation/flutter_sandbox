# flutter_sandbox

A new Flutter sandbox application to experiment in flutter

## Getting Started

This project is a starting point for a Flutter application.

### Choose your preferred development tools to write, build and run flutter apps.
For all tools, install Flutter SDK from <https://flutter.dev/docs/get-started/install>.
For in-depth instructions please visit <https://flutter.dev/docs/get-started/test-drive?tab=terminal>.
#### Android Studio
- Install Flutter and Dart plugins.
- Select your device from the target selector.
- Press Run to see your app.

#### Visual Studio Code
- Install Flutter and Dart extensions.
- Select a device from the device selector at the bottom or select 'No Devices' and launch a simulator.
- Press Run>Start Debugging or press F5 to see your app.

#### Terminal & editor
- Check that Android devices are running using `flutter devices`.
- Run the app with using the command `flutter run` to see your app.

## Additional files that needs to be modified to include private data.
### Firebase
- Add your google-services.json in android>app folder.
- Add your Firebase config variable for web support in web>index.html.

## Compile-time variables
To provide compile-time variables use `--dart-define` during `flutter run` or `flutter build`. To pass multiple key-value pairs just use `--dart-define` multiple times.
`flutter run --dart-define=ACCESS_TOKEN_MAPBOX --dart-define=VARIABLE=VARIABLE_VALUE`

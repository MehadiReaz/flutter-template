import 'package:flutter/material.dart';
import 'package:flutter_structure/app/app.dart';
import 'package:flutter_structure/bootstrap/bootstrap.dart';

/// Main entry point of the application
/// This function bootstraps the app and runs it
void main() async {
  // Bootstrap the application with all necessary setup
  await bootstrap();

  // Run the app
  runApp(const App());
}

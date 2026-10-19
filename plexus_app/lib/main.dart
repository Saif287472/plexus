import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:plexus_app/app.dart';

void main() {
  // Enable Flutter error reporting in debug mode
  if (!kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {
      // Redact potential secrets from debug output
      if (message != null && message.contains('key') &&
          message.contains('secret')) {
        return;
      }
      print(message);
    };
  }

  runApp(const PlexusApp());
}

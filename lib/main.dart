import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coalnexus/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize core services (local storage, database, etc.)
  // These will be initialized properly as providers or before runApp
  
  runApp(
    const ProviderScope(
      child: CoalNexusApp(),
    ),
  );
}

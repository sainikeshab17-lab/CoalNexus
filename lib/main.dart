import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:coalnexus/app.dart';
import 'package:coalnexus/core/api/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  // Initialize core services (local storage, database, etc.)
  // These will be initialized properly as providers or before runApp

  runApp(const ProviderScope(child: CoalNexusApp()));
}

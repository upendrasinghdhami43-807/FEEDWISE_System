import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'data/services/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase (fails gracefully if no keys — works in demo mode)
  try {
    await SupabaseConfig.initialize();
  } catch (_) {
    // Running in demo mode without Supabase credentials
  }

  runApp(
    const ProviderScope(
      child: FeedWiseApp(),
    ),
  );
}

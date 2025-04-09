import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_app/webview_page.dart';
import 'package:webview_app/authentification.dart';
import 'package:webview_app/theme_notifier.dart'; // <- à importer
import 'splashscreen.dart'; // Assurez-vous d'importer SplashScreen ici

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      title: 'Application WebView',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.themeMode, // <- dynamique via Provider
      home: SplashScreen(
        onToggleTheme: (bool value) {
          themeNotifier.toggleTheme();
        },
        isDarkMode: themeNotifier.themeMode == ThemeMode.dark,
      ),
    );
  }
}
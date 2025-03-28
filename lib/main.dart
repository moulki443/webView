import 'package:flutter/material.dart';
import 'package:webview_app/authentification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application WebView',
      theme: ThemeData(
        primarySwatch: Colors.purple, // Remplacement du bleu par une autre couleur
      ),
      home: Authentification(),  // Page d'accueil corrigée
    );
  }
}

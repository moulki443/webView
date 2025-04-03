import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_app/webview_page.dart';
import 'package:webview_app/authentification.dart';
import 'package:webview_flutter/webview_flutter.dart';


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
      home: FutureBuilder(
        future: _checkIfAuthenticated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == true) {
            return WebViewPage(); // L'utilisateur est déjà authentifié
          } else {
            return const Authentification(); // Demander à l'utilisateur de se connecter
          }
        },
      ),
    );
  }

  // Vérifier si l'utilisateur est authentifié
  Future<bool> _checkIfAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isAuthenticated = prefs.getBool("isAuthenticated");
    return isAuthenticated ?? false; // Retourner false si l'utilisateur n'est pas authentifié
  }
}

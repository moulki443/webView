import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentification.dart';
import 'webview_page.dart';

class SplashScreen extends StatefulWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const SplashScreen({super.key, required this.onToggleTheme, required this.isDarkMode});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Création du contrôleur d'animation pour l'opacité
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // La durée de l'animation
    );

    // Définition de l'animation d'opacité
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Lancer l'animation
    _controller.forward();

    // Attendre la fin de l'animation avant de naviguer
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3)); // Attente de 3 secondes avant de naviguer
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: unused_local_variable
    bool isAuthenticated = prefs.getBool("isAuthenticated") ?? false;

    if (mounted) {
      Navigator.pushReplacement(
        context,
     
      MaterialPageRoute(
      builder: (context) => WebViewPage(showSuccessMessage: true),
  ),
);
    }
  }

  @override
  void dispose() {
    // Nettoyer le contrôleur d'animation lorsqu'il n'est plus utilisé
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animation d'opacité pour le logo
          FadeTransition(
            opacity: _opacityAnimation,
            child: Center(
              child: Image.asset(
                'assets/logo_managtech.png', // Chemin vers ton image de logo
                height: 200, // Ajuster la taille du logo selon tes préférences
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
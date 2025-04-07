import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_app/otp_input.dart';
import 'dart:math';
import 'webview_page.dart';
import 'package:provider/provider.dart';
import 'package:webview_app/theme_notifier.dart'; // Importé pour changer le thème

class Authentification extends StatefulWidget {
  const Authentification({super.key});

  @override
  _AuthentificationState createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  final _domainController = TextEditingController();
  bool _rememberMe = false;
  bool _isButtonPressed = false;
  String predefinedDomain = "exemple.com";

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _saveAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isAuthenticated", true);
  }

  Future<void> _saveDomain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString("savedDomain", _domainController.text);
      await prefs.setBool("rememberMe", true);
    } else {
      await prefs.remove("savedDomain");
      await prefs.setBool("rememberMe", false);
    }
  }

  void _startOtpProcess() async {
    if (_domainController.text == predefinedDomain) {
      await _saveDomain();
      await _saveAuthentication();

      String generatedOtp = _generateOtp();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpInput(otp: generatedOtp),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Domaine incorrect. Veuillez entrer un domaine valide."),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  String _generateOtp() {
    final random = Random();
    return List.generate(4, (index) => random.nextInt(10)).join();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/logo_managtech.png", height: 200),
                const SizedBox(height: 20),
                Text(
                  "Connexion",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Entrez votre domaine pour continuer",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _domainController,
                  decoration: InputDecoration(
                    labelText: "Votre domaine",
                    prefixIcon: Icon(Icons.domain, color: theme.colorScheme.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: isDark ? Colors.grey[900] : Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: theme.colorScheme.primary,
                    ),
                    Text("Se souvenir de moi", style: theme.textTheme.bodyMedium),
                  ],
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTapDown: (_) {
                    setState(() {
                      _isButtonPressed = true;
                    });
                  },
                  onTapUp: (_) {
                    setState(() {
                      _isButtonPressed = false;
                    });
                    _startOtpProcess();
                  },
                  onTapCancel: () {
                    setState(() {
                      _isButtonPressed = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Se connecter",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Bouton pour changer le thème
                Consumer<ThemeNotifier>( // Observer le changement de thème
                  builder: (context, themeNotifier, child) {
                    final isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
                    return TextButton.icon(
                      onPressed: () {
                        themeNotifier.toggleTheme(); // Changer de thème
                      },
                      icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                      label: Text(isDarkMode ? "" : ""),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

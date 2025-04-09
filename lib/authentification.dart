import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_app/otp_input.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:webview_app/theme_notifier.dart';

class Authentification extends StatefulWidget {
  const Authentification({super.key});

  @override
  _AuthentificationState createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  final _domainController = TextEditingController();
  bool _rememberMe = false;
  // ignore: unused_field
  bool _isButtonPressed = false;
  
  // Liste des domaines valides
  List<String> validDomains = ["exemple.com", "monsite.com", "domaine.fr", "test.com"];

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
    // Vérifier si le domaine saisi est dans la liste des domaines valides
    if (validDomains.contains(_domainController.text)) {
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
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50), // Espace pour bouton en haut
                    Image.asset("assets/logo_managtech.png", height: 200),
                    const SizedBox(height: 20),
                    Text(
                      "Connexion",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 38, 128, 235), // Nouvelle couleur
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
                        prefixIcon: Icon(Icons.domain, color: const Color.fromARGB(255, 38, 128, 235)), // Nouvelle couleur
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 38, 128, 235), // Nouvelle couleur
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
                          activeColor: const Color.fromARGB(255, 38, 128, 235), // Nouvelle couleur
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
                          color: const Color.fromARGB(255, 38, 128, 235), // Nouvelle couleur
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
                  ],
                ),
              ),
            ),

            // Bouton de changement de thème en haut à droite
            Positioned(
              top: 10,
              right: 10,
              child: Consumer<ThemeNotifier>( 
                builder: (context, themeNotifier, child) {
                  final isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
                  return IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: theme.iconTheme.color,
                    ),
                    onPressed: () {
                      themeNotifier.toggleTheme();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

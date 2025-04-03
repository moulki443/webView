import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_app/otp_input.dart';
import 'dart:math';
import 'webview_page.dart'; // Importer la page WebView

class Authentification extends StatefulWidget {
  const Authentification({super.key});

  @override
  _AuthentificationState createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  final _domainController = TextEditingController();
  bool _rememberMe = false;
  bool _isButtonPressed = false; // Gérer l'animation du bouton
  String predefinedDomain = "exemple.com";

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  // Sauvegarder l'état d'authentification
  Future<void> _saveAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isAuthenticated", true);
  }

  // Sauvegarder le domaine si "Se souvenir de moi" est coché
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

  // Gérer la connexion et la redirection vers OTP
  void _startOtpProcess() async {
    if (_domainController.text == predefinedDomain) {
      await _saveDomain(); // Sauvegarde des données
      await _saveAuthentication(); // Sauvegarder l'état d'authentification

      String generatedOtp = _generateOtp();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OtpInput(otp: generatedOtp),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Domaine incorrect. Veuillez entrer un domaine valide."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Générer un OTP aléatoire
  String _generateOtp() {
    final random = Random();
    return List.generate(4, (index) => random.nextInt(10)).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 212, 205),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset("assets/logo_managtech.png", height: 200),
                const SizedBox(height: 20),
                // Texte "Connexion"
                const Text(
                  "Connexion",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 20, 82, 156),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Entrez votre domaine pour continuer",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 16),
                ),
                const SizedBox(height: 30),
                // Champ de saisie du domaine
                TextField(
                  controller: _domainController,
                  decoration: InputDecoration(
                    labelText: "Votre domaine",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 20, 82, 156), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 20, 82, 156), width: 2),
                    ),
                    prefixIcon: const Icon(Icons.domain,
                        color: Color.fromARGB(255, 20, 82, 156)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                // Option "Se souvenir de moi"
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (bool? value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: const Color.fromARGB(255, 20, 82, 156),
                    ),
                    const Text("Se souvenir de moi"),
                  ],
                ),
                const SizedBox(height: 20),
                // Bouton de connexion
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
                      color: _isButtonPressed
                          ? const Color.fromARGB(255, 20, 82, 156)
                          : const Color.fromARGB(255, 20, 82, 156),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextButton(
                      onPressed: _startOtpProcess,
                      child: const Text(
                        "Se connecter",
                        style: TextStyle(
                          fontSize: 18,
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
      ),
    );
  }
}

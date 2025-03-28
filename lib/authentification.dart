import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_app/otp_input.dart';
import 'dart:math';

class Authentification extends StatefulWidget {
  @override
  _AuthentificationState createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  final _domainController = TextEditingController();
  bool _isButtonPressed = false;
  bool _rememberMe = false;
  String predefinedDomain = "exemple.com";

  @override
  void initState() {
    super.initState();
    _loadSavedDomain(); // Chargement des données enregistrées
  }

  // 🔹 Charger le domaine enregistré si disponible
  Future<void> _loadSavedDomain() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDomain = prefs.getString("savedDomain");
    bool? remember = prefs.getBool("rememberMe");

    if (remember == true && savedDomain != null) {
      setState(() {
        _domainController.text = savedDomain;
        _rememberMe = remember!;
      });
    }
  }

  // 🔹 Sauvegarder le domaine si "Se souvenir de moi" est coché
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

  // 🔹 Gérer la connexion et la redirection vers OTP
  void _startOtpProcess() async {
    if (_domainController.text == predefinedDomain) {
      await _saveDomain(); // Sauvegarde des données

      String generatedOtp = _generateOtp();
      Navigator.push(
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

  // 🔹 Générer un OTP aléatoire
  String _generateOtp() {
    final random = Random();
    return List.generate(4, (index) => random.nextInt(10)).join();
  }

  @override
  void dispose() {
    _domainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 226),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 Titre stylisé
              const Text(
                "Connexion",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 22, 20, 119),
                  shadows: [
                    Shadow(color: Color.fromARGB(255, 96, 84, 204), offset: Offset(0, 0), blurRadius: 10)
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Entrez votre domaine pour continuer",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 16),
              ),
              const SizedBox(height: 30),

              // 🔹 Champ de texte
              TextField(
                controller: _domainController,
                decoration: InputDecoration(
                  labelText: "Votre domaine",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 22, 20, 119), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color.fromARGB(255, 22, 20, 119), width: 2),
                  ),
                  prefixIcon: const Icon(Icons.domain, color: Color.fromARGB(255, 22, 20, 119)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Case à cocher "Se souvenir de moi"
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    activeColor: const Color.fromARGB(255, 22, 20, 119),
                  ),
                  const Text("Se souvenir de moi"),
                ],
              ),

              const SizedBox(height: 20),

              // 🔹 Bouton "Se connecter" avec animation au clic
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
                    color: _isButtonPressed ? const Color.fromARGB(255, 22, 20, 119) : const Color.fromARGB(255, 22, 20, 119),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 22, 20, 119).withOpacity(0.5),
                        offset: const Offset(0, 4),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: _startOtpProcess,
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

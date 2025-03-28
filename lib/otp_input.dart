import 'package:flutter/material.dart';
import 'transitionpage.dart';  // Assure-toi que TransitionPage est correctement importé

class OtpInput extends StatefulWidget {
  final String otp; // OTP généré à partir de la page précédente
  OtpInput({required this.otp});

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  bool _isOtpValid = false; // Indicateur de validation de l'OTP

  // Vérifier si l'OTP entré est correct
  void _validateOtp() {
    String enteredOtp = _controllers.map((controller) => controller.text).join();
    setState(() {
      _isOtpValid = enteredOtp == widget.otp;
    });

    // Si l'OTP est valide, afficher un message de succès et naviguer vers la page TransitionPage
    if (_isOtpValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP valide !"),
          backgroundColor: Colors.green,
        ),
      );

      // Naviguer vers la page TransitionPage
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TransitionPage()),  // Redirection vers la page de transition
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP incorrect, réessayez."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 226),
      appBar: AppBar(
        title: const Text("Vérification OTP"),
        backgroundColor: const Color.fromARGB(255, 25, 10, 110),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Entrez le code envoyé",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 22, 20, 119)),
              textAlign: TextAlign.center),
              const SizedBox(height: 20),
              
              // Affichage du message avec l'OTP généré
              Text(
                "Votre code est : ${widget.otp}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 22, 20, 119)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Champ OTP avec 4 entrées pour chaque chiffre
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: TextField(
                        controller: _controllers[index],
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color.fromARGB(255, 22, 20, 119), width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color.fromARGB(255, 22, 20, 119), width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus(); // Passer à la prochaine case
                          }
                          if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus(); // Revenir à la case précédente si effacé
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // Bouton de validation
              ElevatedButton(
                onPressed: _validateOtp,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color.fromARGB(255, 22, 20, 119),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text(
                  "Valider OTP",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              // Affichage de l'état de l'OTP
              if (_isOtpValid)
                const Text(
                  "OTP valide, bienvenue !",
                  style: TextStyle(fontSize: 18, color: Colors.green),
                )
              else
                const Text(
                  ".",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'webview_page.dart';  // Importez la page WebView

class OtpInput extends StatefulWidget {
  final String otp;
  OtpInput({required this.otp});

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  bool _isOtpValid = false;

  void _validateOtp() async {
    String enteredOtp = _controllers.map((controller) => controller.text).join();
    setState(() {
      _isOtpValid = enteredOtp == widget.otp;
    });

    if (_isOtpValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("OTP valide !"),
          backgroundColor: Colors.green,
        ),
      );
      await _saveAuthentication();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WebViewPage()),
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

  Future<void> _saveAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isAuthenticated", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 212, 205),
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
              ),
              const SizedBox(height: 20),
              Text(
                "Votre code est : ${widget.otp}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 22, 20, 119)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
                            FocusScope.of(context).nextFocus();
                          }
                          if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}

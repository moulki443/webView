import 'package:flutter/material.dart';
import 'webview_page.dart'; // Import de la page WebViewPage

class TransitionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Délai avant de rediriger vers la WebViewPage (2 secondes ici)
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WebViewPage()), // Rediriger vers la WebViewPage
      );
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 232, 236, 197),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Merci pour votre vérification !',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 86, 206, 56),
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

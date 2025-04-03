import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'authentification.dart'; // Importer la page d'authentification

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _controller;

  // Fonction pour déconnecter l'utilisateur et rediriger vers la page d'authentification
  Future<void> _logout() async {
    final cookieManager = CookieManager.instance();
    await cookieManager.deleteAllCookies(); // Supprimer tous les cookies

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Authentification()),
      );
    }
  }

  // Fonction pour naviguer en arrière dans la WebView
  void _goBack() async {
    if (_controller != null) {
      bool canGoBack = await _controller!.canGoBack();
      if (canGoBack) {
        await _controller!.goBack();
      } else {
        Navigator.pop(context);
      }
    }
  }

  // Fonction pour recharger la page
  void _reloadPage() {
    _controller?.reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        automaticallyImplyLeading: false, // Supprime la flèche de retour par défaut
      ),
      // Encapsulation dans SafeArea pour éviter l'overflow sur certains écrans
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri("https://manag.martech.management/admin/login"),
                ),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                    useOnLoadResource: true,
                    mediaPlaybackRequiresUserGesture: false,
                  ),
                  android: AndroidInAppWebViewOptions(useHybridComposition: true),
                ),
                onWebViewCreated: (controller) {
                  _controller = controller;
                },
                onLoadError: (controller, url, code, message) {
                  print("Erreur de chargement : $message");
                },
                onLoadHttpError: (controller, url, statusCode, description) {
                  print("Erreur HTTP : $description");
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: const Color.fromARGB(255, 211, 196, 196),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(width: 11),
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text("Déconnexion"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 11),
                  ElevatedButton.icon(
                    onPressed: _reloadPage,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Recharger"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

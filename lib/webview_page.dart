import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'authentification.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _controller;

  Future<void> _logout() async {
    final cookieManager = CookieManager.instance();
    await cookieManager.deleteAllCookies();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Authentification()),
      );
    }
  }

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

  void _reloadPage() {
    _controller?.reload();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        automaticallyImplyLeading: false,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
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
                  android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                  ),
                ),
                onWebViewCreated: (controller) {
                  _controller = controller;
                },
                onLoadError: (controller, url, code, message) {
                  debugPrint("Erreur de chargement : $message");

                  // Injecter un message d'alerte avec animation CSS
                  _controller?.evaluateJavascript(source: """
                    // Ajouter une animation CSS à l'alerte
                    let alertMessage = document.createElement('div');
                    alertMessage.innerText = 'Aucune connexion Internet détectée. Veuillez vérifier votre connexion et réessayer.';
                    alertMessage.style.position = 'fixed';
                    alertMessage.style.top = '50%';
                    alertMessage.style.left = '50%';
                    alertMessage.style.transform = 'translate(-50%, -50%)';
                    alertMessage.style.padding = '20px';
                    alertMessage.style.backgroundColor = '#f44336';
                    alertMessage.style.color = 'white';
                    alertMessage.style.fontSize = '16px';
                    alertMessage.style.fontWeight = 'bold';
                    alertMessage.style.borderRadius = '8px';
                    alertMessage.style.boxShadow = '0px 4px 10px rgba(0,0,0,0.2)';
                    alertMessage.style.opacity = '0';
                    alertMessage.style.transition = 'opacity 1s ease-in-out';
                    document.body.appendChild(alertMessage);

                    // Animation de l'alerte
                    setTimeout(function() {
                      alertMessage.style.opacity = '1';
                    }, 100);

                    // Supprimer l'alerte après 5 secondes
                    setTimeout(function() {
                      alertMessage.style.opacity = '0';
                      setTimeout(function() {
                        alertMessage.remove();
                      }, 1000);
                    }, 5000);
                  """);
                },
                onLoadHttpError: (controller, url, statusCode, description) {
                  debugPrint("Erreur HTTP : $description");

                  // Injecter un message d'alerte avec animation CSS
                  _controller?.evaluateJavascript(source: """
                    let alertMessage = document.createElement('div');
                    alertMessage.innerText = 'Erreur de connexion. Veuillez vérifier votre connexion Internet.';
                    alertMessage.style.position = 'fixed';
                    alertMessage.style.top = '50%';
                    alertMessage.style.left = '50%';
                    alertMessage.style.transform = 'translate(-50%, -50%)';
                    alertMessage.style.padding = '20px';
                    alertMessage.style.backgroundColor = '#f44336';
                    alertMessage.style.color = 'white';
                    alertMessage.style.fontSize = '16px';
                    alertMessage.style.fontWeight = 'bold';
                    alertMessage.style.borderRadius = '8px';
                    alertMessage.style.boxShadow = '0px 4px 10px rgba(0,0,0,0.2)';
                    alertMessage.style.opacity = '0';
                    alertMessage.style.transition = 'opacity 1s ease-in-out';
                    document.body.appendChild(alertMessage);

                    setTimeout(function() {
                      alertMessage.style.opacity = '1';
                    }, 100);

                    setTimeout(function() {
                      alertMessage.style.opacity = '0';
                      setTimeout(function() {
                        alertMessage.remove();
                      }, 1000);
                    }, 5000);
                  """);
                },
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: theme.colorScheme.surfaceVariant,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text("Déconnexion"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.error,
                      foregroundColor: theme.colorScheme.onError,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _reloadPage,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Recharger"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
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

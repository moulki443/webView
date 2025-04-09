import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'authentification.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key, required this.showSuccessMessage});
  final bool showSuccessMessage;

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? _controller;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

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

  void _reloadPage() {
    _controller?.reload();
  }

  void _navigateTo(String url) {
    _controller?.loadUrl(
      urlRequest: URLRequest(url: WebUri(url)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            if (_controller != null && await _controller!.canGoBack()) {
              _controller!.goBack();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(""),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'home':
                  _navigateTo("https://manag.martech.management");
                  break;
                case 'dashboard':
                  _navigateTo("https://manag.martech.management/admin/dashboard");
                  break;
                case 'support':
                  _navigateTo("https://manag.martech.management/support");
                  break;
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'home',
                child: Text('Accueil'),
              ),
              const PopupMenuItem<String>(
                value: 'dashboard',
                child: Text('Tableau de bord'),
              ),
              const PopupMenuItem<String>(
                value: 'support',
                child: Text('Support'),
              ),
            ],
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_progress < 1.0)
              LinearProgressIndicator(value: _progress),
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
                onProgressChanged: (controller, progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
                onLoadStop: (controller, url) async {
                  if (isDark) {
                    await controller.evaluateJavascript(source: """
                      document.body.style.backgroundColor = '#121212';
                      document.body.style.color = '#ffffff';
                    """);
                  }
                },
                onLoadError: (controller, url, code, message) {
                  debugPrint("Erreur de chargement : $message");
                  _showErrorOverlay("Aucune connexion Internet détectée. Veuillez vérifier votre connexion et réessayer.");
                },
                onLoadHttpError: (controller, url, statusCode, description) {
                  debugPrint("Erreur HTTP : $description");
                  _showErrorOverlay("Erreur de connexion. Veuillez vérifier votre connexion Internet.");
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

  void _showErrorOverlay(String message) {
    _controller?.evaluateJavascript(source: """
      let alertMessage = document.createElement('div');
      alertMessage.innerText = '$message';
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
  }
}

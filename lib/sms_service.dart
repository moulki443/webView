/*import 'dart:convert';
import 'package:http/http.dart' as http;

class SmsService {
  final String apiUrl = 'https://v2.sms24.ma/api/sms/send';
  final String apiKey = 'd84904b7-941a-4448-bb23-b4bbbc9ca60f';  // Remplacez par votre API Key

  // Méthode pour envoyer un SMS (avec un OTP)
  Future<void> sendOtp(String phoneNumber, String otp) async {
    final postData = {
      print(jsonEncode({
   "to": phoneNumber,
   "message": "Votre code OTP est : $otp",
   "sender": "MonApp"
}))
 
        
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: json.encode(postData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Réponse de l\'API: $responseData');
      } else {
        print('Erreur lors de l\'envoi du SMS: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception lors de la requête HTTP: $e');
    }
  }
}
*/  
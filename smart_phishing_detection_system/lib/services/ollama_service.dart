import 'dart:convert';
import 'package:http/http.dart' as http;

/// Very small wrapper around the Ollama REST /api/chat endpoint.
class OllamaService {
  // If testing on a physical phone, replace localhost with your PC’s IPv4
  // e.g. 'http://192.168.1.123:11434/api/chat'
  static const String _baseUrl = 'http://localhost:11434/api/chat';
  static const String _model   = 'phishing-detector';   // ← your custom model tag

  /// Sends [userText] to Ollama, returns the assistant’s reply text.
  static Future<String> send(String userText) async {
    final res = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': _model,
        'messages': [
          {'role': 'user', 'content': userText}
        ],
        'stream': false,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('Ollama error ${res.statusCode}: ${res.body}');
    }

    final Map<String, dynamic> data = jsonDecode(res.body);
    // Response shape: { message: { role: "assistant", content: "..." }, ... }
    return data['message']['content'] as String;
  }
}
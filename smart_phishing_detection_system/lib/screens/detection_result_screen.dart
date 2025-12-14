import 'package:flutter/material.dart';

class DetectionResultScreen extends StatelessWidget {
  const DetectionResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example static mock results — replace later with real data
    final List<Map<String, dynamic>> sampleResults = [
      {
        'url': 'https://paypal-verification.com',
        'classification': 'Fake',
        'confidence': 93,
        'timestamp': '12:42 PM'
      },
      {
        'url': 'https://flutter.dev',
        'classification': 'Real',
        'confidence': 99,
        'timestamp': '12:43 PM'
      },
      {
        'url': 'http://bankofamerica-login-alert.net',
        'classification': 'Fake',
        'confidence': 88,
        'timestamp': '12:45 PM'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection Results'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: sampleResults.length,
        itemBuilder: (context, index) {
          final result = sampleResults[index];
          final bool isSafe = result['classification'] == 'Real';
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(
                isSafe ? Icons.verified : Icons.warning_amber_rounded,
                color: isSafe ? Colors.green : Colors.red,
                size: 36,
              ),
              title: Text(
                result['url'],
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              subtitle: Text(
                '${result['classification']}  |  Confidence: ${result['confidence']}%',
                style: TextStyle(
                  color: isSafe ? Colors.green[700] : Colors.red[700],
                ),
              ),
              trailing: Text(
                result['timestamp'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF003366),
        onPressed: () => Navigator.pop(context),
        label: const Text('Back'),
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
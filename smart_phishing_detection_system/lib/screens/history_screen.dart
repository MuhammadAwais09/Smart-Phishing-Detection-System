import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detection History'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 5,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            leading: Icon(
              index.isEven ? Icons.verified : Icons.warning_amber_rounded,
              color: index.isEven ? Colors.green : Colors.red,
            ),
            title: Text('https://example${index + 1}.com'),
            subtitle: Text(index.isEven ? 'Safe URL' : 'Phishing Detected'),
            trailing: Text('12:${30 + index} PM'),
          ),
        ),
      ),
    );
  }
}
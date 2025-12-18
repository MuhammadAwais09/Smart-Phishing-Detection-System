import 'package:flutter/material.dart';
import '../services/ollama_service.dart';
import '../utils/test_samples.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scroll = ScrollController();

  /// Simple message model
  final List<_Message> _messages = [
    const _Message(role: Role.bot, text: "👋 Hi! I'm your AI Security Assistant.")
  ];

  bool _loading = false;

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _loading) return;

    setState(() {
      _messages.add(_Message(role: Role.user, text: text));
      _loading = true;
      _controller.clear();
    });
    _scrollToBottom();

    try {
      final reply = await OllamaService.send(text);
      setState(() {
        _messages.add(_Message(role: Role.bot, text: reply));
      });
    } catch (e) {
      setState(() {
        _messages.add(
          _Message(
            role: Role.bot,
            text: '⚠️ Error contacting Ollama: $e',
            isError: true,
          ),
        );
      });
    } finally {
      setState(() => _loading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() =>
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scroll.hasClients) {
          _scroll.jumpTo(_scroll.position.maxScrollExtent);
        }
      });

  Widget _buildQuickTests() {
    return ExpansionTile(
      title: const Text(
        'Quick Test Samples',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        ...TestSamples.phishingExamples.map(
          (s) => ListTile(
            title: Text(s['description']!),
            subtitle: Text(s['content']!),
            trailing: const Icon(Icons.warning, color: Colors.orange),
            onTap: () {
              _controller.text = s['content']!;
              setState(() {});
            },
          ),
        ),
        const Divider(),
        ...TestSamples.legitExamples.map(
          (s) => ListTile(
            title: Text(s['description']!),
            subtitle: Text(s['content']!),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
            onTap: () {
              _controller.text = s['content']!;
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                final isUser = m.role == Role.user;
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    constraints:
                        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .75),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF003366)
                          : (m.isError ? Colors.red[100] : Colors.grey[200]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      m.text,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Quick test expander
          _buildQuickTests(),
          const Divider(height: 0),

          // Input row
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Ask me about a URL, email, or SMS…',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                _loading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send, color: Color(0xFF003366)),
                        onPressed: _sendMessage,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper data structure
enum Role { user, bot }

class _Message {
  final Role role;
  final String text;
  final bool isError;
  const _Message({
    required this.role,
    required this.text,
    this.isError = false,
  });
}
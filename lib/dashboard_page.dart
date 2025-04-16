import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'state.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const ChatScreen(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InetCare AI Chat'),
        backgroundColor: Colors.grey[800],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.grey[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false;
  String? _sessionId;

  Future<String> _getBotResponse(String userText) async {
    setState(() => _isLoading = true);
    
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.doctorai),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': userText,
          'sessionId': _sessionId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _sessionId = data['sessionId'] ?? _sessionId;
        return data['response'];
      } else {
        return "Sorry, I'm having trouble responding. Please try again later.";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    
    setState(() {
      _messages.insert(0, ChatMessage(
        text: text,
        isUser: true,
      ));
    });

    _getBotResponse(text).then((response) {
      setState(() {
        _messages.insert(0, ChatMessage(
          text: response,
          isUser: false,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[200],
          child: const Text(
            'Ask me about health concerns. I can help with symptoms, conditions, and general health advice.',
            style: TextStyle(fontSize: 14, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
        ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        const Divider(height: 1.0),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: _buildTextComposer(),
        ),
      ],
    );
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Flexible(
          child: TextField(
            controller: _textController,
            onSubmitted: _handleSubmitted,
            decoration: InputDecoration(
              hintText: 'Type your health question...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          color: Colors.grey[700],
          onPressed: () => _handleSubmitted(_textController.text),
        ),
      ],
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: isUser 
                ? Colors.grey[400]
                : Colors.grey[600],
            child: Icon(
              isUser ? Icons.person : Icons.medical_services,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUser ? 'You' : 'InetCare AI',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.grey[200] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
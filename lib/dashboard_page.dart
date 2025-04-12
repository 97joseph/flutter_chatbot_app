import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AfyaAI Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCategoryCard(
              context,
              icon: Icons.medical_services,
              title: 'General Health',
              color: Colors.blue,
              category: 'general_health',
            ),
            _buildCategoryCard(
              context,
              icon: Icons.coronavirus,
              title: 'Common Diseases',
              color: Colors.orange,
              category: 'common_diseases',
            ),
            _buildCategoryCard(
              context,
              icon: Icons.favorite,
              title: 'Sexual Health',
              color: Colors.pink,
              category: 'sexual_health',
            ),
            _buildCategoryCard(
              context,
              icon: Icons.child_care,
              title: 'Child Health',
              color: Colors.green,
              category: 'child_health',
            ),
            _buildCategoryCard(
              context,
              icon: Icons.child_care,
              title: 'Mental Health',
              color: Colors.purple,
              category: 'mental_health',
            ),
            _buildCategoryCard(
              context,
              icon: Icons.child_care,
              title: 'Elderly Care',
              color: Colors.teal,
              category: 'elderly_care',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required String category,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: color.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatbotPage(category: category),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatbotPage extends StatefulWidget {
  final String category;

  const ChatbotPage({super.key, required this.category});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();

  String _getCategoryDescription() {
    switch (widget.category) {
      case 'general_health':
        return 'Ask about general health concerns, nutrition, or wellness tips relevant to Kenya';
      case 'common_diseases':
        return 'Information about malaria, typhoid, cholera and other common diseases in Kenya';
      case 'sexual_health':
        return 'Confidential advice about STIs, family planning, and reproductive health';
      case 'child_health':
        return 'Pediatric advice, immunization schedules, and child wellness';
      case 'mental_health':
        return 'Support for stress, anxiety, depression and mental wellbeing';
      case 'elderly_care':
        return 'Geriatric care, chronic conditions and elderly health management';
      default:
        return 'How can I help you today?';
    }
  }

  String _getBotResponse(String userText) {
    userText = userText.toLowerCase();
    String categoryContext = '';

    switch (widget.category) {
      case 'general_health':
        categoryContext = 'general health in Kenya';
        if (userText.contains('nutrition') || userText.contains('diet')) {
          return 'For Kenyan dietary advice, consider traditional foods like ugali with sukuma wiki for balanced nutrition.';
        }
        break;
      case 'common_diseases':
        categoryContext = 'common diseases in Kenya';
        if (userText.contains('malaria')) {
          return 'Malaria is endemic in Kenya. Use mosquito nets and seek immediate treatment if you experience fever, chills, and headache.';
        }
        break;
      case 'sexual_health':
        categoryContext = 'sexual health in Kenya';
        if (userText.contains('hiv') || userText.contains('aids')) {
          return 'Kenya has free HIV testing and treatment centers nationwide. Practice safe sex and get regular testing.';
        }
        break;
      case 'child_health':
        categoryContext = 'child health in Kenya';
        if (userText.contains('vaccine') || userText.contains('immunization')) {
          return 'Kenya provides free childhood vaccines at public health facilities. The schedule includes BCG, polio, measles, and more.';
        }
        break;
    }

    if (userText.contains('hello') || userText.contains('hi')) {
      return 'Hello! I can help with ${categoryContext.isNotEmpty ? categoryContext : 'your health questions'}. What would you like to know?';
    } else if (userText.contains('help')) {
      return 'I specialize in ${categoryContext.isNotEmpty ? categoryContext : 'health information'}. Try asking specific questions about symptoms, prevention, or treatment.';
    } else {
      return "I understand you're asking about ${categoryContext.isNotEmpty ? categoryContext : 'health'}. For more specific advice, please provide more details about your concern.";
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

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.insert(0, ChatMessage(
          text: _getBotResponse(text),
          isUser: false,
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCategoryTitle(widget.category)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: _getCategoryColor(widget.category).withOpacity(0.1),
            child: Text(
              _getCategoryDescription(),
              style: const TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  String _getCategoryTitle(String category) {
    switch (category) {
      case 'general_health': return 'General Health';
      case 'common_diseases': return 'Common Diseases';
      case 'sexual_health': return 'Sexual Health';
      case 'child_health': return 'Child Health';
      case 'mental_health': return 'Mental Health';
      case 'elderly_care': return 'Elderly Care';
      default: return 'Health Assistant';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'general_health': return Colors.blue;
      case 'common_diseases': return Colors.orange;
      case 'sexual_health': return Colors.pink;
      case 'child_health': return Colors.green;
      case 'mental_health': return Colors.purple;
      case 'elderly_care': return Colors.teal;
      default: return Colors.blue;
    }
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: _getCategoryColor(widget.category)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: InputDecoration.collapsed(
                  hintText: 'Ask about ${_getCategoryTitle(widget.category)}...',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
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
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: isUser 
                ? Colors.grey[300]
                : Theme.of(context).primaryColor,
            child: Icon(
              isUser ? Icons.person : Icons.medical_services,
              color: isUser ? Colors.grey : Colors.white,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUser ? 'You' : 'AfyaAI',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
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
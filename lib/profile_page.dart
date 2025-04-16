import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userEmail = 'Loading...';
  String? _userName = 'Loading...';
  bool _isGuest = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userEmail = prefs.getString('userEmail') ?? 'Guest User';
      _userName = prefs.getString('userName') ?? 'InetCare AI User';
      _isGuest = prefs.getString('authToken') == null;
    });
  }

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken');
      
      if (token != null) {
        final response = await http.post(
          Uri.parse(ApiConfig.logout),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );

        if (response.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout failed. Please try again.')),
          );
        }
      }

      await prefs.remove('authToken');
      await prefs.remove('userEmail');
      await prefs.remove('userName');
      
      Navigator.pushReplacementNamed(context, '/signin');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.grey[800],
        actions: [
          if (!_isGuest)
            IconButton(
              icon: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.logout),
              onPressed: _isLoading ? null : _logout,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[400],
              child: const Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              _userName!,
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _userEmail!,
              style: TextStyle(color: Colors.grey[600]),
            ),
            if (_isGuest)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Guest Mode - Limited Features',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Card(
              color: Colors.grey[200],
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.grey[700]),
                    title: Text(
                      'About InetCare AI',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    subtitle: Text(
                      'Version 1.0.0',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    onTap: () => _showAboutDialog(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.help, color: Colors.grey[700]),
                    title: Text(
                      'Help Center',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    onTap: () => _showHelpInfo(context),
                  ),
                  ListTile(
                    leading: Icon(Icons.security, color: Colors.grey[700]),
                    title: Text(
                      'Data Security',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    onTap: () => _showSecurityInfo(context),
                  ),
                  if (!_isGuest)
                    ListTile(
                      leading: Icon(Icons.contact_support, color: Colors.grey[700]),
                      title: Text(
                        'Contact Support',
                        style: TextStyle(color: Colors.grey[800]),
                      ),
                      onTap: () => _showContactInfo(context),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About InetCare AI'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'InetCare AI is an advanced healthcare assistant providing reliable medical information and support.',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2023 InetCare Technologies',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help Center'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Frequently Asked Questions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• How to use InetCare AI'),
            const Text('• Understanding diagnosis suggestions'),
            const Text('• Medication information accuracy'),
            const SizedBox(height: 16),
            Text(
              'For more help, please visit our online help center or contact support.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSecurityInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Security'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your privacy and security are our top priorities:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• End-to-end encryption for all communications'),
            const Text('• HIPAA compliant data storage'),
            const Text('• No personal data shared with third parties'),
            const Text('• Regular security audits'),
            const SizedBox(height: 16),
            Text(
              'All health data is stored securely and anonymously.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showContactInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Support Options:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Email: support@inetcare.ai'),
            const Text('Phone: +254791040912'),
            const Text('24/7 Live Chat available in app'),
            const SizedBox(height: 16),
            Text(
              'Average response time: 2 hours',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.grey[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signin');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(  // Added scrollable wrapper
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
              'InetCare AI User',
              style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'user@inetcare.ai',
              style: TextStyle(color: Colors.grey[600]),
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
                    onTap: () {
                      _showAboutDialog(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help, color: Colors.grey[700]),
                    title: Text(
                      'Help Center',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    onTap: () {
                      _showHelpInfo(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.security, color: Colors.grey[700]),
                    title: Text(
                      'Data Security',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    onTap: () {
                      _showSecurityInfo(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.contact_support, color: Colors.grey[700]),
                    title: Text(
                      'Contact Support',
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                    onTap: () {
                      _showContactInfo(context);
                    },
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
        title: Text('About InetCare AI'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'InetCare AI is an advanced healthcare assistant providing reliable medical information and support.',
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
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
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showHelpInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help Center'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• How to use InetCare AI'),
            Text('• Understanding diagnosis suggestions'),
            Text('• Medication information accuracy'),
            SizedBox(height: 16),
            Text(
              'For more help, please visit our online help center or contact support.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSecurityInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Data Security'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your privacy and security are our top priorities:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• End-to-end encryption for all communications'),
            Text('• HIPAA compliant data storage'),
            Text('• No personal data shared with third parties'),
            Text('• Regular security audits'),
            SizedBox(height: 16),
            Text(
              'All health data is stored securely and anonymously.',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showContactInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support Options:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Email: support@inetcare.ai'),
            Text('Phone: +254791040912'),
            Text('24/7 Live Chat available in app'),
            SizedBox(height: 16),
            Text(
              'Average response time: 2 hours',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
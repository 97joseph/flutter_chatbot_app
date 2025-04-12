import 'package:flutter/material.dart';
import 'onboarding_screens.dart';
import 'signin_page.dart';
import 'profile_page.dart';
import 'dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AfyaAI - Kenyan Medical Chatbot',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[800],
          foregroundColor: Colors.white,
        ),
      ),
      home: const OnboardingScreens(),
      routes: {
        '/signin': (context) => const SignInPage(),
        '/profile': (context) => const ProfilePage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../features/auth/presentation/screens/login_screen.dart';

/// Root application widget configured with Resend-inspired minimalist dark theme.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resend Style Login',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF000000), // Pure OLED black
        colorScheme: const ColorScheme.dark(
          surface: Color(0xFF0A0A0C),
          primary: Colors.white,
          onPrimary: Colors.black,
          outline: Color(0xFF1F1F23),
          error: Color(0xFFEF4444),
        ),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme,
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

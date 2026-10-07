import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase (Firebase setup ke baad activate hoga)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase Initialization Error: $e");
  }

  runApp(const MSavingsNotesApp());
}

class MSavingsNotesApp extends StatelessWidget {
  const MSavingsNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MSavings & Notes',
      debugShowCheckedModeBanner: false,
      
      // Complete AMOLED Dark Theme (Pure Black #000000)
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.greenAccent,
          secondary: Colors.tealAccent,
          surface: Color(0xFF121212),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF141414),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.white10),
          ),
        ),
      ),
      home: const AnimatedSplashScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Musify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade300,
          foregroundColor: Color(0xFF00163F),
        ),
      ),
      home: FutureBuilder(
        future: Future.value(null),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.data == null) {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}

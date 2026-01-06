import 'package:flutter/material.dart';

import 'services/notes_service.dart';
import 'screens/home_screen.dart';

void main() async {
  final notesService = NotesService();
  await notesService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          primary: Colors.orange,
          surface: Colors.white,
          // background: Colors.white, // Deprecated
          onSurface: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

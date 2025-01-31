import 'package:flutter/material.dart';
import 'package:photo_editor/provider/app_image_provider.dart';
import 'package:photo_editor/screens/home_screen.dart';
import 'package:photo_editor/screens/start_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppImageProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: <String, WidgetBuilder>{
        '/': (_) => StartScreen(),
        '/home': (_) => HomeScreen(),
      },
      initialRoute: '/',
      // home: const StartScreen(),
    );
  }
}

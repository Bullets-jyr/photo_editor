import 'package:flutter/material.dart';
import 'package:photo_editor/provider/app_image_provider.dart';
import 'package:photo_editor/screens/adjust_screen.dart';
import 'package:photo_editor/screens/blur_screen.dart';
import 'package:photo_editor/screens/crop_screen.dart';
import 'package:photo_editor/screens/filter_screen.dart';
import 'package:photo_editor/screens/fit_screen.dart';
import 'package:photo_editor/screens/home_screen.dart';
import 'package:photo_editor/screens/start_screen.dart';
import 'package:photo_editor/screens/tint_screen.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Photo Editor',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF111111),
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Colors.black,
          centerTitle: true,
          elevation: 0,
        ),
        sliderTheme: SliderThemeData(
          showValueIndicator: ShowValueIndicator.always
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: <String, WidgetBuilder>{
        '/': (_) => StartScreen(),
        '/home': (_) => HomeScreen(),
        '/crop': (_) => CropScreen(),
        '/filter': (_) => FilterScreen(),
        '/adjust': (_) => AdjustScreen(),
        '/fit': (_) => FitScreen(),
        '/tint': (_) => TintScreen(),
        '/blur': (_) => BlurScreen(),
      },
      initialRoute: '/',
      // home: const StartScreen(),
    );
  }
}

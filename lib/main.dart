import 'package:cleancode/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:cleancode/injector.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: const NumberTriviaPage(),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF00334e),
          primaryVariant: Color(0xFF145374),
          secondary: Color(0xFF5588a3),
          secondaryVariant: Color(0xFF73C1EB),
          surface: Color(0xFFe8e8e8),
          background: Color(0xFFe8e8e8),
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF00334e),
          primaryVariant: Color(0xFF145374),
          secondary: Color(0xFF5588a3),
          secondaryVariant: Color(0xFF73C1EB),
          surface: Color(0xFF28292B),
          background: Color(0xFF202124),
          error: Colors.red,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
    );
  }
}

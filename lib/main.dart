import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'controllers/auth_controller.dart';
import 'controllers/map_controller.dart';
import 'screens/login_screen.dart';
import 'screens/home_page.dart';
import 'views/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env.example');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => MapController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // récupère utilisateur connecté

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guide Touristique Local',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: user != null ? const HomePage() : const LoginScreen(),
      routes: {
        '/map': (context) => const MapScreen(),
      },
    );
  }
}

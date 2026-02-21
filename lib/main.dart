import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'controllers/map_controller.dart';
import 'views/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env.example');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Guide Touristique Local',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MapScreen(),
        routes: {
          '/map': (context) => const MapScreen(),
        },
      ),
    );
  }
}

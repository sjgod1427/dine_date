import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_date/components/user_preferences.dart';
import 'package:dine_date/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:user_repository/user_repository.dart';
import 'app.dart';
import 'simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserPreferences(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const SplashScreen(),
          '/app': (context) => MyApp(
                FirebaseUserRepo(),
                FirebaseAuth.instance,
                FirebaseFirestore.instance,
              ),
        },
      ),
    ),
  );
}

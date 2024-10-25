import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_date/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'app.dart';
import 'simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  runApp(MaterialApp(routes: {
    '/': (context) => const SplashScreen(),
    '/app': (context) => MyApp(
        FirebaseUserRepo(), FirebaseAuth.instance, FirebaseFirestore.instance)
  }));
}

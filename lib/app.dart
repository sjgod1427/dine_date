import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_date/app_view.dart';
import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dine_date/app_view.dart';
import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  const MyApp(this.userRepository, this.firebaseAuth, this.firestore,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc(
            userRepository: userRepository,
            firebaseAuth: firebaseAuth,
            firestore: firestore),
        child: MyAppView());
  }
}

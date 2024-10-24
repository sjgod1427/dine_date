import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:dine_date/components/persisitent_nav.dart';
import 'package:dine_date/screens/auth/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.light(
              surface: Colors.grey.shade200,
              onSurface: const Color.fromARGB(255, 147, 32, 115),
              primary: const Color.fromARGB(255, 177, 7, 112),
              onPrimary: Colors.black,
              secondary: const Color.fromARGB(255, 42, 79, 153),
              onSecondary: Colors.white,
              tertiary: const Color.fromARGB(255, 109, 87, 209),
              error: Colors.red,
              outline: const Color(0xFF424242)),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
            builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return PersistentTabScreen();
          } else {
            return const WelcomeScreen();
          }
        }));
  }
}

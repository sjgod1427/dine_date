import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:dine_date/components/persisitent_nav.dart';
import 'package:dine_date/screens/auth/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.light(
              surface: Colors.grey.shade200,
              onSurface: const Color.fromARGB(255, 147, 32, 115),
              primary: const Color.fromARGB(255, 217, 121, 121),
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
            // return PersistentTabScreen();
            return FutureBuilder(
                future: _determinePosition(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    context
                        .read<AuthenticationBloc>()
                        .userRepository
                        .setupLocation(snap.data!.latitude,
                            snap.data!.longitude, state.user!);
                  }
                  return const PersistentTabScreen();
                });
          } else {
            return const WelcomeScreen();
          }
        }));
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

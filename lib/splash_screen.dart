import 'dart:async';

import 'package:dine_date/app.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:user_repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() {
    var duration = const Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    // Navigator.pushReplacementNamed(context, '/app');
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        settings: RouteSettings(name: '/app'),
        transitionDuration: Duration(seconds: 5), // Name of the route
        pageBuilder: (context, animation, secondaryAnimation) => MyApp(
            FirebaseUserRepo(),
            FirebaseAuth.instance,
            FirebaseFirestore
                .instance), // Directly refer to the widget of the route
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0); // Slide from the bottom
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: content(),
    );
  }
}

Widget content() {
  return Center(
    child: Container(
        child:
            Lottie.asset('assets/animations/Animation - 1729742973034.json')),
  );
}

// import 'dart:async';
// import 'package:dine_date/app.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:user_repository/user_repository.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreen();
// }

// class _SplashScreen extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }

//   startTimer() {
//     var duration = const Duration(seconds: 10);
//     return Timer(duration, route);
//   }

//   route() {
//     Navigator.pushReplacement(
//       context,
//       PageRouteBuilder(
//         settings: const RouteSettings(name: '/app'),
//         transitionDuration: const Duration(seconds: 5),
//         pageBuilder: (context, animation, secondaryAnimation) => MyApp(
//             FirebaseUserRepo(),
//             FirebaseAuth.instance,
//             FirebaseFirestore.instance),
//         transitionsBuilder: (context, animation, secondaryAnimation, child) {
//           return FadeTransition(
//             opacity: animation,
//             child: child,
//           );
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(20.0),
//           child: Lottie.asset(
//             'assets/animations/Animation - 1729742973034.json',
//             width: 400, // Set constraints if needed
//             height: 400,
//           ),
//         ),
//       ),
//     );
//   }
// }

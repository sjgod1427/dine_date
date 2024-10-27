// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dine_date/splash_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:user_repository/user_repository.dart';
// import 'app.dart';
// import 'simple_bloc_observer.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   Bloc.observer = SimpleBlocObserver();
//   runApp(MaterialApp(routes: {
//     '/': (context) => const SplashScreen(),
//     '/app': (context) => MyApp(
//         FirebaseUserRepo(), FirebaseAuth.instance, FirebaseFirestore.instance)
//   }));
// }
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
//import 'user_preferences.dart'; // Import UserPreferences class
//import 'main_drawer.dart'; // Import MainDrawer class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();

  runApp(
    ChangeNotifierProvider(
      create: (context) => UserPreferences(),
      child: MaterialApp(
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

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
// import 'package:dine_date/blocs/setup_data_bloc/setup_data_bloc.dart';
// import 'package:dine_date/components/user_preferences.dart';
// import 'package:dine_date/screens/auth/blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
// import 'package:dine_date/splash_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:provider/provider.dart';
// import 'package:user_repository/user_repository.dart';
// import 'app.dart';
// import 'simple_bloc_observer.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   Bloc.observer = SimpleBlocObserver();

//   runApp(
//     MultiProvider(
//       providers: [
//         Provider<UserRepository>(
//           create: (context) => FirebaseUserRepo(),
//         ),
//         ChangeNotifierProvider(
//           create: (context) => UserPreferences(),
//         ),
//       ],
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (context) => AuthenticationBloc(
//               userRepository: context.read<UserRepository>(),
//               firebaseAuth: FirebaseAuth.instance,
//               firestore: FirebaseFirestore.instance,
//             ),
//           ),
//           BlocProvider(
//             create: (context) => SignInBloc(
//               userRepository: context.read<AuthenticationBloc>().userRepository,
//             ),
//           ),
//           BlocProvider(
//             create: (context) => SetupDataBloc(
//               context.read<AuthenticationBloc>().userRepository,
//             ),
//           ),
//         ],
//         child: MaterialApp(
//           routes: {
//             '/': (context) => const SplashScreen(),
//             '/app': (context) => MyApp(
//                   context.read<UserRepository>(),
//                   FirebaseAuth.instance,
//                   FirebaseFirestore.instance,
//                 ),
//           },
//         ),
//       ),
//     ),
//   );
// }

// import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
// import 'package:dine_date/blocs/setup_data_bloc/setup_data_bloc.dart';
// import 'package:dine_date/screens/auth/blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:user_repository/user_repository.dart';

// import 'components/user_preferences.dart';
// import 'app.dart';
// import 'splash_screen.dart';
// import 'simple_bloc_observer.dart';
// //import 'user_repository/user_repository.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   Bloc.observer = SimpleBlocObserver();

//   runApp(
//     MultiProvider(
//       providers: [
//         Provider<UserRepository>(
//           create: (_) => FirebaseUserRepo(),
//         ),
//         ChangeNotifierProvider(
//           create: (_) => UserPreferences(),
//         ),
//       ],
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (context) => AuthenticationBloc(
//               userRepository: context.read<UserRepository>(),
//               firebaseAuth: FirebaseAuth.instance,
//               firestore: FirebaseFirestore.instance,
//             ),
//           ),
//           BlocProvider(
//             create: (context) => SignInBloc(
//               userRepository: context.read<AuthenticationBloc>().userRepository,
//             ),
//           ),
//           BlocProvider(
//             create: (context) => SetupDataBloc(
//               context.read<AuthenticationBloc>().userRepository,
//             ),
//           ),
//         ],
//         child: MaterialApp(
//           routes: {
//             '/': (context) => const SplashScreen(),
//             '/app': (context) => MyApp(
//                   context.read<UserRepository>(),
//                   FirebaseAuth.instance,
//                   FirebaseFirestore.instance,
//                 ),
//           },
//         ),
//       ),
//     ),
//   );
// }

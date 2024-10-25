// import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
// import 'package:dine_date/blocs/setup_data_bloc/setup_data_bloc.dart';
// //import 'package:dine_date/screens/auth/blocs/setup_data_bloc/setup_data_bloc.dart';
// import 'package:dine_date/screens/auth/blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
// import 'package:dine_date/screens/auth/views/sign_in_screen.dart';
// import 'package:dine_date/screens/home/views/home_screen.dart';
// import 'package:dine_date/screens/profile/views/profile_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
// import 'package:rive/rive.dart' hide Image;

// class PersistentTabScreen extends StatefulWidget {
//   const PersistentTabScreen({
//     super.key,
//   });

//   @override
//   State<PersistentTabScreen> createState() {
//     return _PersistantTabScreenState();
//   }
// }

// class _PersistantTabScreenState extends State<PersistentTabScreen> {
//   final PersistentTabController _controller = PersistentTabController();
//   late Color dynamicColor;

//   List<Widget> _buildScreen() {
//     return [
//       HomeScreen(),
//       BlocProvider(
//           create: (context) => SignInBloc(
//               userRepository:
//                   context.read<AuthenticationBloc>().userRepository),
//           child: const ProfileScreen())
//     ];
//   }

//   @override
//   void initState() {
//     dynamicColor = const Color(0xFFFe3c72);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//       screenTransitionAnimation: ScreenTransitionAnimation(
//           curve: Curves.ease, duration: Duration(milliseconds: 200)),
//       controller: _controller,
//       tabs: [
//         PersistentTabConfig(
//           screen: HomeScreen(),
//           item: ItemConfig(
//               icon: Image.asset(
//                 "assets/icons/Date.png",
//                 color: dynamicColor,
//                 scale: .5,
//               ),
//               title: "Find",
//               iconSize: 50,
//               activeForegroundColor: dynamicColor),
//         ),
//         PersistentTabConfig(
// screen: MultiBlocProvider(
//   providers: [
//     BlocProvider(
//       create: (context) => SignInBloc(
//           userRepository:
//               context.read<AuthenticationBloc>().userRepository),
//     ),
//     BlocProvider(
//       create: (context) => SetupDataBloc(
//           context.read<AuthenticationBloc>().userRepository),
//     )
//   ],
//   child: const ProfileScreen(),
// ),
//           item: ItemConfig(
//               icon: Icon(
//                 CupertinoIcons.person_fill,
//                 size: 25,
//                 // color: dynamicColor,
//               ),
//               title: "Profile",
//               activeForegroundColor: Theme.of(context).colorScheme.primary,
//               inactiveForegroundColor: Colors.grey),
//         ),
//       ],
//       navBarBuilder: (navBarConfig) => Style1BottomNavBar(
//         navBarConfig: navBarConfig,
//       ),
//     );
//   }
// }

import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:dine_date/blocs/setup_data_bloc/setup_data_bloc.dart';
import 'package:dine_date/screens/auth/blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:dine_date/screens/home/views/home_screen.dart';
import 'package:dine_date/screens/profile/views/profile_screen.dart';
import 'package:flutter/material.dart'; // Ensure you import the required Flutter material packages
//import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart'; // Import the package
import 'package:flutter_bloc/flutter_bloc.dart'; // Ensure other imports you need

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersistentTabScreen extends StatefulWidget {
  const PersistentTabScreen({Key? key}) : super(key: key);

  @override
  State<PersistentTabScreen> createState() => _PersistentTabScreenState();
}

class _PersistentTabScreenState extends State<PersistentTabScreen> {
  int _currentIndex = 0; // Track the current index
  final List<Widget> _screens = [
    HomeScreen(), // Your Home Screen widget
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignInBloc(
              userRepository:
                  context.read<AuthenticationBloc>().userRepository),
        ),
        BlocProvider(
          create: (context) =>
              SetupDataBloc(context.read<AuthenticationBloc>().userRepository),
        )
      ],
      child: const ProfileScreen(),
    ),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[
              _currentIndex], // Show the appropriate screen based on the selected index
          Positioned(
            bottom: 10, // Position above the bottom of the screen
            left: 20, // Optional: Add some spacing from the left
            right: 20, // Optional: Add some spacing from the right
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 243, 132, 132),
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
            bottom: Radius.circular(20)), // Rounded top corners
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Aligns icons evenly
        children: [
          _buildNavItem(Icons.wine_bar_outlined, 0, context),
          _buildNavItem(Icons.person, 1, context),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, BuildContext context) {
    final bool isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the icons
        children: [
          AnimatedContainer(
            duration:
                Duration(milliseconds: 300), // Duration for smooth animation
            curve: Curves.easeInOut, // Animation curve
            child: Icon(
              icon,
              size: 30, // Set the icon size
              color: isSelected
                  ? Colors.white
                  : const Color.fromARGB(
                      255, 232, 190, 190), // Color based on selection
            ),
          ),
          if (isSelected)
            Container(
              height: 2, // Height of the underline indicator
              width: 30, // Width of the underline indicator
              color: Theme.of(context).primaryColor, // Color of the indicator
            ),
        ],
      ),
    );
  }
}

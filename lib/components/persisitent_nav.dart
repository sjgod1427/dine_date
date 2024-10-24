import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:dine_date/blocs/setup_data_bloc/setup_data_bloc.dart';
//import 'package:dine_date/screens/auth/blocs/setup_data_bloc/setup_data_bloc.dart';
import 'package:dine_date/screens/auth/blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:dine_date/screens/auth/views/sign_in_screen.dart';
import 'package:dine_date/screens/home/views/home_screen.dart';
import 'package:dine_date/screens/profile/views/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:rive/rive.dart' hide Image;

class PersistentTabScreen extends StatefulWidget {
  const PersistentTabScreen({
    super.key,
  });

  @override
  State<PersistentTabScreen> createState() {
    return _PersistantTabScreenState();
  }
}

class _PersistantTabScreenState extends State<PersistentTabScreen> {
  final PersistentTabController _controller = PersistentTabController();
  late Color dynamicColor;

  List<Widget> _buildScreen() {
    return [
      HomeScreen(),
      BlocProvider(
          create: (context) => SignInBloc(
              userRepository:
                  context.read<AuthenticationBloc>().userRepository),
          child: const ProfileScreen())
    ];
  }

  // List<Persistent> _navBarsItems() {
  //   return [
  //     PersistentBottomNavBarItem(
  //       icon: Image.asset(
  // 				"assets/tinder_logo.png",
  // 				scale: 16,
  // 				color: dynamicColor,
  // 			),
  //     ),
  // 		PersistentBottomNavBarItem(
  //       icon: const Icon(CupertinoIcons.person_fill, size: 30,),
  //       activeColorPrimary: Theme.of(context).colorScheme.primary,
  //       inactiveColorPrimary: Colors.grey,
  //     ),
  //   ];
  // }

  // List<PersistentTabConfig> _tabitem{
  //   return[];
  // }

  @override
  void initState() {
    dynamicColor = const Color(0xFFFe3c72);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      screenTransitionAnimation: ScreenTransitionAnimation(
          curve: Curves.ease, duration: Duration(milliseconds: 200)),
      controller: _controller,
      tabs: [
        PersistentTabConfig(
          screen: HomeScreen(),
          item: ItemConfig(
              icon: Image.asset(
                "assets/icons/Date.png",
                color: dynamicColor,
                scale: .5,
              ),
              title: "Find",
              iconSize: 50,
              activeForegroundColor: dynamicColor),
        ),
        PersistentTabConfig(
          screen: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => SignInBloc(
                    userRepository:
                        context.read<AuthenticationBloc>().userRepository),
              ),
              BlocProvider(
                create: (context) => SetupDataBloc(
                    context.read<AuthenticationBloc>().userRepository),
              )
            ],
            child: const ProfileScreen(),
          ),
          item: ItemConfig(
              icon: Icon(
                CupertinoIcons.person_fill,
                size: 25,
                // color: dynamicColor,
              ),
              title: "Profile",
              activeForegroundColor: Theme.of(context).colorScheme.primary,
              inactiveForegroundColor: Colors.grey),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}

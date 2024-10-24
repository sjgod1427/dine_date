import 'dart:ui';

import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:dine_date/screens/auth/blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:dine_date/screens/auth/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:dine_date/screens/auth/views/sign_in_screen.dart';
import 'package:dine_date/screens/auth/views/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' hide Image;

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() {
    return _WelcomeScreen();
  }
}

class _WelcomeScreen extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  var animationLink = 'assets/animations/animated_login_screen.riv';
  late SMITrigger failTrigger, successTrigger;
  late SMIBool isChecking, isHandsUp;
  late SMINumber lookNum;
  Artboard? artboard;
  late StateMachineController? statemachineController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    initArtBoard();
    super.initState();
  }

  // initArtBoard() {
  //   rootBundle.load(animationLink).then((value) async {
  //     await RiveFile.initialize();
  //     final file = RiveFile.import(value);
  //     final art = file.mainArtboard;
  //     statemachineController =
  //         StateMachineController.fromArtboard(art, "Login Machine")!;

  //     if (statemachineController != null) {
  //       art.addController(statemachineController!);
  //       for (var element in statemachineController!.inputs) {
  //         if (element.name == "isChecking") {
  //           isChecking = element as SMIBool;
  //         } else if (element.name == "isHandsUp") {
  //           isHandsUp = element as SMIBool;
  //         } else if (element.name == "trigSuccess") {
  //           successTrigger = element as SMITrigger;
  //         } else if (element.name == "trigFail") {
  //           failTrigger = element as SMITrigger;
  //         } else if (element.name == "numLook") {
  //           lookNum = element as SMINumber;
  //         }
  //       }
  //       setState(() {
  //         artboard = art;
  //       });
  //     }
  //   });
  // }

  void initArtBoard() {
    rootBundle.load(animationLink).then((value) async {
      await RiveFile.initialize();
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      statemachineController =
          StateMachineController.fromArtboard(art, "Login Machine");

      if (statemachineController != null) {
        art.addController(statemachineController!);
        // Initialize the triggers and bools if the controller is not null
        for (var element in statemachineController!.inputs) {
          if (element.name == "isChecking") {
            isChecking = element as SMIBool;
            print("isChecking initialized");
          } else if (element.name == "isHandsUp") {
            isHandsUp = element as SMIBool;
            print("isHandsUp initialized");
          } else if (element.name == "trigSuccess") {
            successTrigger = element as SMITrigger;
            print("successTrigger initialized");
          } else if (element.name == "trigFail") {
            failTrigger = element as SMITrigger;
            print("failTrigger initialized");
          } else if (element.name == "numLook") {
            lookNum = element as SMINumber;
            print("lookNum initialized");
          }
        }

        setState(() {
          artboard = art;
          print("Artboard set");
        });
      } else {
        // Handle the case where the state machine controller is null
        print("State Machine Controller not found.");
      }
    }).catchError((error) {
      // Handle any errors that occur during loading
      print("Error loading Rive file: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(20, -1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
                Align(
                  alignment: const Alignment(2.7, -1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width / 1.3,
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                Align(
                  alignment: const Alignment(-2.7, -1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width / 1.3,
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                  child: Container(),
                ),
                Align(
                  alignment: const Alignment(-20, 1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ),
                Align(
                  alignment: const Alignment(-2.7, 1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width / 1.3,
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
                Align(
                  alignment: const Alignment(2.7, 1.2),
                  child: Container(
                    height: MediaQuery.of(context).size.width / 1.3,
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 150.0, sigmaY: 150.0),
                  child: Container(),
                ),
                if (artboard != null)
                  SizedBox(
                      width: 400,
                      height: 350,
                      child: Rive(artboard: artboard!)),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.6,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: TabBar(
                            controller: tabController,
                            unselectedLabelColor: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.5),
                            labelColor: Theme.of(context).colorScheme.onSurface,
                            tabs: [
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: TabBarView(
                          controller: tabController,
                          children: [
                            // SignInScreen(),
                            // SingleChildScrollView(child: SignUpScreen()),
                            BlocProvider<SignInBloc>(
                              create: (context) => SignInBloc(
                                  userRepository: context
                                      .read<AuthenticationBloc>()
                                      .userRepository),
                              child: SignInScreen(
                                  isChecking: isChecking,
                                  isHandsUp: isHandsUp,
                                  successTrigger: successTrigger,
                                  failTrigger: failTrigger,
                                  lookNum: lookNum),
                            ),
                            BlocProvider<SignUpBloc>(
                              create: (context) => SignUpBloc(
                                  userRepository: context
                                      .read<AuthenticationBloc>()
                                      .userRepository),
                              child: SignUpScreen(
                                  isChecking: isChecking,
                                  isHandsUp: isHandsUp,
                                  successTrigger: successTrigger,
                                  failTrigger: failTrigger,
                                  lookNum: lookNum),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

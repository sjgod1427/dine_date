import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:dine_date/blocs/setup_data_bloc/setup_data_bloc.dart';
import 'package:dine_date/components/persisitent_nav.dart';
import 'package:dine_date/screens/auth/blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:dine_date/components/my_text_field.dart';
import 'package:dine_date/screens/home/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:dine_date/screens/auth/views/test.dart';
//import 'package:dine_date/screens/auth/views/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:rive/rive.dart';
import 'package:user_repository/user_repository.dart';

//import '../blocs/sign_in_bloc/sign_in_bloc.dart';
//import '../../../components/my_text_field.dart';

// class AnimationHelper {
//   static checking(SMIBool isChecking, SMIBool isHandsUp, SMINumber lookNum) {
//     isHandsUp.change(false);
//     isChecking.change(true);
//     lookNum.change(0);
//   }

//   static moveEyes(SMINumber lookNum, String value) {
//     lookNum.change(value.length.toDouble());
//   }

//   static handsUp(SMIBool isChecking, SMIBool isHandsUp) {
//     isHandsUp.change(true);
//     isChecking.change(false);
//   }

//   static void login(
//       SMIBool isChecking,
//       SMIBool isHandsUp,
//       SMITrigger successTrigger,
//       SMITrigger failTrigger,
//       TextEditingController emailController,
//       TextEditingController passwordController) {
//     isHandsUp.change(false);
//     isChecking.change(false);
//     if (emailController.text == "admin" && passwordController.text == "admin") {
//       successTrigger.fire();
//     } else {
//       failTrigger.fire();
//     }
//   }
// }

class SignInScreen extends StatefulWidget {
  final SMIBool isChecking;
  final SMIBool isHandsUp;
  final SMITrigger successTrigger;
  final SMITrigger failTrigger;
  final SMINumber lookNum;

  const SignInScreen({
    super.key,
    required this.isChecking,
    required this.isHandsUp,
    required this.successTrigger,
    required this.failTrigger,
    required this.lookNum,
  });

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  // var animationLink = 'assets/animations/animated_login_screen.riv';
  // late SMITrigger failTrigger, successTrigger;
  // late SMIBool isChecking, isHandsUp;
  // late SMINumber lookNum;
  // Artboard? artboard;
  // late StateMachineController? statemachineController;

  // @override
  // void initState() {
  //   initArtBoard();
  //   super.initState();
  // }

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

  checking() {
    widget.isHandsUp.change(false);
    widget.isChecking.change(true);
    widget.lookNum.change(0);
  }

  moveEyes(value) {
    widget.lookNum.change(value.length.toDouble());
  }

  handsUp() {
    widget.isHandsUp.change(true);
    widget.isChecking.change(false);
  }

  login(TextEditingController emailController,
      TextEditingController passwordController) {
    widget.isHandsUp.change(false);
    widget.isChecking.change(false);
    if (emailController.text == "admin" && passwordController.text == "admin") {
      widget.successTrigger.fire();
    } else {
      widget.failTrigger.fire();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => MultiBlocProvider(
                providers: [
                  // First, provide the AuthenticationBloc
                  BlocProvider(
                    create: (context) => AuthenticationBloc(
                      userRepository:
                          context.read<UserRepository>(), // Pass UserRepository
                      firebaseAuth: FirebaseAuth
                          .instance, // Assuming you want to initialize FirebaseAuth
                      firestore: FirebaseFirestore
                          .instance, // Assuming you want to initialize Firestore
                    ),
                  ),
                  // Next, provide SignInBloc, which depends on AuthenticationBloc
                  BlocProvider(
                    create: (context) => SignInBloc(
                      userRepository:
                          context.read<AuthenticationBloc>().userRepository,
                      // Add necessary initialization
                    ),
                  ),
                  // Lastly, provide SetupDataBloc
                  BlocProvider(
                    create: (context) => SetupDataBloc(
                        context.read<AuthenticationBloc>().userRepository),
                  ),
                ],
                child: PersistentTabScreen(),
              ),
            ));
          });
        } else if (state is SignInFailure) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Sign In Failed '),
          ));
        }
      },
      child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: SizedBox(
                    width: MediaQuery.of(context).size.height * 0.9,
                    child: MyTextField(
                        onTap: checking,
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(CupertinoIcons.mail_solid),
                        errorMsg: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please fill in this field';
                          } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                              .hasMatch(val)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        })),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: MyTextField(
                  onTap: handsUp,
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  errorMsg: _errorMsg,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in this field';
                    } else if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                        .hasMatch(val)) {
                      return 'Please enter a valid password';
                    }
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                        if (obscurePassword) {
                          iconPassword = CupertinoIcons.eye_fill;
                        } else {
                          iconPassword = CupertinoIcons.eye_slash_fill;
                        }
                      });
                    },
                    icon: Icon(iconPassword),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              !signInRequired
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignInBloc>().add(SignInRequired(
                                  emailController.text,
                                  passwordController.text));
                              login(emailController, passwordController);
                            }
                          },
                          style: TextButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    )
                  : SizedBox(height: 20),
              !signInRequired
                  ? const SizedBox()
                  : const CircularProgressIndicator(),
            ],
          )),
    );
  }
}

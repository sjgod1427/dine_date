// import 'dart:async';

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:user_repository/user_repository.dart';
// import 'package:user_repository/src/models/user.dart';

// part 'authentication_event.dart';
// part 'authentication_state.dart';

// class AuthenticationBloc
//     extends Bloc<AuthenticationEvent, AuthenticationState> {
//   final UserRepository userRepository;
//   late final StreamSubscription<MyUser?> _userSubscription;

//   AuthenticationBloc({required this.userRepository})
//       : super(const AuthenticationState.unkown()) {
//     _userSubscription = userRepository.user.listen((user) {
//       add(AuthenticationUserChanged(user));
//     });
//     on<AuthenticationUserChanged>((event, exit) {
//       if (event.user != null) {
//         emit(AuthenticationState.authenticated(event.user!));
//       } else {
//         emit(const AuthenticationState.unauthenticated());
//       }
//     });

//     @override
//     Future<void> close() {
//       _userSubscription.cancel();
//       return super.close();
//     }
//   }
// }

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';
import 'package:user_repository/src/models/user.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  late final StreamSubscription<MyUser?> _userSubscription;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthenticationBloc(
      {required this.userRepository,
      required this.firebaseAuth,
      required this.firestore})
      : super(const AuthenticationState.unknown()) {
    _userSubscription = userRepository.user.listen((user) {
      add(AuthenticationUserChanged(user));
    });
    on<AuthenticationUserChanged>((event, emit) {
      if (event.user != MyUser.empty) {
        emit(AuthenticationState.authenticated(event.user!));
      } else {
        emit(const AuthenticationState.unauthenticated());
      }
    });

    on<LikeUser>((event, emit) async {
      emit(AuthenticationState.loading());

      try {
        String currentUserId = firebaseAuth.currentUser!.uid;
        DocumentReference userDoc =
            firestore.collection('users').doc(currentUserId);

        await userDoc.update({
          'likedBy': FieldValue.arrayUnion([event.likedUserId])
        });

        emit(AuthenticationState.success(message: 'User liked successfully'));
      } catch (e) {
        emit(AuthenticationState.failure(error: e.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

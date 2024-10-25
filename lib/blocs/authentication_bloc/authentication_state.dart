// part of 'authentication_bloc.dart';

// enum AuthenticationStatus { authenticated, unauthenticated, unkown }

// class AuthenticationState extends Equatable {
//   final AuthenticationStatus status;
//   final MyUser? user;

//   const AuthenticationState._(
//       {this.status = AuthenticationStatus.unkown, this.user});

//   const AuthenticationState.unkown() : this._();

//   const AuthenticationState.authenticated(MyUser user)
//       : this._(status: AuthenticationStatus.authenticated, user: user);

//   const AuthenticationState.unauthenticated()
//       : this._(status: AuthenticationStatus.unauthenticated);

//   @override
//   // TODO: implement props
//   List<Object?> get props => [status, user];
// }

// part of 'authentication_bloc.dart';

// enum AuthenticationStatus { authenticated, unauthenticated, unknown }

// class AuthenticationState extends Equatable {
//   const AuthenticationState._(
//       {this.status = AuthenticationStatus.unknown, this.user});

//   const AuthenticationState.unknown() : this._();

//   const AuthenticationState.authenticated(MyUser user)
//       : this._(status: AuthenticationStatus.authenticated, user: user);

//   const AuthenticationState.unauthenticated()
//       : this._(status: AuthenticationStatus.unauthenticated);

//   final AuthenticationStatus status;
//   final MyUser? user;

//   @override
//   List<Object?> get props => [status, user];
// }

part of 'authentication_bloc.dart';

enum AuthenticationStatus {
  authenticated,
  unauthenticated,
  unknown,
  loading,
  success,
  failure
}

class AuthenticationState extends Equatable {
  final AuthenticationStatus status;
  final MyUser? user;
  final String? message; // For success messages
  final String? error; // For error messages

  const AuthenticationState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
    this.message,
    this.error,
  });

  // Unknown state
  const AuthenticationState.unknown() : this._();

  // Authenticated state
  const AuthenticationState.authenticated(MyUser user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  // Unauthenticated state
  const AuthenticationState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  // Loading state
  const AuthenticationState.loading()
      : this._(status: AuthenticationStatus.loading);

  // Success state with optional message
  const AuthenticationState.success({String? message})
      : this._(status: AuthenticationStatus.success, message: message);

  // Failure state with an error message
  const AuthenticationState.failure({required String error})
      : this._(status: AuthenticationStatus.failure, error: error);

  @override
  List<Object?> get props => [status, user, message, error];
}

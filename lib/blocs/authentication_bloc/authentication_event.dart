// part of 'authentication_bloc.dart';

// sealed class AuthenticationEvent extends Equatable {
//   const AuthenticationEvent();

//   @override
//   List<Object> get props => [];
// }

// class AuthenticationUserChanged extends AuthenticationEvent {
//   final MyUser? user;
//   const AuthenticationUserChanged(this.user);
// }

part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationUserChanged extends AuthenticationEvent {
  final MyUser? user;

  const AuthenticationUserChanged(this.user);
}

class LikeUser extends AuthenticationEvent {
  final String likedUserId;

  const LikeUser(this.likedUserId);

  @override
  List<Object> get props => [likedUserId];
}

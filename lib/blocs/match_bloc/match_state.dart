part of 'match_bloc.dart';

abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object> get props => [];
}

class MatchInitial extends MatchState {}

class MatchLoading extends MatchState {}

class MatchSuccess extends MatchState {
  final List<String> matchedUsers;

  const MatchSuccess(this.matchedUsers);

  @override
  List<Object> get props => [matchedUsers];
}

class MatchFailure extends MatchState {
  final String message;

  const MatchFailure(this.message);

  @override
  List<Object> get props => [message];
}

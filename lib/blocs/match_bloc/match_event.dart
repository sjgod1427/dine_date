part of 'match_bloc.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object> get props => [];
}

class LikeUser extends MatchEvent {
  final String userId;

  const LikeUser(this.userId);

  @override
  List<Object> get props => [userId];
}

class MatchUser extends MatchEvent {
  final String userId;

  const MatchUser(this.userId);

  @override
  List<Object> get props => [userId];
}

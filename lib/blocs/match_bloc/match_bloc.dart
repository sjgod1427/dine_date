import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  MatchBloc() : super(MatchInitial()) {
    on<MatchEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:user_repository/user_repository.dart';

// part 'match_event.dart';
// part 'match_state.dart';

// class MatchBloc extends Bloc<MatchEvent, MatchState> {
//   final UserRepository userRepository;

//   MatchBloc({required this.userRepository}) : super(MatchInitial());

//   @override
//   Stream<MatchState> mapEventToState(MatchEvent event) async* {
//     if (event is LikeUser) {
//       yield MatchLoading();
//       try {
//         await userRepository.likeUser(event.userId);
//         yield MatchSuccess(await userRepository.getMatchedUsers());
//       } catch (e) {
//         yield MatchFailure(e.toString());
//       }
//     } else if (event is MatchUser) {
//       yield MatchLoading();
//       try {
//         await userRepository.matchUser(event.userId);
//         yield MatchSuccess(await userRepository.getMatchedUsers());
//       } catch (e) {
//         yield MatchFailure(e.toString());
//       }
//     }
//   }
// }


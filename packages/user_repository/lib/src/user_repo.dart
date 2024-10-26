import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:user_repository/src/models/user.dart';

import 'models/models.dart';

abstract class UserRepository {
  Stream<MyUser?> get user;

  Future<MyUser> signUp(MyUser myUser, String password);

  Future<void> setUserData(MyUser user);

  Future<void> signIn(String email, String password);

  Future<void> logOut();

  Future<MyUser> userSetup(MyUser myUser);

  Future<void> setupLocation(double lat, double lng, MyUser myUser);

  Future<List<MyUser>> fetchOtherUsers(String currentUserId);
}

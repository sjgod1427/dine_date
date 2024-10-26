// import 'dart:developer';
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:path/path.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:user_repository/src/models/user.dart';
// import 'package:user_repository/user_repository.dart';

// class FirebaseUserRepo implements UserRepository {
//   final FirebaseAuth _firebaseAuth;
//   final usersCollection = FirebaseFirestore.instance.collection('users');

//   FirebaseUserRepo({
//     FirebaseAuth? firebaseAuth,
//   }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

//   @override
//   Stream<MyUser?> get user {
//     return _firebaseAuth.authStateChanges().flatMap((firebaseUser) async* {
//       if (firebaseUser == null) {
//         yield MyUser.empty;
//       } else {
//         yield await usersCollection.doc(firebaseUser.uid).get().then((value) =>
//             MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
//       }
//     });
//   }

//   @override
//   Future<void> signIn(String email, String password) async {
//     try {
//       await _firebaseAuth.signInWithEmailAndPassword(
//           email: email, password: password);
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<MyUser> signUp(MyUser myUser, String password) async {
//     try {
//       UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
//           email: myUser.email, password: password);

//       myUser = myUser.copyWith(userId: user.user!.uid);

//       return myUser;
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<void> setUserData(MyUser myUser) async {
//     try {
//       await usersCollection
//           .doc(myUser.userId)
//           .set(myUser.toEntity().toDocument());
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<void> logOut() async {
//     await _firebaseAuth.signOut();
//   }

//   @override
//   Future<MyUser> userSetup(MyUser myUser) async {
//     try {
//       List<String> tempURL = [];

//       for (String picture in myUser.pictures) {
//         if (!picture.startsWith('https')) {
//           File imageFile = File(picture);
//           String imageName = basename(picture);
//           Reference firebaseStorageRef = FirebaseStorage.instance
//               .ref()
//               .child("users/${myUser.userId}/pictures/$imageName");
//           await firebaseStorageRef.putFile(imageFile);
//           String imageURL = await firebaseStorageRef.getDownloadURL();
//           tempURL.add(imageURL);
//         }
//       }
//       myUser.pictures
//           .removeWhere((element) => !(element as String).startsWith('http'));
//       myUser.pictures.addAll(tempURL);

//       await usersCollection.doc(myUser.userId).update(
//           {'description': myUser.description, 'pictures': myUser.pictures});

//       return myUser;
//     } catch (e) {
//       print(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<void> setupLocation(double lat, double lng, MyUser myUser) async {
//     try {
//       await usersCollection.doc(myUser.userId).update({
//         'location': {'lat': lat, 'lng': lng}
//       });
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<List<MyUser>> fetchOtherUsers(String currentUserId) {
//     // TODO: implement fetchOtherUsers
//     throw UnimplementedError();
//   }

//   @override
//   // TODO: implement firestore
//   FirebaseFirestore get firestore => throw UnimplementedError();
// }

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/user_repository.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final CollectionReference usersCollection;

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        usersCollection =
            (firestore ?? FirebaseFirestore.instance).collection('users');

  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().flatMap((firebaseUser) async* {
      if (firebaseUser == null) {
        yield MyUser.empty;
      } else {
        yield await usersCollection.doc(firebaseUser.uid).get().then(
              (value) => MyUser.fromEntity(MyUserEntity.fromDocument(
                  value.data() as Map<String, dynamic>)),
            );
      }
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: myUser.email,
        password: password,
      );
      myUser = myUser.copyWith(userId: user.user!.uid);
      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<MyUser> userSetup(MyUser myUser) async {
    try {
      List<String> tempURL = [];
      for (String picture in myUser.pictures) {
        if (!picture.startsWith('https')) {
          File imageFile = File(picture);
          String imageName = basename(picture);
          Reference firebaseStorageRef = FirebaseStorage.instance
              .ref()
              .child("users/${myUser.userId}/pictures/$imageName");
          await firebaseStorageRef.putFile(imageFile);
          String imageURL = await firebaseStorageRef.getDownloadURL();
          tempURL.add(imageURL);
        }
      }
      myUser.pictures
          .removeWhere((element) => !(element as String).startsWith('http'));
      myUser.pictures.addAll(tempURL);

      await usersCollection.doc(myUser.userId).update(
        {
          'description': myUser.description,
          'pictures': myUser.pictures,
          'MyCrzyFoodStory': myUser.MyCrzyFoodStory
        },
      );

      return myUser;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setupLocation(double lat, double lng, MyUser myUser) async {
    try {
      await usersCollection.doc(myUser.userId).update({
        'location': {'lat': lat, 'lng': lng},
      });
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // Implementation of fetchOtherUsers to get all users except the authenticated user
  @override
  Future<List<MyUser>> fetchOtherUsers(String currentUserId) async {
    try {
      final querySnapshot = await usersCollection
          .where('userId', isNotEqualTo: currentUserId)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return MyUser.fromEntity(MyUserEntity.fromDocument(data));
      }).toList();
    } catch (e) {
      log("Error fetching other users: $e");
      rethrow;
    }
  }

  // Method to add liked user's ID to the current user's likedBy list
  Future<void> likeUser(String currentUserId, String likedUserId) async {
    try {
      await usersCollection.doc(currentUserId).update({
        'likedBy': FieldValue.arrayUnion([likedUserId]),
      });
    } catch (e) {
      log("Error liking user: $e");
      rethrow;
    }
  }

  // Getter for FirebaseFirestore instance
  @override
  FirebaseFirestore get firestore => _firestore;
}

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:dine_date/components/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/user.dart';
import 'other_profile_details_screen.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/entities/user_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List<String> reviewed = []; // List to track reviewed users

  final _controller = PageController(initialPage: 0);
  int numberPhotos = 4;
  int currentPhoto = 0;
  late MatchEngine _matchEngine;
  List<SwipeItem> items = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> updateLikedBy(String currentUserId, String likedUserId) async {
    try {
      await _firestore.collection('users').doc(currentUserId).update({
        'likedBy': FieldValue.arrayUnion([likedUserId]),
      });
      log("User $likedUserId liked by $currentUserId");
    } catch (e) {
      log("Error updating likedBy field: $e");
    }
  }

  Future<void> updatedReviewd(String currentUserId, String UserId) async {
    try {
      await _firestore.collection('users').doc(currentUserId).update({
        'reviewed': FieldValue.arrayUnion([UserId]),
      });
      log("User $UserId liked by $currentUserId");
    } catch (e) {
      log("Error updating likedBy field: $e");
    }
  }

  // Future<void> fetchUsers() async {
  //   final currentUser = FirebaseAuth.instance.currentUser;

  //   if (currentUser == null) {
  //     log('No current user signed in');
  //     return;
  //   }

  //   try {
  //     final QuerySnapshot snapshot = await _firestore.collection('users').get();

  //     List<MyUser> users = snapshot.docs
  //         .map((doc) => MyUser.fromFirestore(doc))
  //         .where((user) =>
  //             !currentUser.reviewed.contains(user.userId)) // Exclude reviewed users
  //         .toList();

  //     setState(() {
  //       items = users
  //           .where((user) => user.userId != currentUser.uid)
  //           .map((user) => SwipeItem(
  //                 content: user,
  //                 likeAction: () {
  //                   log("Like user: ${user.userId}");
  //                   updateLikedBy(currentUser.uid, user.userId);
  //                   updatedReviewd(
  //                       currentUser.uid, user.userId); // Add to reviewed
  //                 },
  //                 nopeAction: () {
  //                   log("Nope user: ${user.userId}");
  //                   updatedReviewd(
  //                       currentUser.uid, user.userId); // Add to reviewed
  //                 },
  //                 superlikeAction: () {
  //                   log("Superlike user: ${user.userId}");
  //                   updatedReviewd(
  //                       currentUser.uid, user.userId); // Add to reviewed
  //                 },
  //                 onSlideUpdate: (SlideRegion? region) async {
  //                   log("Region $region for user: ${user.userId}");
  //                 },
  //               ))
  //           .toList();

  //       _matchEngine = MatchEngine(swipeItems: items);
  //     });
  //   } catch (e) {
  //     log("Error fetching users: $e");
  //   }
  // }

  Future<void> fetchUsers() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      log('No current user signed in');
      return;
    }

    try {
      // Fetch the current user's document to get the reviewed list
      DocumentSnapshot currentUserDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      List<String> reviewedUsers =
          List<String>.from(currentUserDoc['reviewed'] ?? []);

      // Fetch all users and filter them based on the reviewed list of the current user
      final QuerySnapshot snapshot = await _firestore.collection('users').get();

      List<MyUser> users = snapshot.docs
          .map((doc) {
            return MyUser.fromFirestore(doc);
          })
          .where((user) =>
              !reviewedUsers.contains(user.userId)) // Exclude reviewed users
          .toList();

      setState(() {
        items = users
            .where((user) => user.userId != currentUser.uid)
            .map((user) => SwipeItem(
                  content: user,
                  likeAction: () {
                    log("Like user: ${user.userId}");
                    updateLikedBy(currentUser.uid, user.userId);
                    updatedReviewd(currentUser.uid, user.userId);
                  },
                  nopeAction: () {
                    log("Nope user: ${user.userId}");
                    updatedReviewd(currentUser.uid, user.userId);
                  },
                  superlikeAction: () {
                    log("Superlike user: ${user.userId}");
                    updateLikedBy(currentUser.uid, user.userId);
                    updatedReviewd(currentUser.uid, user.userId);
                  },
                  onSlideUpdate: (SlideRegion? region) async {
                    log("Region $region for user: ${user.userId}");
                  },
                ))
            .toList();

        _matchEngine = MatchEngine(swipeItems: items);
      });
    } catch (e) {
      log("Error fetching users: $e");
    }
  }

  void rebootStack(User user) {
    setState(() async {
      final String currentUserId = user.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({'reviewed': []});
      // Clear reviewed list
      fetchUsers(); // Refresh the stack
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(context: context),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            rebootStack(user!);
          },
          icon: Visibility(
            visible: items.isEmpty ? true : false,
            child: Icon(Icons.refresh),
          ),
        ),
        actions: [
          Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(right: 15, left: 5),
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.settings),
                color: Theme.of(context).colorScheme.primary,
                iconSize: 35,
              ),
            );
          }),
        ],
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Image.asset(
                  "assets/icons/Carrying Love.png",
                  scale: 10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: Text(
                  'Foodie',
                  style: TextStyle(
                      fontFamily: 'Cursive',
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      fontSize: 30),
                ),
              )
            ],
          ),
        ),
      ),
      body: items.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Center(
                child: Container(
                  height: 150,
                  width: 150,
                  // Add this
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Lottie.asset('assets/animations/no_users.json'),
                    ],
                  ),
                ),
              ),
            )
          : SwipeCards(
              matchEngine: _matchEngine,
              upSwipeAllowed: true,
              onStackFinished: () {
                Center(
                    child: Container(
                  height: 200,
                  width: 200,
                  child: Lottie.asset('assets/animations/no_users.json'),
                ));
                return log("No more users to swipe.");
              },
              itemBuilder: (context, i) {
                final user = items[i].content as MyUser;
                return buildSwipeCard(context, user, i);
              },
            ),
    );
  }

  Widget buildSwipeCard(BuildContext context, MyUser user, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 75),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Hero(
          tag: "imageTag$index",
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: user.pictures.isNotEmpty &&
                            currentPhoto < user.pictures.length &&
                            Uri.parse(user.pictures[currentPhoto]).isAbsolute
                        ? NetworkImage(user.pictures[currentPhoto])
                        : const AssetImage("assets/icons/Date.png")
                            as ImageProvider,
                  ),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [Colors.black, Colors.transparent],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: buildPhotoIndicators(context),
                ),
              ),
              // Backward button
              Positioned(
                left: 10,
                top: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  onPressed: () {
                    setState(() {
                      if (currentPhoto == 0) {
                        currentPhoto = user.pictures.length - 1;
                      } else {
                        currentPhoto =
                            (currentPhoto - 1) % user.pictures.length;
                      }
                    });
                  },
                ),
              ),
              // Forward button
              Positioned(
                right: 10,
                top: 10,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  onPressed: () {
                    setState(() {
                      currentPhoto = (currentPhoto + 1) % user.pictures.length;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildUserInfo(user),
                    const SizedBox(height: 10),
                    buildActionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPhotoIndicators(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      height: 6,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: numberPhotos,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, int i) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                width: ((MediaQuery.of(context).size.width -
                        (20 + ((numberPhotos + 1) * 8))) /
                    numberPhotos),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 0.5),
                    color: currentPhoto == i
                        ? Colors.white
                        : Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.5)),
              ),
            );
          }),
    );
  }

  Widget buildUserInfo(MyUser user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              user.name,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            const SizedBox(width: 5),
            Text(
              "${user.age}",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 25),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtherProfileDetailsScreen(user),
              ),
            );
          },
          icon: const Icon(
            CupertinoIcons.info_circle_fill,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.white,
          onPressed: () {
            _matchEngine.currentItem?.nope();
          },
          child: const Icon(Icons.clear, color: Colors.red, size: 32),
        ),
        FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.white,
          onPressed: () {
            _matchEngine.currentItem?.superLike();
          },
          child: const Icon(Icons.star, color: Colors.lightBlue, size: 32),
        ),
        FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.white,
          onPressed: () {
            _matchEngine.currentItem?.like();
          },
          child: const Icon(Icons.favorite, color: Colors.green, size: 32),
        ),
      ],
    );
  }
}

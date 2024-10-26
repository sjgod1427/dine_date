import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:dine_date/components/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/user.dart';
import 'other_profile_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    fetchUsers(); // Call fetchUsers to populate the swipe items
  }

  Future<void> updateLikedBy(String currentUserId, String likedUserId) async {
    try {
      // Update the likedBy field of the current user
      await _firestore.collection('users').doc(currentUserId).update({
        'likedBy': FieldValue.arrayUnion(
            [likedUserId]), // Add likedUserId to the likedBy array
      });
      log("User $likedUserId liked by $currentUserId");
    } catch (e) {
      log("Error updating likedBy field: $e");
    }
  }

  Future<void> fetchUsers() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Check if the current user is signed in
    if (currentUser == null) {
      log('No current user signed in');
      return;
    }

    try {
      // Query Firestore to get all user documents from the 'users' collection
      final QuerySnapshot snapshot = await _firestore.collection('users').get();

      // Map each document to a MyUser object and store them in a List<MyUser>
      List<MyUser> users = snapshot.docs.map((doc) {
        // Assuming MyUser has a fromFirestore method or constructor for parsing Firestore data
        return MyUser.fromFirestore(doc);
      }).toList();

      setState(() {
        // Filter out the current user and create the list of SwipeItems
        items = users
            .where((user) => user.userId != currentUser.uid)
            .map((user) => SwipeItem(
                  content: user,
                  likeAction: () {
                    log("Like user: ${user.userId}");
                    // Add the user ID to the current user's likedBy list
                    updateLikedBy(currentUser.uid, user.userId);
                  },
                  nopeAction: () {
                    log("Nope user: ${user.userId}");
                  },
                  superlikeAction: () {
                    log("Superlike user: ${user.userId}");
                  },
                  onSlideUpdate: (SlideRegion? region) async {
                    log("Region $region for user: ${user.userId}");
                  },
                ))
            .toList();

        // Initialize the MatchEngine
        _matchEngine = MatchEngine(swipeItems: items);
      });
    } catch (e) {
      log("Error fetching users: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MainDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
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
        title: Row(
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
      body: items.isEmpty
          ? const Center(child: Text("nO iTEMS "))
          : SwipeCards(
              matchEngine: _matchEngine,
              upSwipeAllowed: true,
              onStackFinished: () {
                log("No more users to swipe.");
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
                            Uri.parse(user.pictures.first).isAbsolute
                        ? NetworkImage(user.pictures.first)
                        : const AssetImage("assets/icons/Date.png")
                            as ImageProvider,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [Colors.black, Colors.transparent])),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: buildPhotoIndicators(context),
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
                      builder: (context) =>
                          OtherProfileDetailsScreen(_matchEngine, user)));
            },
            icon: const Icon(
              CupertinoIcons.info_circle_fill,
              color: Colors.white,
            ))
      ],
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildActionIcon(Icons.replay, Colors.orange, () {}),
        buildActionIcon(Icons.clear, Colors.red, () {
          if (_matchEngine.currentItem != null) {
            _matchEngine.currentItem!.nope();
          }
        }),
        buildActionIcon(Icons.star, Colors.lightBlueAccent, () {
          if (_matchEngine.currentItem != null) {
            _matchEngine.currentItem!.superLike();
          }
        }),
        buildActionIcon(Icons.favorite, Colors.greenAccent, () {
          if (_matchEngine.currentItem != null) {
            _matchEngine.currentItem!.like();
          }
        }),
        buildActionIcon(Icons.flash_on, Colors.purple, () {}),
      ],
    );
  }

  Widget buildActionIcon(IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(100)),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

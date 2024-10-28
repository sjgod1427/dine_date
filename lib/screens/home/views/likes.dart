import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:dine_date/components/payment_gateway.dart';
import 'package:user_repository/src/models/user.dart';

class LikedByScreen extends StatefulWidget {
  const LikedByScreen({super.key});

  @override
  State<LikedByScreen> createState() => _LikedByScreenState();
}

class _LikedByScreenState extends State<LikedByScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MyUser> users = [];
  List<MyUser> likedByUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsersWhoLiked();
  }

  Future<void> fetchUsersWhoLiked() async {
    final currentUser = _auth.currentUser;
    DocumentSnapshot userDoc =
        await _firestore.collection("users").doc(currentUser?.uid).get();
    if (currentUser == null) {
      print("No current user logged in");
      return;
    }

    try {
      // Fetch all users from Firestore
      final QuerySnapshot snapshot = await _firestore.collection('users').get();
      List<MyUser> fetchedUsers = snapshot.docs.map((doc) {
        return MyUser.fromFirestore(doc);
      }).toList();

      // Filter users who liked the current user but are not liked back
      List<MyUser> filteredUsers = fetchedUsers.where((user) {
        if (user.userId == currentUser.uid) return false;
        return user.likedBy.contains(currentUser.uid) &&
            !userDoc["likedBy"].contains(user.userId);
      }).toList();

      setState(() {
        users = fetchedUsers;
        likedByUsers = filteredUsers;
      });
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
          child: Text(
            'Users Who Liked You',
            style: TextStyle(
              fontFamily: 'Cursive',
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: likedByUsers.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Center(
                child: Container(
                  height: 150,
                  width: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Lottie.asset('assets/animations/no_matches.json'),
                    ],
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: likedByUsers.length,
                itemBuilder: (context, index) {
                  final user = likedByUsers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentPage(tier: 2, onPaymentSuccess: () {}),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            children: [
                              // User's profile picture
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: user.pictures.isNotEmpty
                                      ? NetworkImage(user.pictures.first)
                                      : const AssetImage(
                                              "assets/images/default_avatar.png")
                                          as ImageProvider,
                                ),
                              ),
                              // User's name
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              // User's age
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text("Age: ${user.age}"),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        // Back filter effect
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Center(
                            child: Text(
                              'Liked You',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

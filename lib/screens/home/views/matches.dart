// import 'package:dine_date/components/payment_gateway.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:user_repository/src/models/user.dart';

// class Matches extends StatefulWidget {
//   const Matches({super.key});

//   @override
//   State<Matches> createState() => _MutualLikesScreenState();
// }

// class _MutualLikesScreenState extends State<Matches> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   List<MyUser> users = [];
//   List<MyUser> mutualLikedUsers = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchUsersWithMutualLikes();
//   }

//   Future<void> fetchUsersWithMutualLikes() async {
//     final currentUser = _auth.currentUser;

//     if (currentUser == null) {
//       print("No current user logged in");
//       return;
//     }

//     try {
//       // Fetch all users from Firestore
//       final QuerySnapshot snapshot = await _firestore.collection('users').get();
//       List<MyUser> fetchedUsers = snapshot.docs.map((doc) {
//         return MyUser.fromFirestore(doc);
//       }).toList();

//       // Filter mutual likes
//       List<MyUser> filteredUsers = fetchedUsers.where((user) {
//         if (user.userId == currentUser.uid) return false;

//         final currentUserDoc =
//             fetchedUsers.firstWhere((u) => u.userId == currentUser.uid);
//         return user.likedBy.contains(currentUser.uid) &&
//             currentUserDoc.likedBy.contains(user.userId);
//       }).toList();

//       setState(() {
//         users = fetchedUsers;
//         mutualLikedUsers = filteredUsers;
//       });
//     } catch (e) {
//       print("Error fetching users: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Mutual Likes"),
//       ),
//       body: mutualLikedUsers.isEmpty
//           ? const Center(child: Text("No mutual likes found"))
//           : ListView.builder(
//               itemCount: mutualLikedUsers.length,
//               itemBuilder: (context, index) {
//                 final user = mutualLikedUsers[index];
//                 return ListTile(
//                   leading: CircleAvatar(
//                     backgroundImage: user.pictures.isNotEmpty
//                         ? NetworkImage(user.pictures.first)
//                         : AssetImage("assets/images/default_avatar.png")
//                             as ImageProvider,
//                   ),
//                   title: Text(user.name),
//                   subtitle: Text("Age: ${user.age}"),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const RazorPayPage(),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

import 'package:dine_date/components/payment_gateway.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:user_repository/src/models/user.dart';

class Matches extends StatefulWidget {
  const Matches({super.key});

  @override
  State<Matches> createState() => _MutualLikesScreenState();
}

class _MutualLikesScreenState extends State<Matches> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MyUser> users = [];
  List<MyUser> mutualLikedUsers = [];

  @override
  void initState() {
    super.initState();
    fetchUsersWithMutualLikes();
  }

  Future<void> fetchUsersWithMutualLikes() async {
    final currentUser = _auth.currentUser;

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

      // Filter mutual likes
      List<MyUser> filteredUsers = fetchedUsers.where((user) {
        if (user.userId == currentUser.uid) return false;

        final currentUserDoc =
            fetchedUsers.firstWhere((u) => u.userId == currentUser.uid);
        return user.likedBy.contains(currentUser.uid) &&
            currentUserDoc.likedBy.contains(user.userId);
      }).toList();

      setState(() {
        users = fetchedUsers;
        mutualLikedUsers = filteredUsers;
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
          'Mutual likes',
          style: TextStyle(
              fontFamily: 'Cursive',
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w900,
              fontSize: 30),
        ),
      )),
      body: mutualLikedUsers.isEmpty
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
                      Lottie.asset('assets/animations/no_matches.json'),
                    ],
                  ),
                ),
              ),
            ) ////ITHTHEEE
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                childAspectRatio:
                    0.75, // Adjust the card's height and width ratio
                crossAxisSpacing: 10.0, // Space between columns
                mainAxisSpacing: 10.0, // Space between rows
              ),
              padding: const EdgeInsets.all(8.0),
              itemCount: mutualLikedUsers.length,
              itemBuilder: (context, index) {
                final user = mutualLikedUsers[index];
                return Card(
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Age: ${user.age}"),
                      ),
                      const Spacer(),
                      // View Profile button
                      TextButton(
                        child: const Text("View Profile"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PaymentPage(tier: 2, onPaymentSuccess: () {}),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

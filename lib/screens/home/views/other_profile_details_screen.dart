// import 'package:dine_date/screens/home/views/home_screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:swipe_cards/swipe_cards.dart';
// import 'package:user_repository/user_repository.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
// import 'package:user_repository/src/models/user.dart';

// class OtherProfileDetailsScreen extends StatefulWidget {
//   final MyUser user;
//   final MatchEngine matchEngine;

//   const OtherProfileDetailsScreen(this.matchEngine, this.user, {super.key});

//   @override
//   State<OtherProfileDetailsScreen> createState() =>
//       _OtherProfileDetailsScreenState();
// }

// class _OtherProfileDetailsScreenState extends State<OtherProfileDetailsScreen> {
//   int currentPhoto = 0;

//   TextStyle nameAgeStyle = const TextStyle(
//     color: Colors.black,
//     fontWeight: FontWeight.w400, // You can adjust this as per your needs
//     fontSize: 25,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       body: SafeArea(
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 50.0),
//                 child: Column(
//                   children: [
//                     Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height * 0.6,
//                       child: Hero(
//                         tag: "imageTag${widget.user.userId}",
//                         child: Stack(
//                           children: [
//                             // User's picture
//                             Container(
//                               width: MediaQuery.of(context).size.width,
//                               height:
//                                   (MediaQuery.of(context).size.height * 0.6) -
//                                       25,
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   fit: BoxFit.cover,
//                                   image: widget.user.pictures.isNotEmpty &&
//                                           Uri.parse(widget.user.pictures.first)
//                                               .isAbsolute
//                                       ? NetworkImage(widget.user.pictures.first)
//                                       : const AssetImage(
//                                               "assets/icons/Date.png")
//                                           as ImageProvider,
//                                 ),
//                               ),
//                             ),
//                             // Left and Right Swipe for pictures
//                             Row(
//                               children: [
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       if (currentPhoto > 0) {
//                                         setState(() {
//                                           currentPhoto--;
//                                         });
//                                       }
//                                     },
//                                     child: Container(
//                                       color: Colors.transparent,
//                                     ),
//                                   ),
//                                 ),
//                                 Expanded(
//                                   child: GestureDetector(
//                                     onTap: () {
//                                       if (currentPhoto <
//                                           widget.user.pictures.length - 1) {
//                                         setState(() {
//                                           currentPhoto++;
//                                         });
//                                       }
//                                     },
//                                     child: Container(
//                                       color: Colors.transparent,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             // Photo indicators
//                             Align(
//                               alignment: Alignment.topCenter,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(top: 6.0),
//                                 child: SizedBox(
//                                   width: MediaQuery.of(context).size.width - 20,
//                                   height: 6,
//                                   child: ListView.builder(
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     itemCount: widget.user.pictures.length,
//                                     scrollDirection: Axis.horizontal,
//                                     itemBuilder: (context, int i) {
//                                       return Padding(
//                                         padding:
//                                             const EdgeInsets.only(left: 8.0),
//                                         child: Container(
//                                           width: (MediaQuery.of(context)
//                                                       .size
//                                                       .width -
//                                                   (20 +
//                                                       ((widget.user.pictures
//                                                                   .length +
//                                                               1) *
//                                                           8))) /
//                                               widget.user.pictures.length,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(20),
//                                             border: Border.all(
//                                                 color: Colors.white,
//                                                 width: 0.5),
//                                             color: currentPhoto == i
//                                                 ? Colors.white
//                                                 : Theme.of(context)
//                                                     .colorScheme
//                                                     .secondary
//                                                     .withOpacity(0.5),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // Close button
//                             Align(
//                               alignment: Alignment.bottomRight,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(right: 16),
//                                 child: Material(
//                                   color: Theme.of(context).colorScheme.primary,
//                                   elevation: 3,
//                                   borderRadius: BorderRadius.circular(100),
//                                   child: InkWell(
//                                     borderRadius: BorderRadius.circular(100),
//                                     onTap: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Container(
//                                       height: 50,
//                                       width: 50,
//                                       decoration: const BoxDecoration(
//                                         shape: BoxShape.circle,
//                                       ),
//                                       child: Center(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Icon(
//                                             Icons.close,
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     // User information
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .surface, // Use theme color
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                       color:
//                                           Theme.of(context).colorScheme.primary,
//                                       width: 2), // Use theme color for border
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.3),
//                                       spreadRadius: 2,
//                                       blurRadius: 5,
//                                       offset: const Offset(
//                                           0, 3), // changes position of shadow
//                                     ),
//                                   ],
//                                 ),
//                                 child: Text(
//                                   widget.user.name,
//                                   style: TextStyle(
//                                     fontFamily:
//                                         'Cursive', // Set font family to Cursive
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w600,
//                                     fontSize: 25,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 5),
//                               Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 decoration: BoxDecoration(
//                                   color: Theme.of(context)
//                                       .colorScheme
//                                       .surface, // Use theme color
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                       color:
//                                           Theme.of(context).colorScheme.primary,
//                                       width: 2), // Use theme color for border
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.grey.withOpacity(0.3),
//                                       spreadRadius: 2,
//                                       blurRadius: 5,
//                                       offset: const Offset(
//                                           0, 3), // changes position of shadow
//                                     ),
//                                   ],
//                                 ),
//                                 child: Text(
//                                   "${widget.user.age}",
//                                   style: TextStyle(
//                                     fontFamily:
//                                         'Cursive', // Set font family to Cursive
//                                     color: Colors.black,
//                                     fontWeight: FontWeight.w300,
//                                     fontSize: 25,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 5),
//                           Row(
//                             children: [
//                               Icon(
//                                 CupertinoIcons.placemark,
//                                 color: Colors.grey.shade600,
//                                 size: 15,
//                               ),
//                               const SizedBox(width: 5),
//                               Text(
//                                 "${widget.user.location} km away",
//                                 style: TextStyle(
//                                     color: Colors.grey.shade600,
//                                     fontWeight: FontWeight.w300,
//                                     fontSize: 15),
//                               ),
//                             ],
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 16),
//                             child: Divider(),
//                           ),
//                           const Text(
//                             "About Me",
//                             style: TextStyle(
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w600,
//                                 fontSize: 16),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
//                             child: Text(
//                               widget.user.description,
//                               style: TextStyle(
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ),
//                           buildUserInfoSection(
//                               "Pronouns", widget.user.pronouns),

//                           // Crazy Food Story
//                           buildUserInfoSection("My Crazy Food Story",
//                               widget.user.MyCrzyFoodStory),

//                           // Diet
//                           buildUserInfoSection("Diet", widget.user.Diet),

//                           // Eating Habits
//                           buildUserInfoSection(
//                               "Eating Habits", widget.user.EatingHabits),

//                           // Favorite Restaurants
//                           buildUserInfoSection("Favourite Restaurants",
//                               widget.user.FavouriteResturants),

//                           // Places I Wanna Visit
//                           buildUserInfoSection("Places I Wanna Visit",
//                               widget.user.PlacesWannaVisit),

//                           // Favorite Cuisine
//                           buildUserInfoSection(
//                               "Favourite Cuisine", widget.user.FavouritCuisine),

//                           // Dine In/Out Preferences
//                           buildUserInfoSection(
//                               "Dine In/Out Preferences", widget.user.DineInOut),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Function to create reusable action buttons
//   Widget buildActionIcon(
//       {required IconData icon,
//       required Color color,
//       required VoidCallback onTap}) {
//     return Material(
//       color: Colors.white,
//       elevation: 3,
//       borderRadius: BorderRadius.circular(100),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(100),
//         child: Container(
//           height: 60,
//           width: 60,
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: Icon(
//               icon,
//               color: color,
//               size: 30,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Helper widget to build user info section
// Widget buildUserInfoSection(String title, String content) {
//   return content.isNotEmpty
//       ? Padding(
//           padding: const EdgeInsets.symmetric(vertical: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                     color: Colors.black,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 5),
//                 child: Text(
//                   content,
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 15,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )
//       : const SizedBox.shrink(); // Hides the section if content is empty
// }

import 'package:dine_date/screens/home/views/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:user_repository/src/models/user.dart';

class OtherProfileDetailsScreen extends StatefulWidget {
  final MyUser user;
  final MatchEngine matchEngine;

  const OtherProfileDetailsScreen(this.matchEngine, this.user, {super.key});

  @override
  State<OtherProfileDetailsScreen> createState() =>
      _OtherProfileDetailsScreenState();
}

class _OtherProfileDetailsScreenState extends State<OtherProfileDetailsScreen> {
  int currentPhoto = 0;

  TextStyle nameAgeStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.w400, // You can adjust this as per your needs
    fontSize: 25,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: Hero(
                        tag: "imageTag${widget.user.userId}",
                        child: Stack(
                          children: [
                            // User's picture
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  (MediaQuery.of(context).size.height * 0.6) -
                                      25,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: widget.user.pictures.isNotEmpty &&
                                          Uri.parse(widget.user.pictures.first)
                                              .isAbsolute
                                      ? NetworkImage(widget.user.pictures.first)
                                      : const AssetImage(
                                              "assets/icons/Date.png")
                                          as ImageProvider,
                                ),
                              ),
                            ),
                            // Left and Right Swipe for pictures
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (currentPhoto > 0) {
                                        setState(() {
                                          currentPhoto--;
                                        });
                                      }
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (currentPhoto <
                                          widget.user.pictures.length - 1) {
                                        setState(() {
                                          currentPhoto++;
                                        });
                                      }
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Photo indicators
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 20,
                                  height: 6,
                                  child: ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: widget.user.pictures.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, int i) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  (20 +
                                                      ((widget.user.pictures
                                                                  .length +
                                                              1) *
                                                          8))) /
                                              widget.user.pictures.length,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 0.5),
                                            color: currentPhoto == i
                                                ? Colors.white
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                    .withOpacity(0.5),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            // Close button
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Material(
                                  color: Theme.of(context).colorScheme.primary,
                                  elevation: 3,
                                  borderRadius: BorderRadius.circular(100),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // User information
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  widget.user.name,
                                  style: TextStyle(
                                    fontFamily: 'Cursive',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "${widget.user.age}",
                                  style: TextStyle(
                                    fontFamily: 'Cursive',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.placemark,
                                color: Colors.grey.shade600,
                                size: 15,
                              ),
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "${widget.user.location} km away",
                                  style: TextStyle(
                                      fontFamily: 'Cursive',
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(),
                          ),
                          const Text(
                            "About Me",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Text(
                              widget.user.description,
                              style: TextStyle(
                                fontFamily: 'Cursive',
                                color: Colors.grey.shade600,
                                fontSize: 23,
                              ),
                            ),
                          ),
                          buildUserInfoSection(
                              "Pronouns", widget.user.pronouns),
                          buildUserInfoSection("My Crazy Food Story",
                              widget.user.MyCrzyFoodStory),
                          buildUserInfoSection("Diet", widget.user.Diet),
                          buildUserInfoSection(
                              "Eating Habits", widget.user.EatingHabits),
                          buildUserInfoSection("Favourite Restaurants",
                              widget.user.FavouriteResturants),
                          buildUserInfoSection("Places I Wanna Visit",
                              widget.user.PlacesWannaVisit),
                          buildUserInfoSection(
                              "Favourite Cuisine", widget.user.FavouritCuisine),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Clear button

                    // Save button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserInfoSection(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              value ?? "Not specified",
              style: TextStyle(
                fontFamily: 'Cursive',
                color: Colors.grey.shade600,
                fontSize: 23,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

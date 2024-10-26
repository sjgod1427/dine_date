// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class MainDrawer extends StatelessWidget {
//   const MainDrawer({super.key});

//   // final Function(String) onSelectScreen;

//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//         child: Column(
//       children: [
//         DrawerHeader(
//           decoration: BoxDecoration(
//               gradient: LinearGradient(colors: [
//             const Color.fromARGB(255, 244, 92, 82),
//             const Color.fromARGB(255, 247, 201, 198)
//           ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
//           child: Expanded(
//             child: Row(
//               children: [
//                 Container(
//                     width: 150,
//                     height: 150,
//                     child: Lottie.asset(
//                         'assets/animations/Animation - 1729828909583.json')),
//                 Text(
//                   'YOUR TYPE',
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                       color: Colors.white, fontSize: 20, fontFamily: 'Cursive'),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ],
//     ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  // For managing selected filters
  List<String> selectedPronouns = [];
  List<String> selectedDiets = [];
  List<String> selectedEatingHabits = [];
  List<String> selectedDineInOut = [];

  // Sample options for toggles
  final List<String> pronouns = ['He/Him', 'She/Her', 'They/Them'];
  final List<String> diets = ['Vegan', 'Vegetarian', 'Non-Vegetarian'];
  final List<String> eatingHabits = ['Midnight Snacker', 'Disciplined'];
  final List<String> dineInOutOptions = [
    'Netflix and Chill',
    'Zomatooo',
    'Candle Lights',
    'StreetFood HUNT'
  ];

  // Function to handle toggle button changes
  void updateSelection(String category, String value) {
    setState(() {
      if (category == 'pronouns') {
        selectedPronouns.contains(value)
            ? selectedPronouns.remove(value)
            : selectedPronouns.add(value);
      } else if (category == 'diets') {
        selectedDiets.contains(value)
            ? selectedDiets.remove(value)
            : selectedDiets.add(value);
      } else if (category == 'eatingHabits') {
        selectedEatingHabits.contains(value)
            ? selectedEatingHabits.remove(value)
            : selectedEatingHabits.add(value);
      } else if (category == 'dineInOut') {
        selectedDineInOut.contains(value)
            ? selectedDineInOut.remove(value)
            : selectedDineInOut.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 244, 92, 82),
                  const Color.fromARGB(255, 247, 201, 198)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  child: Lottie.asset(
                    'assets/animations/Animation - 1729828909583.json',
                  ),
                ),
                Text(
                  'YOUR TYPE',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Cursive',
                      ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                buildToggleSection(
                    "Pronouns", pronouns, selectedPronouns, 'pronouns'),
                buildToggleSection("Diet", diets, selectedDiets, 'diets'),
                buildToggleSection("Eating Habits", eatingHabits,
                    selectedEatingHabits, 'eatingHabits'),
                buildToggleSection("Dine-In/Dine-Out", dineInOutOptions,
                    selectedDineInOut, 'dineInOut'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build a toggle section
  Widget buildToggleSection(String title, List<String> options,
      List<String> selectedOptions, String category) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Wrap(
          spacing: 8.0,
          children: options.map((option) {
            return ChoiceChip(
              label: Text(option),
              selected: selectedOptions.contains(option),
              onSelected: (isSelected) {
                updateSelection(category, option);
              },
              selectedColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Colors.grey[300],
              labelStyle: TextStyle(
                  color: selectedOptions.contains(option)
                      ? Colors.white
                      : Colors.black),
            );
          }).toList(),
        ),
      ],
    );
  }
}

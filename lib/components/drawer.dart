import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  // final Function(String) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            const Color.fromARGB(255, 244, 92, 82),
            const Color.fromARGB(255, 247, 201, 198)
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Expanded(
            child: Row(
              children: [
                Container(
                    width: 150,
                    height: 150,
                    child: Lottie.asset(
                        'assets/animations/Animation - 1729828909583.json')),
                Text(
                  'YOUR TYPE',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.white, fontSize: 20, fontFamily: 'Cursive'),
                )
              ],
            ),
          ),
        ),
        ListTile(
            leading: Icon(Icons.restaurant),
            title: Text(
              'Meals',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.white),
            ),
            onTap: () {
              // onSelectScreen('Meals');
            }),
        ListTile(
            leading: const Icon(Icons.settings),
            title: Text(
              'Filters',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Colors.white),
            ),
            onTap: () {
              // onSelectScreen('Filters');
            }),
      ],
    ));
  }
}

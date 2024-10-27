import 'dart:io';
import 'package:dine_date/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:dine_date/blocs/setup_data_bloc/setup_data_bloc.dart';
import 'package:dine_date/screens/auth/blocs/sign_in_bloc/sign_in_bloc_bloc.dart';
import 'package:dine_date/screens/profile/views/add_photo_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController myStoryController = TextEditingController();
  TextEditingController placesWannaVisitController = TextEditingController();
  TextEditingController favouriteCuisineController = TextEditingController();
  TextEditingController favouriteRestaurantsController =
      TextEditingController();

  String selectedDiet = '';
  String selectedEatingHabit = '';
  String selectedDineInOut = '';
  String selectedPronoun = '';

  final List<String> dietOptions = [
    'Vegetarian',
    'Non-Vegetarian',
    'Vegan',
    'Pescatarian',
    'Gluten-Free'
  ];

  final List<String> eatingHabitsOptions = [
    'Midnight Snacker',
    'Disciplined',
    'Emotional Eater',
    'Fast Food Lover',
    'Healthy Eater'
  ];

  final List<String> dineInOutOptions = [
    'Netflix and Chill',
    'Zomatooo',
    'Candle Lights',
    'StreetFood HUNT'
  ];

  final List<String> pronounOptions = [
    'He/Him',
    'She/Her',
    'They/Them',
    'Ze/Zir',
    'Xe/Xem'
  ];

  @override
  void initState() {
    super.initState();
    descriptionController.text =
        context.read<AuthenticationBloc>().state.user!.description;
    myStoryController.text =
        context.read<AuthenticationBloc>().state.user!.MyCrzyFoodStory;

    // Load the saved diet option if available
    selectedDiet = context.read<AuthenticationBloc>().state.user!.Diet ?? '';
    selectedDineInOut =
        context.read<AuthenticationBloc>().state.user!.DineInOut ?? '';
    selectedPronoun =
        context.read<AuthenticationBloc>().state.user!.pronouns ?? '';

    placesWannaVisitController.text =
        context.read<AuthenticationBloc>().state.user!.PlacesWannaVisit ?? '';
    favouriteCuisineController.text =
        context.read<AuthenticationBloc>().state.user!.FavouritCuisine ?? '';
    favouriteRestaurantsController.text =
        context.read<AuthenticationBloc>().state.user!.FavouriteResturants ??
            '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              context.read<AuthenticationBloc>().state.user!.description =
                  descriptionController.text;
              context.read<AuthenticationBloc>().state.user!.MyCrzyFoodStory =
                  myStoryController.text;
              context.read<AuthenticationBloc>().state.user!.Diet =
                  selectedDiet;
              context.read<AuthenticationBloc>().state.user!.EatingHabits =
                  selectedEatingHabit;
              context.read<AuthenticationBloc>().state.user!.DineInOut =
                  selectedDineInOut;
              context.read<AuthenticationBloc>().state.user!.pronouns =
                  selectedPronoun;

              context.read<AuthenticationBloc>().state.user!.description =
                  descriptionController.text;
              context.read<AuthenticationBloc>().state.user!.MyCrzyFoodStory =
                  myStoryController.text;
              context.read<AuthenticationBloc>().state.user!.PlacesWannaVisit =
                  placesWannaVisitController.text;
              context.read<AuthenticationBloc>().state.user!.FavouritCuisine =
                  favouriteCuisineController.text;
              context
                  .read<AuthenticationBloc>()
                  .state
                  .user!
                  .FavouriteResturants = favouriteRestaurantsController.text;
            });
            print(context.read<AuthenticationBloc>().state.user!);

            context.read<SetupDataBloc>().add(
                SetupRequired(context.read<AuthenticationBloc>().state.user!));
          },
          child: const Icon(
            CupertinoIcons.check_mark,
            color: Color.fromARGB(255, 223, 195, 195),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () {
                context.read<SignInBloc>().add(const SignOutRequired());
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Photos",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 9 / 16),
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () async {
                        if (!(context
                                .read<AuthenticationBloc>()
                                .state
                                .user!
                                .pictures
                                .isNotEmpty &&
                            (i <
                                context
                                    .read<AuthenticationBloc>()
                                    .state
                                    .user!
                                    .pictures
                                    .length))) {
                          var photos = await Navigator.push<List<String>>(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPhotoScreen()));

                          if (photos != null && photos.isNotEmpty) {
                            setState(() {
                              context
                                  .read<AuthenticationBloc>()
                                  .state
                                  .user!
                                  .pictures
                                  .addAll(photos);
                            });
                          }
                        }
                      },
                      child: Stack(
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: context
                                          .read<AuthenticationBloc>()
                                          .state
                                          .user!
                                          .pictures
                                          .isNotEmpty &&
                                      (i <
                                          context
                                              .read<AuthenticationBloc>()
                                              .state
                                              .user!
                                              .pictures
                                              .length)
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(8),
                                        image: (context
                                                    .read<AuthenticationBloc>()
                                                    .state
                                                    .user!
                                                    .pictures[i] as String)
                                                .startsWith('https')
                                            ? DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(context
                                                    .read<AuthenticationBloc>()
                                                    .state
                                                    .user!
                                                    .pictures[i]))
                                            : DecorationImage(
                                                fit: BoxFit.cover,
                                                image: FileImage(File(context
                                                    .read<AuthenticationBloc>()
                                                    .state
                                                    .user!
                                                    .pictures[i])),
                                              ),
                                      ),
                                    )
                                  : DottedBorder(
                                      color: Colors.grey.shade700,
                                      borderType: BorderType.RRect,
                                      radius: const Radius.circular(8),
                                      dashPattern: const [6, 6, 6, 6],
                                      padding: EdgeInsets.zero,
                                      strokeWidth: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    )),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: context
                                              .read<AuthenticationBloc>()
                                              .state
                                              .user!
                                              .pictures
                                              .isNotEmpty &&
                                          (i <
                                              context
                                                  .read<AuthenticationBloc>()
                                                  .state
                                                  .user!
                                                  .pictures
                                                  .length)
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              context
                                                  .read<AuthenticationBloc>()
                                                  .state
                                                  .user!
                                                  .pictures
                                                  .remove(context
                                                      .read<
                                                          AuthenticationBloc>()
                                                      .state
                                                      .user!
                                                      .pictures[i]);
                                            });
                                          },
                                          child: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  color: Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Image.asset(
                                                  'assets/icons/clear.png',
                                                  color: Colors.grey,
                                                ),
                                              )),
                                        )
                                      : Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Image.asset(
                                              'assets/icons/add.png',
                                              color: Colors.white,
                                            ),
                                          )),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Pronouns",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: DropdownButtonFormField<String>(
                value: selectedPronoun.isEmpty ? null : selectedPronoun,
                items: pronounOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                hint: const Text("Select your pronoun"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPronoun = newValue ?? '';
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "About me",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: TextFormField(
                controller: descriptionController,
                maxLines: 10,
                minLines: 1,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    hintText: "About me",
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "My Crazy Food Story",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: TextFormField(
                controller: myStoryController,
                maxLines: 10,
                minLines: 1,
                decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    hintText: "My Crazy Food Story",
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Diet",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: DropdownButtonFormField<String>(
                value: selectedDiet.isEmpty ? null : selectedDiet,
                items: dietOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                hint: const Text("Select a diet"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDiet = newValue ?? '';
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Eating Habits",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: DropdownButtonFormField<String>(
                value: selectedEatingHabit.isEmpty ? null : selectedEatingHabit,
                items: eatingHabitsOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                hint: const Text("Select an eating habit"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedEatingHabit = newValue ?? '';
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Dine In/Out",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: DropdownButtonFormField<String>(
                value: selectedDineInOut.isEmpty ? null : selectedDineInOut,
                items: dineInOutOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                hint: const Text("Select a Dine In/Out preference"),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedDineInOut = newValue ?? '';
                  });
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Places I Want to Visit",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: TextFormField(
                controller: placesWannaVisitController,
                maxLines: 2,
                minLines: 1,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  hintText: "E.g., Paris, Tokyo",
                  border: InputBorder.none,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Favourite Cuisine",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: TextFormField(
                controller: favouriteCuisineController,
                maxLines: 2,
                minLines: 1,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  hintText: "E.g., Italian, Chinese",
                  border: InputBorder.none,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Favourite Restaurants",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: TextFormField(
                controller: favouriteRestaurantsController,
                maxLines: 2,
                minLines: 1,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  hintText: "E.g., Le Bernardin, Din Tai Fung",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 150)
          ],
        ),
      ),
    );
  }
}

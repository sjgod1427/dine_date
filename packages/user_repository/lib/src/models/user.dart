import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';

class MyUser {
  final String userId;
  final String email;
  final String name;
  final int age;
  String pronouns;
  String description;
  String MyCrzyFoodStory;
  String Diet;
  String FavouriteResturants; // New field
  String EatingHabits; // New field
  String PlacesWannaVisit; // New field
  String FavouritCuisine; // New field
  String DineInOut; // New field
  final Map<String, dynamic> location;
  List<dynamic> pictures;
  final List<dynamic> likedBy;
  final List<dynamic> reviewed;

  MyUser(
      {required this.userId,
      required this.email,
      required this.name,
      required this.age,
      required this.pronouns,
      required this.description,
      required this.MyCrzyFoodStory,
      required this.Diet,
      required this.FavouriteResturants, // Update constructor
      required this.EatingHabits, // Update constructor
      required this.PlacesWannaVisit, // Update constructor
      required this.FavouritCuisine, // Update constructor
      required this.DineInOut, // Update constructor
      required this.location,
      required this.pictures,
      required this.likedBy,
      required this.reviewed});

  // Empty MyUser instance
  static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
    age: 0,
    pronouns: '',
    description: '',
    MyCrzyFoodStory: '',
    Diet: '',
    FavouriteResturants: '', // Update empty instance
    EatingHabits: '', // Update empty instance
    PlacesWannaVisit: '', // Update empty instance
    FavouritCuisine: '', // Update empty instance
    DineInOut: '', // Update empty instance
    location: {},
    pictures: [],
    likedBy: [],
    reviewed: [],
  );

  // Factory method to create MyUser from Firestore document
  factory MyUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MyUser(
      userId: doc.id, // Use document ID as userId
      email: data['email'] ?? '',
      name: data['name'] ?? 'Unknown',
      age: data['age'] ?? 0,
      pronouns: data['gender'] ?? '',
      description: data['description'] ?? '',
      MyCrzyFoodStory: data['MyCrzyFoodStory'] ?? '',
      Diet: data['Diet'] ?? '',
      FavouriteResturants:
          data['FavouriteResturants'] ?? '', // Update fromFirestore
      EatingHabits: data['EatingHabits'] ?? '', // Update fromFirestore
      PlacesWannaVisit: data['PlacesWannaVisit'] ?? '', // Update fromFirestore
      FavouritCuisine: data['FavouritCuisine'] ?? '', // Update fromFirestore
      DineInOut: data['DineInOut'] ?? '', // Update fromFirestore
      location: Map<String, dynamic>.from(data['location'] ?? {}),
      pictures: List<dynamic>.from(data['pictures'] ?? []),
      likedBy: List<dynamic>.from(data['likedBy'] ?? []),
      reviewed: List<dynamic>.from(data['reviewed'] ?? []),
    );
  }

  // Copy with method for creating a modified copy of MyUser
  MyUser copyWith(
      {String? userId,
      String? email,
      String? name,
      int? age,
      String? pronouns,
      String? description,
      String? MyCrzyFoodStory,
      String? Diet,
      String? FavouriteResturants, // Update copyWith
      String? EatingHabits, // Update copyWith
      String? PlacesWannaVisit, // Update copyWith
      String? FavouritCuisine, // Update copyWith
      String? DineInOut, // Update copyWith
      Map<String, dynamic>? location,
      List<dynamic>? pictures,
      List<dynamic>? likedBy,
      List<dynamic>? reviewed}) {
    return MyUser(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        name: name ?? this.name,
        age: age ?? this.age,
        pronouns: pronouns ?? this.pronouns,
        description: description ?? this.description,
        MyCrzyFoodStory: MyCrzyFoodStory ?? this.MyCrzyFoodStory,
        Diet: Diet ?? this.Diet,
        FavouriteResturants:
            FavouriteResturants ?? this.FavouriteResturants, // Update copyWith
        EatingHabits: EatingHabits ?? this.EatingHabits, // Update copyWith
        PlacesWannaVisit:
            PlacesWannaVisit ?? this.PlacesWannaVisit, // Update copyWith
        FavouritCuisine:
            FavouritCuisine ?? this.FavouritCuisine, // Update copyWith
        DineInOut: DineInOut ?? this.DineInOut, // Update copyWith
        location: location ?? this.location,
        pictures: pictures ?? this.pictures,
        likedBy: likedBy ?? this.likedBy,
        reviewed: reviewed ?? this.reviewed);
  }

  // Converts MyUser instance to MyUserEntity
  MyUserEntity toEntity() {
    return MyUserEntity(
        userId: userId,
        email: email,
        name: name,
        age: age,
        pronouns: pronouns,
        description: description,
        MyCrzyFoodStory: MyCrzyFoodStory,
        Diet: Diet,
        FavouriteResturants: FavouriteResturants, // Update toEntity
        EatingHabits: EatingHabits, // Update toEntity
        PlacesWannaVisit: PlacesWannaVisit, // Update toEntity
        FavouritCuisine: FavouritCuisine, // Update toEntity
        DineInOut: DineInOut, // Update toEntity
        location: location,
        pictures: pictures,
        likedBy: likedBy,
        reviewed: reviewed);
  }

  // Creates a MyUser instance from a MyUserEntity
  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        userId: entity.userId,
        email: entity.email,
        name: entity.name,
        age: entity.age,
        pronouns: entity.pronouns,
        description: entity.description,
        MyCrzyFoodStory: entity.MyCrzyFoodStory,
        Diet: entity.Diet,
        FavouriteResturants: entity.FavouriteResturants, // Update fromEntity
        EatingHabits: entity.EatingHabits, // Update fromEntity
        PlacesWannaVisit: entity.PlacesWannaVisit, // Update fromEntity
        FavouritCuisine: entity.FavouritCuisine, // Update fromEntity
        DineInOut: entity.DineInOut, // Update fromEntity
        location: entity.location,
        pictures: entity.pictures,
        likedBy: entity.likedBy,
        reviewed: entity.reviewed);
  }
}

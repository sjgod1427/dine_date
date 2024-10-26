class MyUserEntity {
  final String userId;
  final String email;
  final String name;
  final int age;
  final String pronouns;
  final String description;
  final String MyCrzyFoodStory;
  final String Diet;
  final String FavouriteResturants; // New field
  final String EatingHabits; // New field
  final String PlacesWannaVisit; // New field
  final String FavouritCuisine; // New field
  final String DineInOut; // New field
  final Map<String, dynamic> location;
  final List<dynamic> pictures;
  final List<dynamic> likedBy;
  final List<dynamic> reviewed;
  const MyUserEntity(
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

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'age': age,
      'pronouns': pronouns,
      'description': description,
      'MyCrzyFoodStory': MyCrzyFoodStory,
      'Diet': Diet,
      'FavouriteResturants': FavouriteResturants, // Add to document
      'EatingHabits': EatingHabits, // Add to document
      'PlacesWannaVisit': PlacesWannaVisit, // Add to document
      'FavouritCuisine': FavouritCuisine, // Add to document
      'DineInOut': DineInOut, // Add to document
      'location': location,
      'pictures': pictures,
      'likedBy': likedBy,
      'reviewed': reviewed
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
        userId: doc['userId'],
        email: doc['email'],
        name: doc['name'],
        age: doc['age'],
        pronouns: doc['pronouns'],
        description: doc['description'],
        MyCrzyFoodStory: doc['MyCrzyFoodStory'],
        Diet: doc['Diet'],
        FavouriteResturants: doc['FavouriteResturants'], // Update fromDocument
        EatingHabits: doc['EatingHabits'], // Update fromDocument
        PlacesWannaVisit: doc['PlacesWannaVisit'], // Update fromDocument
        FavouritCuisine: doc['FavouritCuisine'], // Update fromDocument
        DineInOut: doc['DineInOut'], // Update fromDocument
        location: doc['location'],
        pictures: doc['pictures'],
        likedBy: doc['likedBy'],
        reviewed: doc['reviewed']);
  }
}

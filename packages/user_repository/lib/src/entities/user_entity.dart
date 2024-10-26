class MyUserEntity {
  final String userId;
  final String email;
  final String name;
  final int age;
  final String description;
  final String MyCrzyFoodStory;
  final String Diet;
  final Map<String, dynamic> location;
  final List<dynamic> pictures;
  final List<dynamic> likedBy;

  const MyUserEntity(
      {required this.userId,
      required this.email,
      required this.name,
      required this.age,
      required this.description,
      required this.MyCrzyFoodStory,
      required this.Diet,
      required this.location,
      required this.pictures,
      required this.likedBy});

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'age': age,
      'description': description,
      'MyCrzyFoodStory': MyCrzyFoodStory,
      'Diet': Diet,
      'location': location,
      'pictures': pictures,
      'likedBy': likedBy
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
        userId: doc['userId'],
        email: doc['email'],
        name: doc['name'],
        age: doc['age'],
        description: doc['description'],
        MyCrzyFoodStory: doc['MyCrzyFoodStory'],
        Diet: doc['Diet'],
        location: doc['location'],
        pictures: doc['pictures'],
        likedBy: doc['likedBy']);
  }
}

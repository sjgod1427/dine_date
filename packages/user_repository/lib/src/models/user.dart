import '../entities/entities.dart';

class MyUser {
  final String userId;
  final String email;
  final String name;
  final int age;
  String description;
  final Map<String, dynamic> location;
  List<dynamic> pictures;
  final List<dynamic> likedBy;

  MyUser(
      {required this.userId,
      required this.email,
      required this.name,
      required this.age,
      required this.description,
      required this.location,
      required this.pictures,
      required this.likedBy});

  static final empty = MyUser(
      userId: '',
      email: '',
      name: '',
      age: 0,
      description: '',
      location: {},
      pictures: [],
      likedBy: []);

  MyUser copyWith(
      {String? userId,
      String? email,
      String? name,
      int? age,
      String? description,
      Map<String, double>? location,
      List<String>? pictures,
      List<dynamic>? likedBy}) {
    return MyUser(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        name: name ?? this.name,
        age: age ?? this.age,
        description: description ?? this.description,
        location: location ?? this.location,
        pictures: pictures ?? this.pictures,
        likedBy: likedBy ?? this.likedBy);
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
        userId: userId,
        email: email,
        name: name,
        age: age,
        description: description,
        location: location,
        pictures: pictures,
        likedBy: likedBy);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        userId: entity.userId,
        email: entity.email,
        name: entity.name,
        age: entity.age,
        description: entity.description,
        location: entity.location,
        pictures: entity.pictures,
        likedBy: entity.likedBy);
  }

  @override
  String toString() {
    return '''MyUser :
  userId: $userId, 
  email: $email, 
  name: $name,
  age: $age,
  description: $description, 
  location: $location,
  pictures: $pictures,
  likedBy:$likedBy
  ''';
  }
}

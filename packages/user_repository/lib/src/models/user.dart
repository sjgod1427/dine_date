import 'package:cloud_firestore/cloud_firestore.dart';

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

  MyUser({
    required this.userId,
    required this.email,
    required this.name,
    required this.age,
    required this.description,
    required this.location,
    required this.pictures,
    required this.likedBy,
  });

  // Empty MyUser instance
  static final empty = MyUser(
    userId: '',
    email: '',
    name: '',
    age: 0,
    description: '',
    location: {},
    pictures: [],
    likedBy: [],
  );

  // Factory method to create MyUser from Firestore document
  factory MyUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MyUser(
      userId: doc.id, // Use document ID as userId
      email: data['email'] ?? '', // Provide default values if fields are null
      name: data['name'] ?? 'Unknown',
      age: data['age'] ?? 0,
      description: data['description'] ?? '',
      location: Map<String, dynamic>.from(data['location'] ?? {}),
      pictures: List<dynamic>.from(data['pictures'] ?? []),
      likedBy: List<dynamic>.from(data['likedBy'] ?? []),
    );
  }

  // Copy with method for creating a modified copy of MyUser
  MyUser copyWith({
    String? userId,
    String? email,
    String? name,
    int? age,
    String? description,
    Map<String, dynamic>? location,
    List<dynamic>? pictures,
    List<dynamic>? likedBy,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      age: age ?? this.age,
      description: description ?? this.description,
      location: location ?? this.location,
      pictures: pictures ?? this.pictures,
      likedBy: likedBy ?? this.likedBy,
    );
  }

  // Converts MyUser instance to MyUserEntity
  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
      name: name,
      age: age,
      description: description,
      location: location,
      pictures: pictures,
      likedBy: likedBy,
    );
  }

  // Creates a MyUser instance from a MyUserEntity
  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
      name: entity.name,
      age: entity.age,
      description: entity.description,
      location: entity.location,
      pictures: entity.pictures,
      likedBy: entity.likedBy,
    );
  }

  @override
  String toString() {
    return '''MyUser:
  userId: $userId, 
  email: $email, 
  name: $name,
  age: $age,
  description: $description, 
  location: $location,
  pictures: $pictures,
  likedBy: $likedBy
  ''';
  }
}

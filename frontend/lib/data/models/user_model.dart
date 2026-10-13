class UserModel {
  final String userId;
  final String name;
  final String email;
  final String bio;
  final List<String> skillsOffered;
  final List<String> skillsWanted;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.bio,
    required this.skillsOffered,
    required this.skillsWanted,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'bio': bio,
      'skillsOffered': skillsOffered,
      'skillsWanted': skillsWanted,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      bio: map['bio'],
      skillsOffered: List<String>.from(map['skillsOffered']),
      skillsWanted: List<String>.from(map['skillsWanted']),
    );
  }
}
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final int age;
  final String title; //* company / title 
  final String? image;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.age,
    required this.title, //* company / title 
    this.image,
  });
}
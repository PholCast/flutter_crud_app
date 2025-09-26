class User {
  final int id;
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

  factory User.fromJson(Map<String, dynamic> data){
    return User(
      id: data['id'] as int,
      firstName: data['firstName'],
      lastName: data['lastName'],
      username: data['username']  ?? '-',
      email: data['email'] ?? '-',
      age: data['age'],
      image: data['image'],
      title: (data['company'] is Map && data['company']?['title'] != null) 
                 ? data['company']['title'] : null,
    );
  }
}
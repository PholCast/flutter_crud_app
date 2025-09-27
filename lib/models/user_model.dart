class User {
  final int id;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String gender;
  final String phone;
  final int age;
  final String country;
  final String title; //* company / title
  final String? image;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.gender,
    required this.phone,
    required this.age,
    required this.country,
    required this.title, //* company / title
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
      id: data['id'] as int,
      firstName: data['firstName'],
      lastName: data['lastName'],
      username: data['username'] ?? '-',
      email: data['email'] ?? '-',
      gender: data['gender'],
      phone: data['phone'],
      age: data['age'],
      country: (data['address'] is Map && data['address']?['country'] != null)
          ? data['address']['country']
          : null,
      image: data['image'],
      title: (data['company'] is Map && data['company']?['title'] != null)
          ? data['company']['title']
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'username': username,
    'phone': phone,
    'gender': gender,
    'age': age,
    'address': {'country': country},
    'company': {'title': title},
    'image': image,
  };
}

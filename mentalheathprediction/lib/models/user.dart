class User {
  final String id;
  final String username;
  final String email;
  final String token;
  final String gender;
  final int age;

  User({this.id, this.username, this.email, this.gender, this.age, this.token});

  factory User.fromJSON(Map<String, dynamic> json) {
    return User(
        id: json['user']['_id'],
        username: json['user']['username'],
        email: json['user']['email'],
        gender: json['user']['gender'],
        age: json['user']['age'],
        token: json['token']);
  }
}

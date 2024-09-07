class LoginEntity{
  final String username;
  final String password;

  LoginEntity({
    required this.username,
    required this.password
  });
 LoginEntity.fromJSON(Map<String, dynamic> json)
      : username = json["username"] as String,
        password = json["password"] as String;

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
    };
  }
  
}
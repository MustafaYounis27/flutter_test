class UserModel{

  String? username;
  String? password;
  String? email;
  String? userImage;
  String? intrestId;
  String? userId;

  UserModel.fromJson(Map<String, dynamic> json)
  {
    username = json['username'];
    password = json['password'];
    email = json['email'];
    userImage = json['imageAsBase64'];
    intrestId = json['intrestId'];
    userId = json['id'];
  }
}
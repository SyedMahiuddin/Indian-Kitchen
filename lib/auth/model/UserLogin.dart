class UserLogin {
  String username;
  String password;
  String finger_print;
  String force;
  String phone_code;

  UserLogin({this.username, this.password, this.force, this.phone_code});

  UserLogin.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    finger_print = json['finger_print'];
    phone_code = json['phone_code'];
    force = json['force'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['finger_print'] = this.finger_print;
    data['phone_code'] = this.phone_code;
    data['force'] = this.force;
    return data;
  }
}
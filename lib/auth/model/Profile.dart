import 'package:hive/hive.dart';

class Profile {
  String name;
  String email;
  String mobile;
  String address;
  String postcode;
  String phone_code;

  Profile(
      {this.name, this.email, this.mobile, this.address, this.postcode, this.phone_code});

  Profile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    address = json['address'];
    postcode = json['postcode'];
    phone_code = json['phone_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['address'] = this.address;
    data['postcode'] = this.postcode;
    data['phone_code'] = this.phone_code;
    return data;
  }
}


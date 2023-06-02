
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mustard/auth/UpdatePassword.dart';
import 'package:mustard/common/Common.dart';
import 'package:mustard/database/LoginResponse.dart';

import '../HomePage.dart';
import 'UpdateProfile.dart';

class UserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserProfile();
  }
}

class _UserProfile extends State<UserProfile> {

  var box;
  LoginResponse loginResponse;

  @override
  void initState() {
    getLoginResponse();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body:WillPopScope(
        onWillPop: () async {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage()));
      return false;
    },
    child: Container(
        color: Colors.black87,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                height: MediaQuery.of(context).padding.top + 80,
                color: Colors.amber[600],
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Profile",
                        style: TextStyle(fontSize: 25, color: Colors.black87),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black87,
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomePage()));
                          }),
                    ),
                  ],
                )),

            loginResponse != null ?
            Column(
              children: [
                SizedBox(height: 10,),
                Icon(Icons.person, size: 100, color: Colors.white,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,

                      child: RaisedButton(
                        color: Colors.white12,
                        textColor: Colors.white,
                        onPressed: () { Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => UpdateProfile())); },
                        child: Text("Update Profile"),
                      ),
                    ),

                    SizedBox(width: 10,),
                    Container(
                      alignment: Alignment.center,
                      child: RaisedButton(
                        color: Colors.white12,
                        textColor: Colors.white,
                        onPressed: () { Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => UpdastePassword())); },
                        child: Text("Update Password"),
                      ),
                    ),
                  ],
                ),
                loginResponse.data.user.name != null?
              buildText("Name: "+loginResponse.data.user.name):Container(height: 0,),
                loginResponse.data.user.mobile != null ?
              buildText("Phone: "+loginResponse.data.user.mobile):Container(height: 0,),
                loginResponse.data.user.email != null ?
              buildText("Email: "+loginResponse.data.user.email):Container(height: 0,),
                loginResponse.data.user.address != null ?
              buildText("Address: "+loginResponse.data.user.address):Container(height: 0,),
                loginResponse.data.user.postcode != null?
              buildText("Post Code: "+loginResponse.data.user.postcode):Container(height: 0,),
              ],
              ): Container(height: 0,),

          ],
        ),
      ),
    ));
  }

  Future<void> getLoginResponse() async {
    box = await Hive.openBox(Common.DATABASE);
    loginResponse = box.get(Common.LOGINRESPONSE) as LoginResponse;
    setState(() {

    });
  }

  buildText(String text) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Text(text,  textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.white),),
    );
  }
}

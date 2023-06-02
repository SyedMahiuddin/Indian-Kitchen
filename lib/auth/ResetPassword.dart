import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

import 'package:http/http.dart' as http;
import 'package:mustard/auth/model/ResponseMessage.dart';
import 'package:mustard/common/Common.dart';
import 'package:mustard/database/LoginResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomePage.dart';
import 'SignIn.dart';


class ResetPassword extends StatefulWidget{

  String username, phoneCode;

  ResetPassword(this.username, this.phoneCode,
      {Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ResetPassword();
  }

}

class _ResetPassword extends State<ResetPassword> {
  TextEditingController finalController, _passwordController, _conPassController;
  FocusNode focusNode, passwordFocusNode, conPassFocusNode;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _isSnackBar = false;

  StreamSubscription<ConnectivityResult> subscription;

  SharedPreferences sharedPreferences;
  LoginResponse loginResponseDataBase;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _passwordController = new TextEditingController();
    _conPassController = new TextEditingController();

    passwordFocusNode = FocusNode();
    conPassFocusNode = FocusNode();

    finalController = _passwordController;

    checkInternetConnection();
    getLoginResponse();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _conPassController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        body: WillPopScope(
        onWillPop: () async{

        Navigator.pop(context);

      return false;
    },
    child: Stack(
          children: [
            Container(
              height: screenHeight,
              color: Colors.black87,
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      height: 80 + MediaQuery.of(context).padding.top,
                      color: Colors.amber[600],
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Reset Password",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black87),
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
                                  Navigator.of(context).pop();
                                }),
                          )
                        ],
                      )),

                  SizedBox(height: 30,),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                  buildTextField(
                      screenHeight,
                      screenWidth,
                      "Password",
                      TextInputType.text,
                      _passwordController,
                      passwordFocusNode,
                      false,
                      true),
                  buildTextField(
                      screenHeight,
                      screenWidth,
                      "Confirm Password",
                      TextInputType.text,
                      _conPassController,
                      conPassFocusNode,
                      false,
                      true),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.all(10),
                      color: Colors.amber[600],
                      onPressed: () {
                        resetPassword();
                      },
                      child:
                      Text('Confirm', style: TextStyle(fontSize: 20, color: Colors.black87)),
                    ),
                  ),
                ])))
                ],
              ),
            ),
            _isLoading
                ?Stack(
              children: [
                Container(
                    height: screenHeight,
                    width: screenWidth,
                    color: Colors.black54,
                    child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                        ))),
                Container(
                  height: screenHeight,
                  alignment: Alignment.center,
                  child: Container(
                    child: IconButton(icon: Icon(Icons.close, size: 30, color: Colors.white,), onPressed: () {
                      setState(() {
                        _isLoading = false;
                      });
                    },),
                  ),
                )
              ],
            )
                : Container(
              height: 0,
            )
          ],
        )
    ));
  }

  buildTextField(
      double screenHeight,
      double screenWidth,
      String hint,
      TextInputType inputType,
      TextEditingController controller,
      FocusNode focusNode,
      bool autoFocus,
      bool obsucure) {
    return Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: TextField(
              onTap: () {
                finalController = controller;
                checkInternetConnectionNow();
              },
              onChanged: (string) {
                checkInternetConnectionNow();
              },
              showCursor: true,
              keyboardType: inputType,
              controller: controller,
              autofocus: true,
              focusNode: focusNode,
              textCapitalization: TextCapitalization.none,
              obscureText: obsucure,
              decoration: InputDecoration(
                fillColor: Colors.white10,
                filled: true,
                //labelText: hint,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.white54),
                contentPadding: EdgeInsets.only(left: 20),

                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              style: new TextStyle(fontSize: 18, color: Colors.white)),
        ));
  }


  void checkInternetConnection() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        showInSnackBar("no internet connection");
      } else {
        removeSnackBar();
      }
    });
  }

  void showInSnackBar(String value) {
    removeSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor:Colors.amber[600],
        content: Text(value),
        duration: Duration(days: 365)));
    setState(() {
      _isSnackBar = true;
    });
  }

  removeSnackBar() {
    if (_isSnackBar) _scaffoldKey.currentState.removeCurrentSnackBar();
    setState(() {
      _isSnackBar = false;
    });
  }

  Future<void> checkInternetConnectionNow() async {
    removeSnackBar();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      removeSnackBar();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      removeSnackBar();
    } else {
      showInSnackBar("no internet connection");
    }
  }

  Future<void> resetPassword() async {

    setState(() {
      _isLoading = true;
    });

    sharedPreferences = await SharedPreferences.getInstance();

    if (_passwordController.text == '') {
      FocusScope.of(context).requestFocus(passwordFocusNode);
      finalController = _passwordController;
      showInSnackBar("enter password");
    } else if (_conPassController.text == '') {
      FocusScope.of(context).requestFocus(conPassFocusNode);
      finalController = _conPassController;
      showInSnackBar("enter confirm password");
    }else if (_passwordController.text.length < 6 || _passwordController.text.length > 30) {
      FocusScope.of(context).requestFocus(passwordFocusNode);
      finalController = _passwordController;
      showInSnackBar("password length should be 6 to 30 digit");
    }else if (_passwordController.text != _conPassController.text) {
      FocusScope.of(context).requestFocus(conPassFocusNode);
      finalController = _conPassController;
      showInSnackBar("password didn't match");
    }
    else {

      var response = await http.put(Common.BASE_URL+"resetpassword",
          body: {"password": _passwordController.text, "username":widget.username});

      print(response.body);


      if (response.statusCode == 200) {

        LoginResponse loginResponse = new LoginResponse();

        loginResponse = LoginResponse.fromJson(json.decode(response.body));

        sharedPreferences.setString("token", loginResponse.token);

        if (loginResponseDataBase == null) {
          var box = await Hive.openBox(Common.DATABASE);
          box.put(Common.LOGINRESPONSE, loginResponse);

          setState(() {
            _isLoading = false;
          });

          Fluttertoast.showToast(msg: loginResponse.message);

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  HomePage()));
        }else if(loginResponse.data.orders.length != 0 || loginResponse.data.favourites.length != 0){

          print("hase order");

          loginResponseDataBase.data.user = loginResponse.data.user;
          loginResponseDataBase.data.orders = loginResponse.data.orders;
          loginResponseDataBase.data.favourites = loginResponse.data.favourites;
          var box = await Hive.openBox(Common.DATABASE);
          box.put(Common.LOGINRESPONSE, loginResponseDataBase);

          setState(() {
            _isLoading = false;
          });

          Fluttertoast.showToast(msg: loginResponse.message);

          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  HomePage()));
        }else{
          setState(() {
            _isLoading = false;
          });

          loginResponseDataBase.data.user = loginResponse.data.user;
          var box = await Hive.openBox(Common.DATABASE);
          box.put(Common.LOGINRESPONSE, loginResponseDataBase);

          Fluttertoast.showToast(msg: loginResponse.message);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) =>
                  HomePage()));
        }
      } else {
        setState(() {
          _isLoading = false;
        });

        ResponseMessage loginErrorResponse =
        ResponseMessage.fromJson(json.decode(response.body));
        showInSnackBar(loginErrorResponse.message);
      }
    }
  }

  Future<void> getLoginResponse() async {
    var box = await Hive.openBox(Common.DATABASE);
    loginResponseDataBase = box.get(Common.LOGINRESPONSE) as LoginResponse;
  }

  Map<String, String> get headers => {
    "Authorization": "Bearer " + sharedPreferences.getString("token")
  };
}

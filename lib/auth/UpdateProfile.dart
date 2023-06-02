import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:mustard/Animations/FadeAnimation.dart';
import 'package:mustard/auth/UserProfile.dart';
import 'package:mustard/auth/model/ResponseMessage.dart';
import 'package:mustard/common/Common.dart';
import 'package:mustard/database/LoginResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../HomePage.dart';
import 'SignIn.dart';
import 'model/Profile.dart';

class UpdateProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UpdateProfile();
  }
}

class _UpdateProfile extends State<UpdateProfile> {
  TextEditingController finalController,
      _userNameController,
      _addressController,
      _phoneController,
      _emailController,
      _postCodeController;

  FocusNode focusNode,
      userNameeFocusNode,
      addressFocusNode,
      phoneFocusNode,
      emailFocusNode,
      postCodeFocusNode;

  bool checkBoxValue = false;
  bool bloodDonarChecboxValue = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _isSnackBar = false;
  LoginResponse loginResponse;

  SharedPreferences sharedPreferences;

  StreamSubscription<ConnectivityResult> subscription;

  String image_url, id;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _userNameController = new TextEditingController();
    _addressController = new TextEditingController();
    _phoneController = new TextEditingController();
    _emailController = new TextEditingController();
    _postCodeController = new TextEditingController();

    focusNode = FocusNode();
    userNameeFocusNode = FocusNode();
    addressFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    postCodeFocusNode = FocusNode();

    finalController = _emailController;

    getUser();
    checkInternetConnection();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _postCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        body: WillPopScope(
            onWillPop: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserProfile()));
              return false;
            },
            child: Stack(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  color: Colors.black87,
                  // decoration: BoxDecoration(
                  //   // borderRadius:
                  //   // BorderRadius.all(Radius.circular(50.0)),
                  //     gradient: LinearGradient(
                  //         begin: Alignment.bottomLeft,
                  //         end: Alignment.topRight,
                  //         colors: [Colors.purple, Color(0xffB72027)])),
                  child: FadeAnimation(
                    1.5,
                    Column(
                      children: [
                        Container(
                          height: 80,
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Update Profile",
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfile()));
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: [
                              buildTextField(
                                  screenHeight,
                                  screenWidth,
                                  "Name",
                                  TextInputType.emailAddress,
                                  _userNameController,
                                  userNameeFocusNode,
                                  false,
                                  false),
                              buildTextField(
                                  screenHeight,
                                  screenWidth,
                                  "Mobile",
                                  TextInputType.text,
                                  _phoneController,
                                  phoneFocusNode,
                                  false,
                                  false),
                              buildTextField(
                                  screenHeight,
                                  screenWidth,
                                  "Email",
                                  TextInputType.text,
                                  _emailController,
                                  emailFocusNode,
                                  false,
                                  false),
                              buildTextField(
                                  screenHeight,
                                  screenWidth,
                                  "Address",
                                  TextInputType.text,
                                  _addressController,
                                  addressFocusNode,
                                  false,
                                  false),
                              buildTextField(
                                  screenHeight,
                                  screenWidth,
                                  "Post Code",
                                  TextInputType.text,
                                  _postCodeController,
                                  postCodeFocusNode,
                                  false,
                                  false),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    right: 20, top: 20, left: 20, bottom: 20),
                                child: RaisedButton(
                                  onPressed: () {
                                    update();
                                  },
                                  color: Colors.amber[600],
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Update",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ),
                _isLoading
                    ? Stack(
                        children: [
                          Container(
                              height: screenHeight,
                              width: screenWidth,
                              color: Colors.black54,
                              child: Center(
                                  child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.green),
                              ))),
                          Container(
                            height: screenHeight,
                            alignment: Alignment.center,
                            child: Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(
                        height: 0,
                      )
              ],
            )));
  }

  void listener() {
    final text = finalController.text;
    finalController.value = finalController.value.copyWith(
      text: text,
      selection:
          TextSelection(baseOffset: text.length, extentOffset: text.length),
      composing: TextRange.empty,
    );
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
        backgroundColor: Colors.amber[600],
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

  Future<void> register() async {
    if (_userNameController.text == '') {
      FocusScope.of(context).requestFocus(userNameeFocusNode);
      finalController = _userNameController;
      showInSnackBar("Enter Name");
    } else {
      setState(() {
        _isLoading = true;
      });
    }
  }

  void checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      String token = sharedPreferences.getString("token");
    }
  }

  update() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if (_userNameController.text == '') {
      FocusScope.of(context).requestFocus(userNameeFocusNode);
      finalController = _userNameController;
      showInSnackBar("Enter Name");
    } else if (_phoneController.text == '') {
      FocusScope.of(context).requestFocus(phoneFocusNode);
      finalController = _phoneController;
      showInSnackBar("Enter Mobile");
    } else if (_emailController.text == '') {
      FocusScope.of(context).requestFocus(emailFocusNode);
      finalController = _emailController;
      showInSnackBar("Enter Email");
    } else if (_addressController.text == '') {
      FocusScope.of(context).requestFocus(addressFocusNode);
      finalController = _addressController;
      showInSnackBar("Enter Address");
    } else if (_postCodeController.text == '') {
      FocusScope.of(context).requestFocus(postCodeFocusNode);
      finalController = _postCodeController;
      showInSnackBar("Enter Post Code");
    } else {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });

      Profile profile = new Profile();
      profile.name = _userNameController.text;
      profile.email = _emailController.text;
      profile.mobile = _phoneController.text;
      profile.phone_code = loginResponse.data.user.phone_code;
      profile.mobile = _phoneController.text;
      profile.address = _addressController.text;
      profile.postcode = _postCodeController.text;

      var response = await http.put(Common.BASE_URL + "user/update",
          body: profile.toJson(), headers: headers);

      if (response.statusCode == 200) {
        var box = await Hive.openBox(Common.DATABASE);
        loginResponse.data.user.name = _userNameController.text;
        loginResponse.data.user.mobile = _phoneController.text;
        loginResponse.data.user.email = _emailController.text;
        loginResponse.data.user.address = _addressController.text;
        loginResponse.data.user.postcode = _postCodeController.text;

        box.put(Common.LOGINRESPONSE, loginResponse);

        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: "profile updated");
      } else {
        setState(() {
          _isLoading = false;
        });
        ResponseMessage loginErrorResponse =
            ResponseMessage.fromJson(json.decode(response.body));
        showInSnackBar(loginErrorResponse.message);
      }

      print(response.body);

      //reloadProduct();

      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (BuildContext context) => HomePage()));
    }
  }

  Map<String, String> get headers =>
      {"Authorization": "Bearer " + sharedPreferences.getString("token")};

  Future<void> getUser() async {
    var box = await Hive.openBox(Common.DATABASE);
    loginResponse = box.get(Common.LOGINRESPONSE);

    _userNameController.text = loginResponse.data.user.name != null
        ? loginResponse.data.user.name
        : "";
    _phoneController.text = loginResponse.data.user.mobile;
    _emailController.text = loginResponse.data.user.email != null
        ? loginResponse.data.user.email
        : "";
    _addressController.text = loginResponse.data.user.address != null
        ? loginResponse.data.user.address
        : "";
    _postCodeController.text = loginResponse.data.user.postcode != null
        ? loginResponse.data.user.postcode
        : "";

    _userNameController.selection = TextSelection.fromPosition(
        TextPosition(offset: _userNameController.text.length));

    box.close();
  }
}

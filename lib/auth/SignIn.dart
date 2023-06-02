import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gson/gson.dart';
import 'package:hive/hive.dart';
import 'package:mustard/Animations/FadeAnimation.dart';
import 'package:mustard/ViewCart.dart';
import 'package:mustard/common/Common.dart';
import 'package:mustard/database/Cart.dart';
import 'package:mustard/database/LoginResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../HomePage.dart';
import 'Verification.dart';
import 'model/ResponseMessage.dart';
import 'model/UserLogin.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignIn();
  }
}

class _SignIn extends State<SignIn> {
  TextEditingController finalController, _emailController, _passwordController;
  FocusNode focusNode, emailFocusNode, phoneFocusNode, passwordFocusNode;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _isSnackBar = false;
  bool _isSync = true;
  bool _isCalled = false;
  bool _obSecure = true;

  SharedPreferences sharedPreferences;

  StreamSubscription<ConnectivityResult> subscription;

  LoginResponse loginResponseDataBase;
  Cart cart = new Cart();
  var box;
  List<PhoneCode> phoneCodeList = new List();
  String _dropDownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();

    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    finalController = _emailController;

    //checkLoginStatus();
    checkInternetConnection();

  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
              height: screenHeight,
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: Colors.black87,
              // decoration: BoxDecoration(
              //     // borderRadius:
              //     // BorderRadius.all(Radius.circular(50.0)),
              //     gradient: LinearGradient(
              //         begin: Alignment.bottomLeft,
              //         end: Alignment.topRight,
              //         colors: [Colors.purple, Color(0xffB72027)])),
              child: FadeAnimation(
                1.5,
               SingleChildScrollView(
                    child:
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 20),
                      child:Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10, top: 10),
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }),
                          ),
                          Container(
                            height: 70,
                            alignment: Alignment.center,
                            child: Image.asset(
                              "images/logo.png",
                              //style: TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      ),

                    Container(
                        padding: EdgeInsets.only(right: 20, left: 20, bottom: 5),
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {

                          },
                          child: Text(
                            "Enter your info to Sign In / Sign Up",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )),
                    Container(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: Row(
                              children: [
                                // Container(
                                //   color: Colors.white10,
                                //   padding: EdgeInsets.only(left: 20),
                                //   width: 80,
                                //   child: DropdownButton(
                                //     dropdownColor: Colors.black54,
                                //     hint: _dropDownValue == null
                                //         ? Text(
                                //             '',
                                //             textAlign: TextAlign.center,
                                //             style: TextStyle(
                                //                 color: Colors.white54),
                                //           )
                                //         : Text(
                                //             _dropDownValue,
                                //             style:
                                //                 TextStyle(color: Colors.white),
                                //           ),
                                //     isExpanded: true,
                                //     iconSize: 30.0,
                                //     style: TextStyle(color: Colors.white),
                                //     items: phoneCodeList.map(
                                //       (PhoneCode ph) {
                                //         return DropdownMenuItem<String>(
                                //           value: ph.countryCode,
                                //           child: Text(ph.countryCode),
                                //         );
                                //       },
                                //     ).toList(),
                                //     onChanged: (val) {
                                //       setState(
                                //         () {
                                //           _dropDownValue = val;
                                //         },
                                //       );
                                //     },
                                //   ),
                                // ),
                                Expanded(
                                  child: TextField(
                                      onTap: () {
                                        finalController = _emailController;
                                        checkInternetConnectionNow();
                                      },
                                      onChanged: (string) {
                                        checkInternetConnectionNow();
                                      },
                                      showCursor: true,
                                      keyboardType: TextInputType.emailAddress,
                                      controller: _emailController,
                                      focusNode: emailFocusNode,
                                      textCapitalization:
                                          TextCapitalization.none,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white10,
                                        filled: true,
                                        //labelText: hint,
                                        hintText: "Enter Your Email",
                                        hintStyle:
                                            TextStyle(color: Colors.white54),
                                        contentPadding:
                                            EdgeInsets.only(left: 20, right: 20),

                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      style: new TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                )
                              ],
                            ))),
                    buildTextField(
                        screenHeight,
                        screenWidth,
                        "Password",
                        TextInputType.text,
                        _passwordController,
                        passwordFocusNode,
                        false,
                        _obSecure),
                    Container(
                        padding: EdgeInsets.only(right: 40, top: 10),
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Verification()));
                          },
                          child: Text(
                            "Forgot Username/Password?",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        )),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          right: 20, top: 20, left: 20, bottom: 20),
                      child: RaisedButton(
                        onPressed: () {
                          signInButtonPressed();
                        },
                        color: Colors.amber[600],
                        child: Container(
                          padding: EdgeInsets.all(12),
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black87,
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
                  ),
                )
              ,
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
                              color: Colors.white54,
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
                  ),
            // _isSync
            //     ? Container(
            //         height: screenHeight,
            //         width: screenWidth,
            //         color: Colors.black,
            //         child: Container(
            //             height: screenHeight,
            //             width: screenWidth,
            //             color: Colors.white12,
            //             child: Image.asset(
            //               "images/logo.png",
            //             )))
            //     : Container(
            //         height: 0,
            //       )
          ],
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
            textAlignVertical: TextAlignVertical.center,
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
              autofocus: autoFocus,
              focusNode: focusNode,
              textCapitalization: TextCapitalization.none,
              obscureText: obsucure,
              decoration: InputDecoration(
                suffixIcon: IconButton(icon: obsucure ? Icon(Icons.visibility, color: Colors.white70,) : Icon(Icons.visibility_off, color: Colors.white70,), onPressed: (){
                  setState(() {
                    _obSecure = !_obSecure;
                  });
                },),
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
        setState(() {
          _isSync = false;
        });
        showInSnackBar("no internet connection");
      } else {
        removeSnackBar();
        // if(phoneCodeList.length == 0 && !_isCalled)
        // getLoginResponse();
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

  Future<void> signInButtonPressed() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (_emailController.text == '') {
      FocusScope.of(context).requestFocus(emailFocusNode);
      finalController = _emailController;
      showInSnackBar("enter email or phone");
    } else if (_passwordController.text == '') {
      FocusScope.of(context).requestFocus(passwordFocusNode);
      finalController = _passwordController;
      showInSnackBar("enter password");
    } else if (_passwordController.text.length < 6) {
      FocusScope.of(context).requestFocus(passwordFocusNode);
      finalController = _passwordController;
      showInSnackBar("minimum 6 digit required for password");
    } else if (_passwordController.text.length > 30) {
      FocusScope.of(context).requestFocus(passwordFocusNode);
      finalController = _passwordController;
      showInSnackBar("maximum 30 digit required for password");
    } else {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });

      String force = "false";
      loginResponseDataBase != null ? force = "false" : force = "true";

      String fingerPrint = "";
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        fingerPrint = androidInfo.fingerprint;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        fingerPrint = iosInfo.identifierForVendor;
      }

      var response = await http.post(Common.BASE_URL +
          "loginregister?username=${_emailController.text}&password=${_passwordController.text}&finger_print=$fingerPrint&force=d$force");

      print(response.body);

      if (response.statusCode == 200) {
        LoginResponse loginResponse = new LoginResponse();

        loginResponse = LoginResponse.fromJson(json.decode(response.body));

        sharedPreferences.setString("token", loginResponse.token);

        if (loginResponseDataBase == null) {
          var box = await Hive.openBox(Common.DATABASE);
          box.put(Common.LOGINRESPONSE, loginResponse);

          Fluttertoast.showToast(msg: loginResponse.message);

          Navigator.of(context).pop();

        } else if (loginResponse.data.orders.length != 0 ||
            loginResponse.data.favourites.length != 0) {
          loginResponseDataBase.data.user = loginResponse.data.user;
          loginResponseDataBase.data.orders = loginResponse.data.orders;
          loginResponseDataBase.data.favourites = loginResponse.data.favourites;
          var box = await Hive.openBox(Common.DATABASE);
          box.put(Common.LOGINRESPONSE, loginResponseDataBase);

          Fluttertoast.showToast(msg: loginResponse.message);

          Navigator.of(context).pop();

        } else {
          loginResponseDataBase.data.user = loginResponse.data.user;
          loginResponseDataBase.data.orders = loginResponse.data.orders;
          var box = await Hive.openBox(Common.DATABASE);
          box.put(Common.LOGINRESPONSE, loginResponseDataBase);

          Fluttertoast.showToast(msg: loginResponse.message);
          Navigator.of(context).pop();
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

  // Future<void> checkLoginStatus() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   if (sharedPreferences.getString("token") != null) {
  //     if(cart.productCartItem.length != 0){
  //       Navigator.of(context).push(MaterialPageRoute(
  //           builder: (BuildContext context) =>
  //           //   UserDashboard(loginDashboard)));
  //           ViewCart()));
  //     }else {
  //       Navigator.of(context).push(MaterialPageRoute(
  //           builder: (BuildContext context) =>
  //           //   UserDashboard(loginDashboard)));
  //           HomePage()));
  //     }
  //   }else{
  //     getLoginResponse();
  //   }
  // }
  //
  // Future<void> getLoginResponse() async {
  //   _isCalled = true;
  //   box = await Hive.openBox(Common.DATABASE);
  //   loginResponseDataBase = box.get(Common.LOGINRESPONSE);
  //   cart = box.get(Common.CART);
  //
  //
  //   setState(() {
  //     _isSync = false;
  //   });
  //
  //   //reloadProduct();
  // }
  //
  // Future<void> reloadProduct() async {
  //
  //   try {
  //     var response = await http.get(Common.BASE_URL + "sync");
  //
  //     print(response.body);
  //
  //     if (response.statusCode == 200) {
  //       LoginResponse reloadLoginResponse = new LoginResponse();
  //
  //       reloadLoginResponse =
  //           LoginResponse.fromJson(json.decode(response.body));
  //
  //       var box = await Hive.openBox(Common.DATABASE);
  //       box.put(Common.LOGINRESPONSE, reloadLoginResponse);
  //
  //       getPhoneCode(reloadLoginResponse.data.config);
  //     } else {
  //       setState(() {
  //         _isCalled = false;
  //         _isSync = false;
  //       });
  //     }
  //   }on Exception catch(e){
  //     setState(() {
  //       _isCalled = false;
  //       _isSync = false;
  //     });
  //   }
  // }
  //
  // void getPhoneCode(List<Config> config) {
  //   for (int i = 0; i < config.length; i++) {
  //     if (config[i].alias == Common.PHONE_CODE) {
  //       List list = json.decode(config[i].value);
  //       phoneCodeList.clear();
  //       for (int i = 0; i < list.length; i++) {
  //         phoneCodeList.add(PhoneCode.fromJson(list[i]));
  //       }
  //       _dropDownValue = phoneCodeList[0].countryCode;
  //       setState(() {
  //         _isSync = false;
  //       });
  //     }
  //   }
  //   _isCalled = false;
  // }
  //
  // bool isNumeric(String s) {
  //   if (s == null) {
  //     return false;
  //   }
  //   return double.parse(s, (e) => null) != null;
  // }
  //
  // String getSelectedPhoneCode() {
  //   for (int i = 0; i < phoneCodeList.length; i++) {
  //     if (_dropDownValue == phoneCodeList[i].countryCode) {
  //       return phoneCodeList[i].phoneCode;
  //     }
  //   }
  // }
}

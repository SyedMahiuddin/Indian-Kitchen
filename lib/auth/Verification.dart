import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:mustard/common/Common.dart';
import 'package:mustard/database/LoginResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'ResetPassword.dart';
import 'model/ResponseMessage.dart';

class Verification extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Verification();
  }
}

class _Verification extends State<Verification> {
  TextEditingController finalController,
      _phoneController,
      _verificationCodeController;
  FocusNode focusNode, phoneFocusNode, verificationCodeFocusNode;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _isSnackBar = false;

  SharedPreferences sharedPreferences;

  StreamSubscription<ConnectivityResult> subscription;

  bool _verifyPage = false;
  String verification;
  String smsCode;
  String mobileNo;

  FirebaseAuth firebaseAuth;

  String verificationType = "";
  String verificationCode = "";
  List<PhoneCode> phoneCodeList = new List();
  String _dropDownValue;
  LoginResponse loginResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _phoneController = new TextEditingController();
    _verificationCodeController = new TextEditingController();

    phoneFocusNode = FocusNode();
    verificationCodeFocusNode = FocusNode();

    finalController = _phoneController;

    Firebase.initializeApp().whenComplete(() {
      firebaseAuth = FirebaseAuth.instance;
      setState(() {});
    });

    checkInternetConnection();
    //getLoginResponse();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _verificationCodeController.dispose();

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
              if (_verifyPage) {
                setState(() {
                  _verificationCodeController.text = "";
                  _verifyPage = false;
                  removeSnackBar();
                });
              } else {
                Navigator.pop(context);
              }
              return false;
            },
            child: Stack(
              children: [
                Container(
                  color: Colors.black87,
                  // decoration: BoxDecoration(
                  //   // borderRadius:
                  //   // BorderRadius.all(Radius.circular(50.0)),
                  //     gradient: LinearGradient(
                  //         begin: Alignment.bottomLeft,
                  //         end: Alignment.topRight,
                  //         colors: [Colors.purple, Color(0xffB72027)])),
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top),
                          height: 80 + MediaQuery.of(context).padding.top,
                          color: Colors.amber[600],
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Verification",
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.black87),
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
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              child: Row(
                                children: [
                                  // Container(
                                  //   color: Colors.white12,
                                  //   padding: EdgeInsets.only(left: 20),
                                  //   width: 80,
                                  //   child: DropdownButton(
                                  //     dropdownColor: Colors.black54,
                                  //     hint: _dropDownValue == null
                                  //         ? Text(
                                  //       '',
                                  //       textAlign: TextAlign.center,
                                  //       style: TextStyle(color: Colors.white54),
                                  //     )
                                  //         : Text(
                                  //       _dropDownValue,
                                  //       style: TextStyle(color: Colors.white),
                                  //     ),
                                  //     isExpanded: true,
                                  //     iconSize: 30.0,
                                  //     style: TextStyle(color: Colors.white),
                                  //     items: phoneCodeList.map(
                                  //           (PhoneCode ph) {
                                  //         return DropdownMenuItem<String>(
                                  //           value: ph.countryCode,
                                  //           child: Text(ph.countryCode),
                                  //         );
                                  //       },
                                  //     ).toList(),
                                  //     onChanged: (val) {
                                  //       setState(
                                  //             () {
                                  //           _dropDownValue = val;
                                  //         },
                                  //       );
                                  //     },
                                  //   ),
                                  // ),
                                  Expanded(child:
                                  TextField(
                                      onTap: () {
                                        finalController = _phoneController;
                                        checkInternetConnectionNow();
                                      },
                                      onChanged: (string) {
                                        checkInternetConnectionNow();
                                      },
                                      showCursor: true,
                                      keyboardType: TextInputType.text,
                                      controller: _phoneController,
                                      autofocus: true,
                                      focusNode: phoneFocusNode,
                                      textCapitalization: TextCapitalization.none,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white10,
                                        filled: true,
                                        //labelText: hint,
                                        hintText: "Enter Your Email",
                                        hintStyle: TextStyle(color: Colors.white54),
                                        contentPadding: EdgeInsets.only(left: 20),

                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                      style: new TextStyle(fontSize: 18, color: Colors.white)),)
                                ],
                              )
                          )),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(right: 20, top: 20, left: 20),
                        child: RaisedButton(
                          onPressed: () {
                            confirmPhoneNumber();
                          },
                          color: Colors.amber[600],
                          child: Container(
                            padding: EdgeInsets.all(12),
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text(
                              "Verify",
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
                Container(
                    height: _verifyPage ? screenHeight : 0,
                    width: screenWidth,
                    color: Colors.black54,
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          height: screenHeight,
                          width: screenWidth,
                          color: _isLoading ? Colors.black26 : Colors.black87,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                             Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        "Verification code has been sent to ${_phoneController.text}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),

                              Text(
                                      "Enter Verification Code",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),

                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  onTap: () {
                                    checkInternetConnectionNow();
                                  },
                                  onChanged: (string) {
                                    checkInternetConnectionNow();
                                  },
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                  keyboardType: TextInputType.number,
                                  controller: _verificationCodeController,
                                  focusNode: verificationCodeFocusNode,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  color: Colors.amber[600],
                                  onPressed: () {
                                    if (_verificationCodeController.text !=
                                        "") {
                                      confirmEmailVerification();
                                    } else {
                                      Fluttertoast.showToast(msg: "Enter Code");
                                    }
                                  },
                                  child: Text('Confirm',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black87)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _verifyPage
                            ? Container(
                                padding: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).padding.top + 20,
                                    left: 10),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _verificationCodeController.text = "";
                                      _verifyPage = false;
                                      removeSnackBar();
                                    });
                                  },
                                ),
                              )
                            : Container(
                                height: 0,
                              )
                      ],
                    )),
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
                      )
              ],
            )));
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
                fillColor: Colors.white12,
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

  Future<void> confirmPhoneNumber() async {
    if (_phoneController.text == '') {
      FocusScope.of(context).requestFocus(phoneFocusNode);
      finalController = _phoneController;
      showInSnackBar("Enter Email");
    } else {
      setState(() {
        FocusScope.of(context).unfocus();
        _isLoading = true;
      });
      confirmEmail();

      // if (isNumeric(_phoneController.text.substring(0, 1))) {
      //   verificationType = "phone";
      //   verifyPhone("+"+getSelectedPhoneCode() + _phoneController.text);
      // } else {
      //   verificationType = "email";
      //   confirmEmail();
      // }
    }
  }

  Future<void> confirmEmail() async {
    var response = await http.post(Common.BASE_URL + "resetpassword?username="+_phoneController.text+"&verify_token="+getToken(),);
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
        _verifyPage = true;
        finalController = _verificationCodeController;
        FocusScope.of(context).requestFocus(verificationCodeFocusNode);
      });
    } else {
      setState(() {
        _isLoading = false;
        _verifyPage = false;
        finalController = _phoneController;
        focusNode = phoneFocusNode;
      });
      ResponseMessage loginErrorResponse = new ResponseMessage();
      loginErrorResponse =
          ResponseMessage.fromJson(json.decode(response.body));
      showInSnackBar(loginErrorResponse.message);
    }
  }

  Future<void> verifyPhone(String phone) async {
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) {
          setState(() {
            FocusScope.of(context).unfocus();
            _isLoading = true;
          });
          firebaseAuth
              .signInWithCredential(authCredential)
              .then((UserCredential result) {
            verified();
          }).catchError((e) {
            print(e);
          });
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);

          setState(() {
            _isLoading = false;
          });
          showInSnackBar("Verification Failed");
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          setState(() {
            _isLoading = false;
            _verifyPage = true;
            finalController = _verificationCodeController;
            FocusScope.of(context).requestFocus(verificationCodeFocusNode);
          });
          verification = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _isLoading = false;
          });
        });
  }

  void confirmVerification() {
    setState(() {
      FocusScope.of(context).unfocus();
      _isLoading = true;
    });
    if (_verificationCodeController.text != '' &&
        _verificationCodeController.text.length == 6) {
      smsCode = _verificationCodeController.text.trim();

      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verification, smsCode: smsCode);
      firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential result) {
        verified();
      }).catchError((e) {
        showInSnackBar("Invalid Phone Code");
        print(e);
      });
    } else {
      showInSnackBar("Enter Valid Phone Code");
    }
    setState(() {
      _isLoading = false;
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  Future<void> confirmEmailVerification() async {
    FocusScope.of(context).unfocus();

    if(verificationCode == _verificationCodeController.text){
      verified();
    }else{
      showInSnackBar("Invalid Code");
    }
  }

  void verified() {
    setState(() {
      _isLoading = false;
      _verifyPage = false;
    });
    _verificationCodeController.text = "";
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ResetPassword(_phoneController.text, getSelectedPhoneCode())));
  }

  String getToken() {
    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    print(code);
    verificationCode = code.toString();
    return code.toString();
  }

  void getPhoneCode(List<Config> config) {
    for (int i = 0; i < config.length; i++) {
      if (config[i].alias == Common.PHONE_CODE) {
        List list = json.decode(config[i].value);
        for (int i = 0; i < list.length; i++) {
          phoneCodeList.add(PhoneCode.fromJson(list[i]));
        }
        _dropDownValue = phoneCodeList[0].countryCode;
        setState(() {});
      }
    }
  }

  String getSelectedPhoneCode() {
    for(int i = 0; i < phoneCodeList.length; i++){
      if(_dropDownValue == phoneCodeList[i].countryCode){
        return  phoneCodeList[i].phoneCode;
      }
    }
  }

  Future<void> getLoginResponse() async {
    var box = await Hive.openBox(Common.DATABASE);
    loginResponse = box.get(Common.LOGINRESPONSE);
    getPhoneCode(loginResponse.data.config);
  }
}

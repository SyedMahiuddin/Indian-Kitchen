import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:mustard/auth/model/ResponseMessage.dart';
import 'package:mustard/common/Common.dart';
import 'package:mustard/database/LoginResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../HomePage.dart';


class VerifyEmail extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VerifyEmail();
  }
}

class _VerifyEmail extends State<VerifyEmail> {
  TextEditingController finalController,
      _emailController,
      _verificationCodeController;
  FocusNode focusNode, emailFocusNode, verificationCodeFocusNode;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _isSnackBar = false;
  var box;
  LoginResponse loginResponse;

  SharedPreferences sharedPreferences;

  StreamSubscription<ConnectivityResult> subscription;

  bool _verifyPage = false;
  String verification;
  String smsCode;
  String mobileNo;
  String verificationCode = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _emailController = new TextEditingController();
    _verificationCodeController = new TextEditingController();

    _emailController.addListener(listener);
    _verificationCodeController.addListener(listener);

    emailFocusNode = FocusNode();
    verificationCodeFocusNode = FocusNode();

    finalController = _emailController;

    checkInternetConnection();

    getData();
  }

  @override
  void dispose() {
    _emailController.dispose();
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
          onWillPop: () async{
            if(_verifyPage){
              setState(() {
                _verificationCodeController.text = "";
                _verifyPage = false;
                removeSnackBar();
              });
            }else{
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
                      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                      height: 80 + MediaQuery.of(context).padding.top,
                      color: Colors.amber[600],
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Email Verification",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white),
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
                                  Navigator.of(context).pop();
                                }),
                          )
                        ],
                      )),

                  SizedBox(height: 50,),

                  buildTextField(
                      screenHeight,
                      screenWidth,
                      "Enter your email",
                      TextInputType.emailAddress,
                      _emailController,
                      emailFocusNode,
                      false,
                      false),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(right: 20, top: 20, left: 20),
                    child: RaisedButton(
                      onPressed: () {
                        confirmEmail();
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
            ),
            Container(
              height: _verifyPage ? screenHeight : 0,
              width: screenWidth,
              color: Colors.white,
              child:
            Stack(
              children: [
                 Container(
                      padding: EdgeInsets.all(20),
                      height: screenHeight,
                      width: screenWidth,
                      color: Colors.black87,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(20),
                            child:  Text(
                              "Verification code has been sent to ${_emailController.text}",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16, color: Colors.white,),
                            ),
                          ),
                          Text(
                            "Enter Verification Code",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextField(
                              onTap: (){
                                checkInternetConnectionNow();
                              },
                              onChanged: (string){
                                checkInternetConnectionNow();
                              },
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 25, color: Colors.white),
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
                                if(_verificationCodeController.text != "") {
                                  confirmVerification();
                                }else{
                                  Fluttertoast.showToast(msg: "Enter Code");
                                }
                              },
                              child:
                              Text('Confirm', style: TextStyle(fontSize: 20, color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                _verifyPage ?
                Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20, left: 10),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_outlined, color: Colors.white,),
                    onPressed: (){
                      setState(() {
                        _verificationCodeController.text = "";
                        _verifyPage = false;
                        removeSnackBar();
                      });
                    },
                  ),
                ): Container(height: 0,)
              ],
            ),),
            _isLoading
                ? Stack(
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
                    child: IconButton(icon: Icon(Icons.close, size: 30, color: Colors.white54,), onPressed: () {
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

  Future<void> confirmEmail() async {

    if (_emailController.text == '') {
      FocusScope.of(context).requestFocus(emailFocusNode);
      finalController = _emailController;
      showInSnackBar("enter email or phone");
    } else {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });

      var response = await http.post(Common.BASE_URL + "resetpassword?username="+_emailController.text+"&verify_token="+getToken(),);
      print(response.body);

      if(response.statusCode == 200){
        setState(() {
          _isLoading = false;
          _verifyPage = true;
          finalController = _verificationCodeController;
          FocusScope.of(context).requestFocus(verificationCodeFocusNode);
        });
      }else{
        setState(() {
          _isLoading = false;
          _verifyPage = false;
          finalController = _emailController;
          FocusScope.of(context).requestFocus(emailFocusNode);
        });
        ResponseMessage loginErrorResponse = new ResponseMessage();
        loginErrorResponse = ResponseMessage.fromJson(json.decode(response.body));
        showInSnackBar(loginErrorResponse.message);
      }

    }
  }


  Future<void> confirmVerification() async {
    FocusScope.of(context).unfocus();

    if(verificationCode == _verificationCodeController.text) {
      loginResponse.data.user.isEmailVerified = 1;

      box.put(Common.LOGINRESPONSE, loginResponse);

      Fluttertoast.showToast(msg: "verification successful");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
          //   UserDashboard(loginDashboard)));
          HomePage()));

    }else{
       showInSnackBar("Invalid Code");
      }

  }

  Map<String, String> get headers => {
    "Authorization": "Bearer " + sharedPreferences.getString("token")
  };

  Future<void> getData() async {
    box = await Hive.openBox(Common.DATABASE);
    loginResponse = box.get(Common.LOGINRESPONSE);
    setState(() {
      _emailController.text = loginResponse.data.user.email;
      _emailController.selection = TextSelection.fromPosition(TextPosition(offset: _emailController.text.length));

    });
    sharedPreferences = await SharedPreferences.getInstance();
  }

  String getToken() {
    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    print(code);
    verificationCode = code.toString();
    return code.toString();
  }
}

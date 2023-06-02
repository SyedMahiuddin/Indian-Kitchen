import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mustard/auth/SignIn.dart';
import 'package:mustard/database/LoginResponse.dart';
import 'package:mustard/database/ReservationPlaceOrder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'OrderSuccessPage.dart';
import 'auth/model/ResponseMessage.dart';
import 'common/Common.dart';
import 'database/Cart.dart';

class Reservation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Reservation();
  }
}

class _Reservation extends State<Reservation> {
  TextEditingController finalController,
      _noOfGuestController,
      _specialRequirementController,
      _nameController,
      _phoneController,
      _emailController,
      _addressController,
      _postCodeController;
  FocusNode focusNode,
      noOfGuestFocusNode,
      specialRequirementFocusNode,
      nameFocusNode,
      phoneFocusNode,
      emailFocusNode,
      addressFocusNode,
      postCodeFocusNode;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  bool _isSnackBar = false;
  bool _isSubscribe = false;
  String token;
  SharedPreferences sharedPreferences;

  StreamSubscription<ConnectivityResult> subscription;

  LoginResponse loginResponse;
  var box;
  List<PhoneCode> phoneCodeList = new List();
  String _dropDownValuePhone;

  DateTime _dateTime;
  String deliveryDate;

  String dropdownValue = "Select";
  List<String> spinnerItems = ["Select"];

  String dropdownValueOccasion = "Select";
  List<String> spinnerItemsOccasion = [
    "Select",
    "Breakfast",
    "Lunch",
    "Dinner",
    "Other"
  ];
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new ScrollController();
    _noOfGuestController = new TextEditingController();
    _specialRequirementController = new TextEditingController();
    _nameController = new TextEditingController();
    _phoneController = new TextEditingController();
    _emailController = new TextEditingController();
    _addressController = new TextEditingController();
    _postCodeController = new TextEditingController();

    noOfGuestFocusNode = FocusNode();
    specialRequirementFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    addressFocusNode = FocusNode();
    postCodeFocusNode = FocusNode();

    deliveryDate = DateFormat("dd/MM/yyyy").format(getLondonTime());
    finalController = _noOfGuestController;
    checkLoginStatus();
    checkInternetConnection();
    getLoginResponse();
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
              color: Colors.black87,
              child: Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).padding.top + 80,
                      color: Colors.amber[600],
                      alignment: Alignment.center,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top),
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Request a Reservation",
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
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                height: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  child: Image.asset(
                                    "images/logo_home.png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 25, bottom: 5),
                                child: Text(
                                  "Special Instruction",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.amber[400]),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 25, bottom: 10),
                                child: Text(
                                  'Please use the "special request" section to list any dietary requirements or special requests. We will endeavour to meet these requirements and requests but we cannot guarantee them. \nYour reservation should be accepted automatically but if there is any problem we will get back to you via the phone or email address provided',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ),
                              buildTextField(
                                  screenHeight,
                                  screenWidth,
                                  "No. of Guest(s)",
                                  TextInputType.number,
                                  _noOfGuestController,
                                  noOfGuestFocusNode,
                                  false,
                                  false),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 10),
                                child: Card(
                                    color: Colors.white10,
                                    elevation: 5,
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  "Occasion : ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DropdownButton<String>(
                                                value: dropdownValueOccasion,
                                                icon: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.green,
                                                ),
                                                iconSize: 24,
                                                elevation: 16,
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                                underline: SizedBox(),
                                                onChanged: (String data) {
                                                  setState(() {
                                                    dropdownValueOccasion =
                                                        data;
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                        new FocusNode());
                                                  });
                                                },
                                                items: spinnerItemsOccasion.map<
                                                    DropdownMenuItem<
                                                        String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                              ),
                                            ],
                                          ),
                                        ))),
                              ),
                              buildTextField(
                                  screenHeight,
                                  screenWidth,
                                  "Special Requirements (optional)",
                                  TextInputType.multiline,
                                  _specialRequirementController,
                                  specialRequirementFocusNode,
                                  false,
                                  false),
                              Container(
                                padding:
                                EdgeInsets.only(left: 15, right: 15, top: 10),
                                child: Card(
                                    color: Colors.white10,
                                    elevation: 5,
                                    child: Container(
                                      padding: EdgeInsets.all(
                                        12,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              "Select Date : ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                final DateFormat formatter =
                                                DateFormat(
                                                    'dd/MM/yyyy');
                                                showDatePicker(
                                                    context: context,
                                                    firstDate:
                                                    getLondonTime(),
                                                    initialDate:
                                                    _dateTime == null
                                                        ? getLondonTime()
                                                        : _dateTime,
                                                    lastDate: getLondonTime()
                                                        .add(Duration(
                                                        days: 365)))
                                                    .then((date) {
                                                  setState(() {
                                                    deliveryDate = formatter
                                                        .format(date);

                                                    getTimes();
                                                  });
                                                });
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Row(
                                                    children: [
                                                      //  Text(deliveryDate == null ? 'Pick a date' : deliveryDate.toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.green)),
                                                      Text(deliveryDate,
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color: Colors
                                                                  .green)),
                                                      Container(
                                                        padding:
                                                        EdgeInsets.only(
                                                            left: 10),
                                                        child: Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          color:
                                                          Colors.green,
                                                          size: 12,
                                                        ),
                                                      )
                                                    ],
                                                  )))
                                        ],
                                      ),
                                    )),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: 15,
                                  right: 15,
                                ),
                                child: Card(
                                    color: Colors.white10,
                                    elevation: 5,
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  "Select Time : ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              DropdownButton<String>(
                                                value: dropdownValue,
                                                icon: Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Colors.green,
                                                ),
                                                iconSize: 24,
                                                elevation: 16,
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    fontSize: 18),
                                                underline: SizedBox(),
                                                onChanged: (String data) {
                                                  setState(() {
                                                    dropdownValue = data;
                                                  });
                                                },
                                                items: spinnerItems.map<
                                                    DropdownMenuItem<
                                                        String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                              ),
                                            ],
                                          ),
                                        ))),
                              ),
                              buildTextField(
                                  screenHeight,
                                  screenWidth,
                                  "Name",
                                  TextInputType.text,
                                  _nameController,
                                  nameFocusNode,
                                  false,
                                  false),
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
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
                                          //       '',
                                          //       textAlign: TextAlign.center,
                                          //       style: TextStyle(
                                          //           color: Colors.white54),
                                          //     )
                                          //         : Text(
                                          //       _dropDownValue,
                                          //       style:
                                          //       TextStyle(color: Colors.white),
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
                                          Expanded(
                                            child: TextField(
                                                onTap: () {
                                                  finalController =
                                                      _phoneController;
                                                  checkInternetConnectionNow();
                                                },
                                                onChanged: (string) {
                                                  checkInternetConnectionNow();
                                                },
                                                showCursor: true,
                                                keyboardType:
                                                TextInputType.number,
                                                controller: _phoneController,
                                                focusNode: phoneFocusNode,
                                                textCapitalization:
                                                TextCapitalization.none,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.white10,
                                                  filled: true,
                                                  labelText: "Phone",
                                                  //hintText: "Phone",
                                                  labelStyle: TextStyle(
                                                      color: Colors.white54),
                                                  contentPadding:
                                                  EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 5,
                                                      bottom: 5),

                                                  focusedBorder:
                                                  InputBorder.none,
                                                  enabledBorder:
                                                  InputBorder.none,
                                                  errorBorder: InputBorder.none,
                                                  disabledBorder:
                                                  InputBorder.none,
                                                ),
                                                style: new TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white)),
                                          )
                                        ],
                                      ))),
                              buildTextField(
                                  screenHeight,
                                  screenWidth,
                                  "Email",
                                  TextInputType.emailAddress,
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
                              // Container(
                              //   width: screenWidth,
                              //   padding: EdgeInsets.only(top: 10),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Container(
                              //           padding:
                              //           EdgeInsets.only(left: 20, right: 5),
                              //           child: SizedBox(
                              //               width: 30.0,
                              //               height: 30.0,
                              //               child: Theme(
                              //                 data: ThemeData(
                              //                   primarySwatch: Colors.blue,
                              //                   unselectedWidgetColor:
                              //                   Colors.white, // Your color
                              //                 ),
                              //                 child: Checkbox(
                              //                     value: _isSubscribe,
                              //                     activeColor:
                              //                     Colors.amber[600],
                              //                     onChanged: (state) =>
                              //                         setState(() {
                              //                           _isSubscribe =
                              //                           !_isSubscribe;
                              //                         })),
                              //               ))),
                              //       Expanded(
                              //           child: Container(
                              //             padding: EdgeInsets.only(right: 20),
                              //             child: GestureDetector(
                              //                 onTap: () {
                              //                   setState(() {
                              //                     _isSubscribe = !_isSubscribe;
                              //                   });
                              //                 },
                              //                 child: Text(
                              //                     loginResponse != null
                              //                         ? getSubscribeNote()
                              //                         : "",
                              //                     style: TextStyle(
                              //                         fontSize: 15,
                              //                         color: Colors.white))),
                              //           ))
                              //     ],
                              //   ),
                              // ),
                               Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    right: 20,
                                    top: 20,
                                    left: 20,
                                    bottom: 20),
                                child: RaisedButton(
                                  onPressed: () {
                                    confirmOrder();
                                  },
                                  color: Colors.amber[600],
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    width:
                                    MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Confirm Order",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                  ),
                                ),
                              )

                            ],
                          ))),
                ],
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
        ));
  }

  // Future<void> getLoginResponse() async {
  //   box = await Hive.openBox(Common.DATABASE);
  //   loginResponse = box.get(Common.LOGINRESPONSE) as LoginResponse;
  //   setState(() {
  //
  //   });
  // }

  buildText(String text, Icon icon, bool link) {
    return Container(
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          icon,
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Text(
                text,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    decoration:
                    link ? TextDecoration.underline : TextDecoration.none),
              ),
            ),
          )
        ],
      ),
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
              autofocus: autoFocus,
              focusNode: focusNode,
              maxLines: null,
              scrollPhysics: ClampingScrollPhysics(),
              textCapitalization: TextCapitalization.none,
              obscureText: obsucure,
              decoration: InputDecoration(
                fillColor: Colors.white10,
                filled: true,
                labelText: hint,
                //hintText: hint,
                labelStyle: TextStyle(color: Colors.white54),
                contentPadding:
                EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),

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

  void getPhoneCode(List<Config> config) {
    for (int i = 0; i < config.length; i++) {
      if (config[i].alias == Common.PHONE_CODE) {
        List list = json.decode(config[i].value);
        for (int i = 0; i < list.length; i++) {
          phoneCodeList.add(PhoneCode.fromJson(list[i]));
          print(phoneCodeList[i].phoneCode);
        }
        _dropDownValuePhone = getUsercountryIndex(phoneCodeList) != -1
            ? phoneCodeList[getUsercountryIndex(phoneCodeList)].countryCode
            : phoneCodeList[0].countryCode;
        setState(() {});
      }
    }
  }

  int getUsercountryIndex(List<PhoneCode> phoneCodeList) {
    for (int i = 0; i < phoneCodeList.length; i++) {
      if (phoneCodeList[i].phoneCode == loginResponse.data.user.phone_code) {
        return i;
      }
    }
    return -1;
  }

  String getSelectedPhoneCode() {
    for (int i = 0; i < phoneCodeList.length; i++) {
      if (_dropDownValuePhone == phoneCodeList[i].countryCode) {
        return phoneCodeList[i].phoneCode;
      }
    }
  }

  Future<void> getLoginResponse() async {
    var box = await Hive.openBox(Common.DATABASE);
    loginResponse = box.get(Common.LOGINRESPONSE);
    //getPhoneCode(loginResponse.data.config);
    getTimes();

    setState(() {
      _nameController.text = loginResponse.data.user != null ? loginResponse.data.user.name : "";
      _phoneController.text = loginResponse.data.user != null ? loginResponse.data.user.mobile: "";
      _emailController.text = loginResponse.data.user != null ? loginResponse.data.user.email:"";
      _addressController.text = loginResponse.data.user != null ? loginResponse.data.user.address: "";
      _postCodeController.text = loginResponse.data.user != null ? loginResponse.data.user.postcode : "";
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToTop();
    });
  }

  getLondonTime() {
    return DateTime.now().timeZoneOffset.inSeconds > 0
        ? DateTime.now().subtract(DateTime.now().timeZoneOffset).add(Duration(hours: getTimeGMT() != null ? getTimeGMT(): 0))
        : DateTime.now().add(DateTime.now().timeZoneOffset).add(Duration(hours: getTimeGMT() != null ? getTimeGMT(): 0));
  }

  int getTimeGMT() {
    if(loginResponse != null){
      for (int i = 0; i < loginResponse.data.config.length; i++) {
        if (loginResponse.data.config[i].alias == Common.GMT_VALUE) {
          return int.parse(loginResponse.data.config[i].value);
        }
      }}
  }

  String getSubscribeNote() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias ==
          Common.SUBSCRIBER_CONFIRMATION_NOTE) {
        return loginResponse.data.config[i].value;
      }
    }
  }

  confirmOrder() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if (_noOfGuestController.text == '') {
      FocusScope.of(context).requestFocus(noOfGuestFocusNode);
      finalController = _noOfGuestController;
      showInSnackBar("Enter No. of Guest(s)");
    } else if (dropdownValueOccasion == 'Select') {
      Fluttertoast.showToast(msg: "Select Occasion");
    } else if (dropdownValue == 'Select') {
      Fluttertoast.showToast(msg: "Select Time");
    } else if (_nameController.text == '') {
      FocusScope.of(context).requestFocus(nameFocusNode);
      finalController = _nameController;
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
      if (token != null) {
        placeOrder();
      } else {
        Fluttertoast.showToast(msg: "Please Sign in First");
        Navigator.of(context)
            .push(
            MaterialPageRoute(builder: (BuildContext context) => SignIn()))
            .then((value) async {
          box = await Hive.openBox(Common.DATABASE);
          loginResponse = box.get(Common.LOGINRESPONSE) as LoginResponse;
          setState(() {
            token = sharedPreferences.getString("token");
          });
        });
      }
    }
  }

  placeOrder() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    ReservationPlaceOrder placeOrder = new ReservationPlaceOrder();
    placeOrder.payment_method = "CASH";
    placeOrder.orderType = "RESERVATION";
    placeOrder.name = _nameController.text;
    placeOrder.mobile = _phoneController.text;
    placeOrder.email = _emailController.text;
    placeOrder.address = _addressController.text;
    placeOrder.postcode = _postCodeController.text;
    placeOrder.time = dropdownValue;
    placeOrder.date = deliveryDate;
    placeOrder.discountId = "1";
    placeOrder.diningTime = dropdownValueOccasion.toUpperCase();
    placeOrder.special_requirement = _specialRequirementController.text;
    placeOrder.order_for = "LATER";
    placeOrder.is_subscribed = _isSubscribe ? "1" : "0";
    placeOrder.guest_qty = _noOfGuestController.text;
    placeOrder.delivery_charge = "0";

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      placeOrder.fingerprint = androidInfo.fingerprint;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      placeOrder.fingerprint = iosInfo.identifierForVendor;
    }

    print(placeOrder.toJson());

    var response = await http.post(Common.BASE_URL + "order",
        body: placeOrder.toJson(), headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      LoginResponse loginResponse =
      LoginResponse.fromJson(json.decode(response.body));

      box = await Hive.openBox(Common.DATABASE);

      final data = box.get(Common.LOGINRESPONSE) as LoginResponse;

      data.data.user = loginResponse.data.user;
      data.data.orders = loginResponse.data.orders;
      data.data.favourites = loginResponse.data.favourites.length != 0
          ? loginResponse.data.favourites
          : data.data.favourites;

      box.put(Common.LOGINRESPONSE, data);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => OrderSuccessPage(
              loginResponse.message, loginResponse.data.orders[0].payment_token)));
    }else if (response.statusCode == 401) {
      sharedPreferences.setString("token", null);
      loginResponse.data.user = new User();
      loginResponse.data.orders = new List<Orders>();
      loginResponse.data.favourites = new List<Products>();
      box = await Hive.openBox(Common.DATABASE);
      box.put(Common.LOGINRESPONSE, loginResponse);
      box.put(Common.CART, new Cart());
      Fluttertoast.showToast(msg: "Please sign in again");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => SignIn()))
          .then((value) {
        setState(() {
          token = sharedPreferences.getString("token");
          getLoginResponse();
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ResponseMessage loginErrorResponse =
      ResponseMessage.fromJson(json.decode(response.body));
      showInSnackBar(loginErrorResponse.message);
    }
    print(response.body);
  }

  Map<String, String> get headers => {
    "Accept": "application/json",
    "Authorization": "Bearer " + sharedPreferences.getString("token")
  };
  void checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      setState(() {
        token = sharedPreferences.getString("token");
      });
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        curve: Curves.linear, duration: Duration(milliseconds: 500));
  }

  getTimes() {
    spinnerItems.clear();
    spinnerItems
        .add("Select");
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.LUNCH_START_AT) {
        getLunchEndTime(loginResponse.data.config[i].value);
      }
      if (loginResponse.data.config[i].alias == Common.DINNER_START_AT) {
        getDinnerEndTime(loginResponse.data.config[i].value);
      }
    }
    setState(() {});
  }

  void getLunchEndTime(String lunchStart) {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.LUNCH_END_AT) {
        var format = DateFormat("HH:mm");
        var one = format.parse(lunchStart);
        var two = format.parse(loginResponse.data.config[i].value);

        for (int j = 0; j < two.difference(one).inMinutes / 15; j++) {
          addTime(lunchStart, j * 15);
        }
      }
    }
  }

  void getDinnerEndTime(String lunchStart) {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.DINNER_END_AT) {
        var format = DateFormat("HH:mm");
        var one = format.parse(lunchStart);
        var two = format.parse(loginResponse.data.config[i].value);

        for (int j = 0; j <= two.difference(one).inMinutes / 15; j++) {
          addTime(lunchStart, j * 15);
        }
      }
    }
  }

  void addTime(String lunchStart, int j) {
    DateFormat format = DateFormat("HH:mm");
    var one = DateFormat("HH:mm").parse(lunchStart).add(Duration(minutes: int.parse(getTimeInMin())));

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(one.add(Duration(minutes: j)).toString());

    DateFormat outFormat = DateFormat("hh:mm a");
    var outputDate = outFormat.format(inputDate);

    if (deliveryDate != DateFormat("dd/MM/yyyy").format(getLondonTime())) {
      if (format
          .parse(DateFormat("HH:mm")
          .format(DateFormat("hh:mm a").parse(outputDate)))
          .difference(format.parse("00:00"))
          .inMinutes >
          int.parse(getTimeInMin())) {
        spinnerItems.add(outputDate);
      }else if(outputDate == "12:00 AM"){
        spinnerItems.add("11:59 PM");
      }
    } else {
      if (format
          .parse(DateFormat("HH:mm")
          .format(DateFormat("hh:mm a").parse(outputDate)))
          .difference(format.parse(format.format(getLondonTime())))
          .inMinutes >
          int.parse(getTimeInMin())) {
        spinnerItems.add(outputDate);
      }else if(outputDate == "12:00 AM"){
        spinnerItems.add("11:59 PM");
      }
    }
  }

  String getTimeInMin() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.RESERVATION_TIME) {
        return loginResponse.data.config[i].value.toString();
      }
    }
  }
}

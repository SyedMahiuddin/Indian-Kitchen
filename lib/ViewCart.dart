import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mustard/auth/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';

import 'OrderSuccessPage.dart';
import 'Paypal.dart';
import 'auth/model/ResponseMessage.dart';
import 'common/Common.dart';
import 'database/Cart.dart';
import 'database/LoginResponse.dart';
import 'database/PlaceOrder.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

class ViewCart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ViewCart();
  }
}

class _ViewCart extends State<ViewCart> {
  bool _isLoading = false;
  bool _isCash = true;
  bool _isPaypal = false;
  bool _isDelivery = false;
  bool _isCollection = true;
  bool _isOrderLater = false;
  bool _isSubscribe = false;
  bool checkBoxValue = false;
  bool _isConfirmPage = false;
  bool _isCoverage = true;
  bool _isFirstOrder = false;

  DateTime _dateTime;
  String deliveryDate;
  String dropdownValue = "Select";
  List<String> spinnerItems = ["Select"];
  List<String> notes = new List();

  SharedPreferences sharedPreferences;
  String token;
  var box;
  Cart cart;
  LoginResponse loginResponse;
  CoverageArea coverageArea;

  TextEditingController finalController,
      _userNameController,
      _addressController,
      _phoneController,
      _emailController,
      _postCodeController,
      _specialReqController,
      _houseController,
      _roadController,
      _townController,
      _cityController;

  FocusNode focusNode,
      userNameeFocusNode,
      addressFocusNode,
      phoneFocusNode,
      emailFocusNode,
      postCodeFocusNode,
      specialReqFocusNode,
      houseFocusNode,
      roadFocusNode,
      townFocusNode,
      cityFocusNode;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isSnackBar = false;

  StreamSubscription<ConnectivityResult> subscription;

  String image_url, id;
  double discountAmount = 0;
  double targetDiscountAmount = 0;
  double getDiscountInPercentage = 0;
  double getDiscountInAmount = 0;
  Discounts discount;
  double deliveryCharge = 0;
  double minDeliveryOrder = 0;
  double minCollectionOrder = 0;

  int day;
  String eighteenPlusCon = "";

  @override
  void initState() {
    checkLoginStatus();

    getCart();

    _userNameController = new TextEditingController();
    _addressController = new TextEditingController();
    _phoneController = new TextEditingController();
    _emailController = new TextEditingController();
    _postCodeController = new TextEditingController();
    _specialReqController = new TextEditingController();
    _houseController = new TextEditingController();
    _roadController = new TextEditingController();
    _townController = new TextEditingController();
    _cityController = new TextEditingController();

    focusNode = FocusNode();
    userNameeFocusNode = FocusNode();
    addressFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    emailFocusNode = FocusNode();
    postCodeFocusNode = FocusNode();
    specialReqFocusNode = FocusNode();
    houseFocusNode = FocusNode();
    roadFocusNode = FocusNode();
    townFocusNode = FocusNode();
    cityFocusNode = FocusNode();

    finalController = _emailController;
    day = getLondonTime().weekday;
    deliveryDate = DateFormat("dd/MM/yyyy").format(getLondonTime());
    super.initState();
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
              if (_isConfirmPage) {
                setState(() {
                  _isLoading = false;
                  _isConfirmPage = false;
                  _isCoverage = true;
                  removeSnackBar();
                });
              } else {
                var box = await Hive.openBox(Common.DATABASE);
                box.put(Common.CART, cart);
                removeSnackBar();
                Navigator.of(context).pop();
              }
              return false;
            },
            child: Stack(
              children: <Widget>[
                Container(
                  height: screenHeight,
                  color: Colors.black87,
                  child: Column(
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).padding.top + 80,
                          color: Colors.amber[600],
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top),
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Your Cart",
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
                                    onPressed: () async {
                                      box = await Hive.openBox(Common.DATABASE);
                                      box.put(Common.CART, cart);
                                      removeSnackBar();
                                      Navigator.of(context).pop();
                                    }),
                              ),
                            ],
                          )),
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          children: [
                            cart != null
                                ? Container(
                                    width: screenWidth,
                                    height:
                                        cart.productCartItem.length * 80.0 + 20,
                                    child: ListView.builder(
                                      padding: EdgeInsets.all(10),
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: cart.productCartItem.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            height: 80,
                                            width: screenWidth,
                                            child: Row(children: <Widget>[
                                              negativeButton(screenHeight,
                                                  screenWidth, index),
                                              // Container(
                                              //     padding: EdgeInsets.all(5),
                                              //     height: 70,
                                              //     width: 70,
                                              //     child: Card(
                                              //         color: Colors.white12,
                                              //         elevation: 5,
                                              //         shape: RoundedRectangleBorder(
                                              //           borderRadius:
                                              //               BorderRadius.circular(50),
                                              //         ),
                                              //         child: ClipRRect(
                                              //           borderRadius:
                                              //               BorderRadius.circular(50),
                                              //           child: Image.network(
                                              //               loginResponse.data
                                              //                       .productPath +
                                              //                   cart
                                              //                       .productCartItem[
                                              //                           index]
                                              //                       .productfeaturedImg,
                                              //               fit: BoxFit.cover),
                                              //         ))),

                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    listViewText(
                                                        cart
                                                            .productCartItem[
                                                                index]
                                                            .productName,
                                                        Alignment.centerLeft),
                                                    listViewText(
                                                        "₤ " +
                                                            '${(double.parse(cart.productCartItem[index].unitPrice) * cart.productCartItem[index].productQuantity).toStringAsFixed(2)}',
                                                        Alignment.centerLeft),
                                                  ],
                                                ),
                                              ),
                                              listViewText(
                                                  'x', Alignment.center),
                                              listViewText(
                                                  cart.productCartItem[index]
                                                      .productQuantity
                                                      .toString(),
                                                  Alignment.center),

                                              positiveButton(screenHeight,
                                                  screenWidth, index),
                                              _deleteButton(screenHeight,
                                                  screenWidth, index),
                                            ]));
                                      },
                                    ))
                                : Container(
                                    height: 0,
                                  ),
                            // targetDiscountAmount > 0 && cart.totalPrice < double.parse(discount.minumumOrderAmount)
                            //     ? Container(
                            //         padding: EdgeInsets.only(
                            //             left: 20, right: 20, top: 5, bottom: 5),
                            //         child: getDiscountInPercentage != 0
                            //             ? Text(
                            //                 "Buy more ₤${targetDiscountAmount.toStringAsFixed(2)} to get " +
                            //                     getDiscountInPercentage
                            //                         .toString() +
                            //                     "% discount",
                            //                 textAlign: TextAlign.center,
                            //                 style: TextStyle(
                            //                     color: Colors.amber[300],
                            //                     fontSize: 16),
                            //               )
                            //             : Text(
                            //                 "Buy more ₤${targetDiscountAmount.toStringAsFixed(2)} to get ₤" +
                            //                     getDiscountInAmount.toString() +
                            //                     " discount",
                            //                 textAlign: TextAlign.center,
                            //                 style: TextStyle(
                            //                     color: Colors.amber[300],
                            //                     fontSize: 16)),
                            //       )
                            //     : Container(
                            //         height: 0,
                            //       ),
                            cart != null
                                ? Container(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Card(
                                        color: Colors.white10,
                                        elevation: 5,
                                        child: Container(
                                          padding: EdgeInsets.all(12),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Text("Total Quantity : ",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  padding: EdgeInsets.only(
                                                      right: 20),
                                                  child: Text(
                                                      cart.totalQuantity
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.green,
                                                      )),
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  )
                                : Container(height: 0),
                            cart != null
                                ? Container(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Card(
                                        color: Colors.white10,
                                        elevation: 5,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            buildPriceItem(
                                                "Sub Total : ",
                                                "₤ " +
                                                    cart.totalPrice
                                                        .toStringAsFixed(2)),
                                            _isDelivery
                                                ? buildPriceItem(
                                                    "Delivery Charge : ",
                                                    "₤ " +
                                                        deliveryCharge
                                                            .toStringAsFixed(2))
                                                : Container(height: 0),
                                            token != null && discountAmount > 0
                                                ? buildPriceItem(
                                                    "Discount : ",
                                                    "- ₤ " +
                                                        discountAmount
                                                            .toStringAsFixed(2))
                                                : Container(
                                                    height: 0,
                                                  ),
                                            token != null && discountAmount > 0
                                                ? Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Icon(
                                                            Icons.info,
                                                            color: Colors
                                                                .amber[600],
                                                            size: 20,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        discount != null?
                                                        Expanded(
                                                            child: Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            discount.short_name,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .amber[400],
                                                                fontSize: 15),
                                                          ),
                                                        )): Container(height: 0)
                                                      ],
                                                    ))
                                                : Container(
                                                    height: 0,
                                                  ),
                                            Divider(color: Colors.white38),
                                            buildPriceItem(
                                                "Grand Total : ",
                                                "₤ " +
                                                    (cart.totalPrice +
                                                            (_isDelivery
                                                                ? deliveryCharge
                                                                : 0) -
                                                            (token != null
                                                                ? double.parse(
                                                                    discountAmount
                                                                        .toStringAsFixed(
                                                                            2))
                                                                : 0))
                                                        .toStringAsFixed(2)),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ],
                                        )),
                                  )
                                : Container(
                                    height: 0,
                                  ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, top: 20, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Payment Method :",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              child: Row(
                                children: [
                                  Container(
                                    width: screenWidth * .4,
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(left: 20),
                                            child: SizedBox(
                                                width: 30.0,
                                                height: 25.0,
                                                child: Theme(
                                                  data: ThemeData(
                                                    primarySwatch: Colors.blue,
                                                    unselectedWidgetColor: Colors
                                                        .white, // Your color
                                                  ),
                                                  child: CircularCheckBox(
                                                      value: _isCash,
                                                      activeColor:
                                                          Colors.amber[600],
                                                      onChanged: (state) =>
                                                          setState(() {
                                                            _isCash = true;
                                                            _isPaypal = false;
                                                          })),
                                                ))),
                                        Container(
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isCash = true;
                                                  _isPaypal = false;
                                                });
                                              },
                                              child: Text("Cash",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white))),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth * .6,
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: SizedBox(
                                              width: 30.0,
                                              height: 30.0,
                                              child: Theme(
                                                data: ThemeData(
                                                  primarySwatch: Colors.blue,
                                                  unselectedWidgetColor: Colors
                                                      .white, // Your color
                                                ),
                                                child: CircularCheckBox(
                                                    value: _isPaypal,
                                                    activeColor:
                                                        Colors.amber[600],
                                                    onChanged: (state) =>
                                                        setState(() {
                                                          _isPaypal = true;
                                                          _isCash = false;
                                                        })),
                                              ),
                                            )),
                                        Expanded(
                                            child: Container(
                                          padding: EdgeInsets.only(right: 20),
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isPaypal = true;
                                                  _isCash = false;
                                                });
                                              },
                                              child: Text(
                                                  "Paypal or Debit/Credit Card",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white))),
                                        ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, top: 20, bottom: 10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Order Type :",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            Container(
                              width: screenWidth,
                              child: Row(
                                children: [
                                  Container(
                                    width: screenWidth * .4,
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(left: 20),
                                            child: SizedBox(
                                              width: 30.0,
                                              height: 25.0,
                                              child: Theme(
                                                data: ThemeData(
                                                  primarySwatch: Colors.blue,
                                                  unselectedWidgetColor: Colors
                                                      .white, // Your color
                                                ),
                                                child: CircularCheckBox(
                                                    value: _isCollection,
                                                    activeColor:
                                                        Colors.amber[600],
                                                    onChanged: (state) =>
                                                        setState(() {
                                                          _isCollection = true;
                                                          _isDelivery = false;

                                                          getTimes();
                                                        })),
                                              ),
                                            )),
                                        Container(
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isCollection = true;
                                                  _isDelivery = false;

                                                  getTimes();
                                                });
                                              },
                                              child: Text("Collection",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white))),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.only(left: 10),
                                            child: SizedBox(
                                                width: 30.0,
                                                height: 30.0,
                                                child: Theme(
                                                  data: ThemeData(
                                                    primarySwatch: Colors.blue,
                                                    unselectedWidgetColor: Colors
                                                        .white, // Your color
                                                  ),
                                                  child: CircularCheckBox(
                                                      value: _isDelivery,
                                                      activeColor:
                                                          Colors.amber[600],
                                                      onChanged: (state) =>
                                                          setState(() {
                                                            _isDelivery = true;
                                                            _isCollection =
                                                                false;

                                                            getTimes();
                                                          })),
                                                ))),
                                        Container(
                                          child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _isDelivery = true;
                                                  _isCollection = false;

                                                  getTimes();
                                                });
                                              },
                                              child: Text("Delivery",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white))),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            loginResponse != null
                                ? _isCollection
                                    ? Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20, top: 20),
                                        child: Text(
                                          "We will serve you within " +
                                              getCollectionTime(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    : Container(
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20, top: 20),
                                        child: Text(
                                            "We will serve you within " +
                                                getDeliveryTime(),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )
                                : Container(
                                    height: 0,
                                  ),
                            // loginResponse != null
                            //     ? Container(
                            //         alignment: Alignment.centerLeft,
                            //         padding: EdgeInsets.only(
                            //             left: 20, right: 20, top: 10),
                            //         child: Text(
                            //             "Free delivery within " +
                            //                 getDistance() +
                            //                 ". Minimum order value of ₤" +
                            //                 getMinimumDeliveryAmmount(),
                            //             style: TextStyle(color: Colors.white)),
                            //       )
                            //     : Container(
                            //         height: 0,
                            //       ),
                            Container(
                              width: screenWidth,
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(left: 15),
                                      child: SizedBox(
                                          width: 30.0,
                                          height: 30.0,
                                          child: Theme(
                                            data: ThemeData(
                                              primarySwatch: Colors.blue,
                                              unselectedWidgetColor:
                                                  Colors.white, // Your color
                                            ),
                                            child: Checkbox(
                                                value: _isOrderLater,
                                                activeColor: Colors.amber[600],
                                                onChanged: (state) =>
                                                    setState(() {
                                                      if (getDiningTime(
                                                              new DateFormat(
                                                                      "HH:mm")
                                                                  .format(
                                                                      getLondonTime())) !=
                                                          "")
                                                        _isOrderLater =
                                                            !_isOrderLater;
                                                    })),
                                          ))),
                                  Container(
                                      child: _isOrderLater
                                          ? GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (getDiningTime(new DateFormat(
                                                              "HH:mm")
                                                          .format(
                                                              getLondonTime())) !=
                                                      "")
                                                    _isOrderLater =
                                                        !_isOrderLater;
                                                });
                                              },
                                              child: Text(
                                                  getDiningTime(new DateFormat(
                                                                  "HH:mm")
                                                              .format(
                                                                  getLondonTime())) ==
                                                          ""
                                                      ? "It is off hour, please book your order"
                                                      : "Order Later",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white)))
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (getDiningTime(new DateFormat(
                                                              "HH:mm")
                                                          .format(
                                                              getLondonTime())) !=
                                                      "")
                                                    _isOrderLater =
                                                        !_isOrderLater;
                                                });
                                              },
                                              child: Text("Order Later",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.white)))),
                                ],
                              ),
                            ),
                            _isOrderLater
                                ? Container(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
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
                                                                    days: int.parse(
                                                                        getMinimumPreOrderTime()))))
                                                        .then((date) {
                                                      setState(() {
                                                        deliveryDate = formatter
                                                            .format(date);
                                                        day = date.weekday;
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
                                  )
                                : Container(
                                    height: 0,
                                  ),
                            _isOrderLater
                                ? Container(
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
                                  )
                                : Container(
                                    height: 0,
                                  ),

                            Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    child: Container(
                                      color: Colors.white10,
                                      child: TextField(
                                          onTap: () {
                                            finalController =
                                                _specialReqController;
                                            checkInternetConnectionNow();
                                          },
                                          onChanged: (string) {
                                            checkInternetConnectionNow();
                                          },
                                          maxLength: _specialReqController
                                                      .text.length >
                                                  0
                                              ? 200
                                              : null,
                                          showCursor: true,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          controller: _specialReqController,
                                          focusNode: focusNode,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          decoration: InputDecoration(
                                            filled: true,
                                            //labelText: hint,
                                            labelText:
                                                "Add Special Requirement (optional)",
                                            labelStyle: TextStyle(
                                                color: Colors.white54),
                                            helperStyle: TextStyle(
                                                color: Colors.white54),
                                            contentPadding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 5,
                                                bottom: 5),
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                          style: new TextStyle(
                                              fontSize: 18,
                                              color: Colors.white)),
                                    ))),
                            eighteenPlusCon != ""
                                ? Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                        bottom: 5,
                                        top: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: Colors.amber[600],
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          eighteenPlusCon,
                                          style: TextStyle(
                                              color: Colors.amber[400]),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ))
                                : Container(
                                    width: 0,
                                  ),
                            notes.length != 0
                                ? Container(
                                    width: screenWidth,
                                    child: ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: notes.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            padding: EdgeInsets.only(
                                                left: 20,
                                                right: 20,
                                                top: 5,
                                                bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  color: Colors.amber[600],
                                                  size: 16,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    notes[index],
                                                    style: TextStyle(
                                                        color:
                                                            Colors.amber[400]),
                                                  ),
                                                )
                                              ],
                                            ));
                                      },
                                    ))
                                : Container(
                                    height: 0,
                                  ),

                            loginResponse != null
                                ? _isCollection &&
                                        double.parse(
                                                getMinimumCollectionAmmount()) >
                                            cart.totalPrice
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 20),
                                        child: Text(
                                          "Minimum order for Collection is ₤ " +
                                              getMinimumCollectionAmmount(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.red),
                                        ),
                                      )
                                    : Container(
                                        height: 0,
                                      )
                                : Container(
                                    height: 0,
                                  ),
                            loginResponse != null
                                ? _isDelivery &&
                                        double.parse(
                                                getMinimumDeliveryAmmount()) >
                                            cart.totalPrice
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 20),
                                        child: Text(
                                          "Minimum order for Delivery is ₤ " +
                                              getMinimumDeliveryAmmount(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.red),
                                        ),
                                      )
                                    : Container(
                                        height: 0,
                                      )
                                : Container(
                                    height: 0,
                                  ),
                            getMinimumCollectionAmmount() != null
                                ? (_isCollection &&
                                            double.parse(
                                                    getMinimumCollectionAmmount()) >
                                                cart.totalPrice) ||
                                        (_isDelivery &&
                                            double.parse(
                                                    getMinimumDeliveryAmmount()) >
                                                cart.totalPrice)
                                    ? Container(
                                        height: 0,
                                      )
                                    : Container(
                                        width: screenWidth,
                                        padding: EdgeInsets.all(20),
                                        child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            onPressed: () async {
                                              if (_isOrderLater &&
                                                  dropdownValue == "Select") {
                                                Fluttertoast.showToast(
                                                    msg: "Select Time");
                                              } else {
                                                if (token != null) {
                                                  var box = await Hive.openBox(
                                                      Common.DATABASE);
                                                  loginResponse = box.get(
                                                      Common.LOGINRESPONSE);
                                                  box.put(Common.CART, cart);

                                                  setState(() {
                                                    _userNameController.text =
                                                        loginResponse
                                                            .data.user.name;
                                                    _phoneController.text =
                                                        loginResponse
                                                            .data.user.mobile;
                                                    _emailController.text =
                                                        loginResponse
                                                            .data.user.email;
                                                    _addressController.text =
                                                        loginResponse
                                                            .data.user.address;
                                                    _postCodeController.text =
                                                        loginResponse
                                                            .data.user.postcode;
                                                    _userNameController
                                                            .selection =
                                                        TextSelection.fromPosition(
                                                            TextPosition(
                                                                offset:
                                                                    _userNameController
                                                                        .text
                                                                        .length));
                                                    _isConfirmPage = true;
                                                    if (loginResponse.data.user
                                                            .address ==
                                                        null) {
                                                      getLocation();
                                                    } else {
                                                      checkCoverageArea();
                                                    }
                                                  });
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Please Sign in First");
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              SignIn()))
                                                      .then((value) async {
                                                    box = await Hive.openBox(
                                                        Common.DATABASE);
                                                    loginResponse = box.get(
                                                            Common
                                                                .LOGINRESPONSE)
                                                        as LoginResponse;
                                                    setState(() {
                                                      token = sharedPreferences
                                                          .getString("token");
                                                      getDiscount();

                                                      _userNameController.text =
                                                          loginResponse
                                                              .data.user.name;
                                                      _phoneController.text =
                                                          loginResponse
                                                              .data.user.mobile;
                                                      _emailController.text =
                                                          loginResponse
                                                              .data.user.email;
                                                      _addressController.text =
                                                          loginResponse.data
                                                              .user.address;
                                                      _postCodeController.text =
                                                          loginResponse.data
                                                              .user.postcode;
                                                      _userNameController
                                                              .selection =
                                                          TextSelection.fromPosition(
                                                              TextPosition(
                                                                  offset: _userNameController
                                                                      .text
                                                                      .length));
                                                      _isConfirmPage = true;
                                                      if (loginResponse.data
                                                              .user.address ==
                                                          null) {
                                                        getLocation();
                                                      } else {
                                                        checkCoverageArea();
                                                      }
                                                    });
                                                  });
                                                }
                                              }
                                            },
                                            color: Colors.amber[600],
                                            child: Container(
                                              padding: EdgeInsets.all(12),
                                              child: Text("Continue",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black87,
                                                  )),
                                            )),
                                      )
                                : Container(
                                    height: 0,
                                  ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                _isConfirmPage && token != null
                    ? Container(
                        height: screenHeight,
                        color: Colors.black,
                        child: Container(
                          color: Colors.white12,
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
                                  height:
                                      80 + MediaQuery.of(context).padding.top,
                                  color: Colors.amber[600],
                                  alignment: Alignment.center,
                                  child: Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Order info",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.black87),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Container(
                                                child: IconButton(
                                                    icon: Icon(
                                                      Icons.arrow_back_ios,
                                                      color: Colors.black87,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _isConfirmPage = false;
                                                        _isCoverage = true;
                                                        removeSnackBar();
                                                      });
                                                    })),
                                            Container(
                                                width: 30,
                                                child: Text(
                                                  "back to cart",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ))
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      cart != null
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  left: 15, right: 15),
                                              child: Card(
                                                  color: Colors.white10,
                                                  elevation: 5,
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      buildPriceItem2(
                                                          "Sub Total : ",
                                                          "₤ " +
                                                              cart.totalPrice
                                                                  .toStringAsFixed(
                                                                      2)),
                                                      _isDelivery
                                                          ? buildPriceItem2(
                                                              "Delivery Charge : ",
                                                              "₤ " +
                                                                  deliveryCharge
                                                                      .toStringAsFixed(
                                                                          2))
                                                          : Container(
                                                              height: 0,
                                                            ),
                                                      token != null &&
                                                              discountAmount > 0
                                                          ? buildPriceItem2(
                                                              "Discount : ",
                                                              "- ₤ " +
                                                                  discountAmount
                                                                      .toStringAsFixed(
                                                                          2))
                                                          : Container(
                                                              height: 0,
                                                            ),
                                                      token != null &&
                                                              discountAmount > 0
                                                          ? Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    child: Icon(
                                                                      Icons
                                                                          .info,
                                                                      color: Colors
                                                                              .amber[
                                                                          600],
                                                                      size: 18,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Expanded(
                                                                      child:
                                                                          Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      discount
                                                                          .short_name,
                                                                      style: TextStyle(
                                                                          color: Colors.amber[
                                                                              400],
                                                                          fontSize:
                                                                              14),
                                                                    ),
                                                                  ))
                                                                ],
                                                              ))
                                                          : Container(
                                                              height: 0,
                                                            ),
                                                      Divider(
                                                          color:
                                                              Colors.white38),
                                                      buildPriceItem2(
                                                          "Grand Total : ",
                                                          "₤ " +
                                                              (cart.totalPrice +
                                                                      (_isDelivery
                                                                          ? deliveryCharge
                                                                          : 0) -
                                                                      (token !=
                                                                              null
                                                                          ? double.parse(discountAmount.toStringAsFixed(
                                                                              2))
                                                                          : 0))
                                                                  .toStringAsFixed(
                                                                      2)),
                                                      SizedBox(
                                                        height: 5,
                                                      )
                                                    ],
                                                  )),
                                            )
                                          : Container(
                                              height: 0,
                                            ),
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
                                      buildAddressTextField(
                                          screenHeight,
                                          screenWidth,
                                          "Delivery Address",
                                          TextInputType.multiline,
                                          _addressController,
                                          addressFocusNode,
                                          false,
                                          false),
                                      !_isCoverage && _isDelivery
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  left: 35,
                                                  right: 35,
                                                  bottom: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Out of Delivery Area",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              _onTapImage(
                                                                  context)); // Call the Dialog.
                                                    },
                                                    child: Text(
                                                      "direct order",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors
                                                              .amber[400]),
                                                    ),
                                                  )
                                                ],
                                              ))
                                          : Container(
                                              height: 0,
                                            ),
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
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.start,
                                      //     crossAxisAlignment:
                                      //         CrossAxisAlignment.start,
                                      //     children: [
                                      //       Container(
                                      //           padding: EdgeInsets.only(
                                      //               left: 20, right: 5),
                                      //           child: SizedBox(
                                      //               width: 30.0,
                                      //               height: 30.0,
                                      //               child: Theme(
                                      //                 data: ThemeData(
                                      //                   primarySwatch:
                                      //                       Colors.blue,
                                      //                   unselectedWidgetColor:
                                      //                       Colors
                                      //                           .white, // Your color
                                      //                 ),
                                      //                 child: Checkbox(
                                      //                     value: _isSubscribe,
                                      //                     activeColor:
                                      //                         Colors.amber[600],
                                      //                     onChanged: (state) =>
                                      //                         setState(() {
                                      //                           _isSubscribe =
                                      //                               !_isSubscribe;
                                      //                         })),
                                      //               ))),
                                      //       Expanded(
                                      //           child: Container(
                                      //         padding:
                                      //             EdgeInsets.only(right: 20),
                                      //         child: GestureDetector(
                                      //             onTap: () {
                                      //               setState(() {
                                      //                 _isSubscribe =
                                      //                     !_isSubscribe;
                                      //               });
                                      //             },
                                      //             child: Text(
                                      //                 getSubscribeNote(),
                                      //                 style: TextStyle(
                                      //                     fontSize: 15,
                                      //                     color:
                                      //                         Colors.white))),
                                      //       ))
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                  ),
                                ),
                              )
                            ],
                          ),
                        ))
                    : Container(
                        height: 0,
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
            )));
  }

  negativeButton(double screenHeight, double screenWidth, int index) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(
          Icons.indeterminate_check_box,
          size: 40,
          color: Colors.amber[600],
        ),
        onPressed: () {
          if (cart.productCartItem[index].productQuantity > 1) {
            cart.productCartItem[index].productQuantity =
                cart.productCartItem[index].productQuantity - 1;
            cart.totalPrice = cart.totalPrice -
                double.parse(cart.productCartItem[index].unitPrice);
            cart.totalQuantity = cart.totalQuantity - 1;
            getDiscount();
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: Container(
                        width: screenWidth * .8,
                        height: screenHeight * .15,
                        alignment: Alignment.center,
                        child: Column(children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            width: screenWidth * .8,
                            height: screenHeight * .08,
                            child: Text(
                              'Remove this Item?',
                              style: TextStyle(fontSize: screenHeight * .03),
                            ),
                          ),
                          Container(
                            height: screenHeight * .07,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                    width: screenWidth * .4,
                                    height: screenHeight * .07,
                                    child: FlatButton(
                                      color: Colors.amber[600],
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontSize: screenHeight * .03,
                                            color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )),
                                Expanded(
                                  child: SizedBox(
                                      height: screenHeight * .07,
                                      child: FlatButton(
                                        color: Colors.green,
                                        child: Text(
                                          'Remove',
                                          style: TextStyle(
                                              fontSize: screenHeight * .03,
                                              color: Colors.white),
                                        ),
                                        onPressed: () {
                                          if (cart.productCartItem[index]
                                                  .productQuantity >
                                              0) {
                                            setState(() {
                                              cart.totalPrice = cart
                                                      .totalPrice -
                                                  double.parse(cart
                                                      .productCartItem[index]
                                                      .unitPrice);
                                              cart.productCartItem
                                                  .removeAt(index);
                                              cart.totalQuantity =
                                                  cart.totalQuantity - 1;
                                              cart.productsId.removeAt(index);
                                            });
                                          }
                                          Navigator.of(context).pop();
                                          if (cart.productCartItem.length ==
                                              0) {
                                            box.put(Common.CART, cart);

                                            Navigator.of(context).pop();
                                          }
                                          setState(() {});
                                          getDiscount();
                                        },
                                      )),
                                ),
                              ],
                            ),
                          )
                        ])),
                  );
                });
          }
          setState(() {});
        },
      ),
    );
  }

  _deleteButton(double screenHeight, double screenWidth, int index) {
    return Container(
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(
          Icons.delete_outline,
          size: 40,
          color: Colors.amber[600],
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: Container(
                      width: screenWidth * .8,
                      height: screenHeight * .15,
                      alignment: Alignment.center,
                      child: Column(children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          width: screenWidth * .8,
                          height: screenHeight * .08,
                          child: Text(
                            'Remove this Item?',
                            style: TextStyle(fontSize: screenHeight * .03),
                          ),
                        ),
                        Container(
                          height: screenHeight * .07,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                  width: screenWidth * .4,
                                  height: screenHeight * .07,
                                  child: FlatButton(
                                    color: Colors.amber[600],
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontSize: screenHeight * .03,
                                          color: Colors.white),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )),
                              Expanded(
                                child: SizedBox(
                                    height: screenHeight * .07,
                                    child: FlatButton(
                                      color: Colors.green,
                                      child: Text(
                                        'Remove',
                                        style: TextStyle(
                                            fontSize: screenHeight * .03,
                                            color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (cart.productCartItem[index]
                                                .productQuantity >
                                            0) {
                                          setState(() {
                                            cart.totalPrice = cart.totalPrice -
                                                double.parse(cart
                                                        .productCartItem[index]
                                                        .unitPrice) *
                                                    cart.productCartItem[index]
                                                        .productQuantity;
                                            cart.totalQuantity =
                                                cart.totalQuantity -
                                                    cart.productCartItem[index]
                                                        .productQuantity;
                                            cart.productsId.removeAt(index);
                                            cart.productCartItem
                                                .removeAt(index);
                                          });
                                        }
                                        Navigator.of(context).pop();
                                        if (cart.productCartItem.length == 0) {
                                          box.put(Common.CART, cart);

                                          Navigator.of(context).pop();
                                        }
                                        getDiscount();
                                        setState(() {});
                                      },
                                    )),
                              ),
                            ],
                          ),
                        )
                      ])),
                );
              });
        },
      ),
    );
  }

  positiveButton(double screenHeight, double screenWidth, int index) {
    return Container(
      alignment: Alignment.center,
      child: IconButton(
        padding: EdgeInsets.only(left: 10),
        icon: Icon(
          Icons.add_box,
          size: 40,
          color: Colors.amber[600],
        ),
        onPressed: () {
          cart.productCartItem[index].productQuantity =
              cart.productCartItem[index].productQuantity + 1;
          cart.totalPrice = cart.totalPrice +
              double.parse(cart.productCartItem[index].unitPrice);
          cart.totalQuantity = cart.totalQuantity + 1;
          getDiscount();
          setState(() {});
        },
      ),
    );
  }

  listViewText(String text, Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.all(2),
      child: Text(text,
          maxLines: 1, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  Future<void> getCart() async {
    box = await Hive.openBox(Common.DATABASE);
    cart = box.get(Common.CART) as Cart;
    loginResponse = box.get(Common.LOGINRESPONSE) as LoginResponse;

    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.ORDER_NOTES) {
        getNotes(loginResponse.data.config[i].value);
      }
    }

    getDiningTime(new DateFormat("HH:mm").format(getLondonTime())) == ""
        ? _isOrderLater = true
        : _isOrderLater = false;

    for (int i = 0; i < cart.productCartItem.length; i++) {
      if (cart.productCartItem[i].is18Plus == 1) get18PlusCon();
    }

    getTimes();
    getDiscount();
    getDeliveryCharge();
    getCoverage();

    setState(() {});
  }

  getCoverage() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.GOOGLE_COORDINATES) {
        coverageArea = CoverageArea.fromJson(
            json.decode(loginResponse.data.config[i].value));
      }
    }
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

  String getCollectionTime() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.COLLECTION_TIME) {
        return loginResponse.data.config[i].value.toString() +
            " " +
            loginResponse.data.config[i].unit.toString();
      }
    }
  }

  String getDeliveryTime() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.DELIVERY_TIME) {
        return loginResponse.data.config[i].value.toString() +
            " " +
            loginResponse.data.config[i].unit.toString();
      }
    }
  }

  String getDistance() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.DISTANCE_COVERED) {
        return loginResponse.data.config[i].value.toString() +
            " " +
            loginResponse.data.config[i].unit.toString();
      }
    }
  }

  String getMaximumDistance() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.DISTANCE_COVERED) {
        return loginResponse.data.config[i].value.toString();
      }
    }
  }

  String getMinimumDeliveryAmmount() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias ==
          Common.MINIMUM_DELIVERY_AMOUNT) {
        return loginResponse.data.config[i].value.toString();
      }
    }
  }

  String getMinimumCollectionAmmount() {
    if (loginResponse != null)
      for (int i = 0; i < loginResponse.data.config.length; i++) {
        if (loginResponse.data.config[i].alias ==
            Common.MINIMUM_COLLECTION_AMOUNT) {
          return loginResponse.data.config[i].value.toString();
        }
      }
  }

  String getMinimumPreOrderTime() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.MAXIMUM_PREORDER_TIME) {
        return loginResponse.data.config[i].value.toString();
      }
    }
  }

  String getDeliveryCharge() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.DELIVERY_CHARGE) {
        deliveryCharge =
            double.parse(loginResponse.data.config[i].value.toString());
      }
    }
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
    var one = DateFormat("HH:mm").parse(lunchStart).add(Duration(
        minutes: (_isDelivery
            ? int.parse(getDeliveryTimeInMin())
            : int.parse(getCollectionTimeInMin()))));

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
          (_isDelivery
              ? int.parse(getDeliveryTimeInMin())
              : int.parse(getCollectionTimeInMin()))) {
        spinnerItems.add(outputDate);
      } else if (outputDate == "12:00 AM") {
        spinnerItems.add("11:59 PM");
      }
    } else {
      if (format
              .parse(DateFormat("HH:mm")
                  .format(DateFormat("hh:mm a").parse(outputDate)))
              .difference(format.parse(format.format(getLondonTime())))
              .inMinutes >
          (_isDelivery
              ? int.parse(getDeliveryTimeInMin())
              : int.parse(getCollectionTimeInMin()))) {
        spinnerItems.add(outputDate);
      } else if (outputDate == "12:00 AM") {
        spinnerItems.add("11:59 PM");
      }
    }
  }

  String getDeliveryTimeInMin() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.DELIVERY_TIME) {
        return loginResponse.data.config[i].value.toString();
      }
    }
  }

  String getCollectionTimeInMin() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.COLLECTION_TIME) {
        return loginResponse.data.config[i].value.toString();
      }
    }
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

  buildAddressTextField(
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
            child: Container(
              color: Colors.white10,
              child: TextField(
                  onTap: () {
                    finalController = controller;
                    // if(controller.text == ""){
                    //   setState(() {
                    //     controller.text = loginResponse.data.user.address;
                    //     controller.selection = TextSelection.fromPosition(
                    //         TextPosition(
                    //             offset:
                    //             controller
                    //                 .text.length));
                    //   });
                    // }
                    checkInternetConnectionNow();
                  },
                  onChanged: (string) {
                    checkInternetConnectionNow();
                    setState(() {
                      _isCoverage = true;
                    });
                  },
                  showCursor: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: controller,
                  focusNode: focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        checkLocation();
                      },
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                    ),
                    filled: true,
                    //labelText: hint,
                    labelText: "Delivery Address (London, UK)",
                    labelStyle: TextStyle(color: Colors.white54),
                    helperStyle: TextStyle(color: Colors.white54),
                    contentPadding:
                        EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  style: new TextStyle(fontSize: 18, color: Colors.white)),
            )));
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

  void checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      setState(() {
        token = sharedPreferences.getString("token");
      });
    }
  }

  confirmOrder() async {
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
      if (coverageArea != null && _isDelivery) {
        getDeliveryDistance();
      } else {
        placeOrder();
      }
    }
  }

  Future<double> getDeliveryDistance() async {
    double distanceInMeters;
    try {
      var addresses = await Geocoder.local
          .findAddressesFromQuery(_addressController.text + " London, UK");
      distanceInMeters = Geolocator.distanceBetween(
          double.parse(coverageArea.latitude),
          double.parse(coverageArea.longitude),
          addresses.first.coordinates.latitude,
          addresses.first.coordinates.longitude);
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
        _isCoverage = false;
      });
    }

    if (distanceInMeters != null) {
      if (distanceInMeters <= double.parse(getMaximumDistance()) * 1609.34) {
        placeOrder();
      } else {
        setState(() {
          _isLoading = false;
          _isCoverage = false;
        });
      }
    }
  }

  placeOrder() async {
    PlaceOrder placeOrder = new PlaceOrder();
    placeOrder.payment_method = _isCash ? "CASH" : "PAYPAL";
    placeOrder.orderType = _isCollection ? "COLLECTION" : "DELIVERY";
    placeOrder.name = _userNameController.text;
    placeOrder.mobile = _phoneController.text;
    placeOrder.email = _emailController.text;
    placeOrder.address = _addressController.text;
    placeOrder.postcode = _postCodeController.text;
    placeOrder.time = dropdownValue == "Select"
        ? new DateFormat("HH:mm:ss").format(getLondonTime())
        : DateFormat("HH:mm:ss")
            .format(DateFormat("hh:mm a").parse(dropdownValue));
    placeOrder.date = deliveryDate != null
        ? deliveryDate
        : new DateFormat("dd/MM/yyyy").format(getLondonTime());
    placeOrder.discountId = discount != null ? discount.id.toString() : "1";
    placeOrder.diningTime = getDiningTime(dropdownValue == "Select"
        ? new DateFormat("HH:mm").format(getLondonTime())
        : DateFormat("HH:mm")
            .format(DateFormat("hh:mm a").parse(dropdownValue)));
    placeOrder.special_requirement = _specialReqController.text;

    List<Detail> detailList = new List();

    for (int i = 0; i < cart.productCartItem.length; i++) {
      Detail detail = new Detail();
      detail.productId = int.parse(cart.productCartItem[i].productId);
      detail.productName = cart.productCartItem[i].productName;
      detail.unitPrice = double.parse(cart.productCartItem[i].unitPrice);
      detail.qty = cart.productCartItem[i].productQuantity;

      detailList.add(detail);
    }

    placeOrder.detail = json.encode(detailList).toString();
    placeOrder.order_for = _isOrderLater ? "LATER" : "NOW";
    placeOrder.is_subscribed = _isSubscribe ? "1" : "0";
    placeOrder.delivery_charge = _isDelivery ? deliveryCharge.toString() : "0";

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

      box = await Hive.openBox(Common.DATABASE);
      box.put(Common.LOGINRESPONSE, data);
      box.put(Common.CART, cart);

      if (_isCash) {
        Cart cart = new Cart();
        box.put(Common.CART, cart);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => OrderSuccessPage(
                loginResponse.message,
                loginResponse.data.orders[0].payment_token)));
      } else {
        Cart cart = new Cart();
        box.put(Common.CART, cart);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => PayPal(loginResponse.message,
                loginResponse.data.orders[0].payment_token)));
      }
    } else if (response.statusCode == 401) {
      sharedPreferences.setString("token", null);
      loginResponse.data.user = new User();
      loginResponse.data.orders = new List<Orders>();
      loginResponse.data.favourites = new List<Products>();
      box = await Hive.openBox(Common.DATABASE);
      discount = null;

      box.put(Common.LOGINRESPONSE, loginResponse);
      box.put(Common.CART, new Cart());
      Fluttertoast.showToast(msg: "Please sign in again");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => SignIn()))
          .then((value) {
        setState(() {
          token = sharedPreferences.getString("token");
          getCart();
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

  getDiscount() {
    if (loginResponse.data.discounts.length != 0) {
      Comparator<Discounts> sortById =
          (a, b) => a.displayOrder.compareTo(b.displayOrder);
      loginResponse.data.discounts.sort(sortById);

      _isFirstOrder = false;
      if (discount != null) {
        if (cart.totalPrice < double.parse(discount.minumumOrderAmount)) {
          discount = null;
          discountAmount = 0;
        }
      }
      for (int i = 0; i < loginResponse.data.discounts.length; i++) {
        checkDiscount(loginResponse.data.discounts[i]);
      }
    }
  }

  checkDiscount(Discounts discounts) {
    if (loginResponse.data.orders.length == 0 && discounts != null) {
      if (discounts.isOnline == 1 &&
              discounts.onDelivery == 1 &&
              discounts.onCollection == 1 &&
              getWeekDay(discounts) == 1 &&
              getDate(discounts) == 1 &&
              _isCash
          ? discounts.on_cash == 1
          : discounts.on_cash == 0) {
        getDiscountAmount(discounts);
      } else if (discounts.isOnline == 1 &&
              _isDelivery &&
              discounts.onDelivery == 1 &&
              getWeekDay(discounts) == 1 &&
              getDate(discounts) == 1 &&
              _isCash
          ? discounts.on_cash == 1
          : discounts.on_cash == 0) {
        getDiscountAmount(discounts);
      } else if (discounts.isOnline == 1 &&
              _isCollection &&
              discounts.onCollection == 1 &&
              getWeekDay(discounts) == 1 &&
              getDate(discounts) == 1 &&
              _isCash
          ? discounts.on_cash == 1
          : discounts.on_cash == 0) {
        getDiscountAmount(discounts);
      }
    } else if (discounts != null) {
      if (discounts.isOnline == 1 &&
              discounts.onDelivery == 1 &&
              discounts.onCollection == 1 &&
              getWeekDay(discounts) == 1 &&
              getDate(discounts) == 1 &&
              discounts.onFirstOrder == 0 &&
              _isCash
          ? discounts.on_cash == 1
          : discounts.on_cash == 0) {
        getDiscountAmount(discounts);
      } else if (discounts.isOnline == 1 &&
              _isDelivery &&
              discounts.onDelivery == 1 &&
              getWeekDay(discounts) == 1 &&
              getDate(discounts) == 1 &&
              discounts.onFirstOrder == 0 &&
              _isCash
          ? discounts.on_cash == 1
          : discounts.on_cash == 0) {
        getDiscountAmount(discounts);
      } else if (discounts.isOnline == 1 &&
              _isCollection &&
              discounts.onCollection == 1 &&
              getWeekDay(discounts) == 1 &&
              getDate(discounts) == 1 &&
              discounts.onFirstOrder == 0 &&
              _isCash
          ? discounts.on_cash == 1
          : discounts.on_cash == 0) {
        getDiscountAmount(discounts);
      }
    }

    setState(() {});
  }

  getWeekDay(Discounts discounts) {
    int value = 0;

    if (day != null) {
      if (day == 1 && discounts.day01 == 1) {
        value = 1;
      } else if (day == 2 && discounts.day02 == 1) {
        value = 1;
      } else if (day == 3 && discounts.day03 == 1) {
        value = 1;
      } else if (day == 4 && discounts.day04 == 1) {
        value = 1;
      } else if (day == 5 && discounts.day05 == 1) {
        value = 1;
      } else if (day == 6 && discounts.day06 == 1) {
        value = 1;
      } else if (day == 7 && discounts.day07 == 1) {
        value = 1;
      } else {
        value = 0;
      }
    }
    return value;
  }

  getDate(Discounts discounts) {
    int value = 0;

    DateFormat format = DateFormat("yyyy-MM-dd");
    var start = format.parse(discounts.startDate);
    var end = format.parse(discounts.endDate);

    var inputFormat = DateFormat('dd/MM/yyyy');
    var inputDate = inputFormat.parse(deliveryDate);

    var date = format.format(inputDate);
    var selectedDate = format.parse(date);

    if (selectedDate.difference(start).inSeconds >= 0 &&
        end.difference(selectedDate).inSeconds > 0) {
      value = 1;
    }
    return value;
  }

  buildPriceItem(String name, String value) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 0, bottom: 5),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              child: Text(value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  )),
            ),
          )
        ],
      ),
    );
  }

  buildPriceItem2(String name, String value) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 0, bottom: 5),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              name,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              child: Text(value,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                  )),
            ),
          )
        ],
      ),
    );
  }

  String getDiningTime(String selectedTime) {
    String value = "";

    DateFormat format = DateFormat("HH:mm");
    var lunchStart, lunchEnd, dinnerStart, dinnerEnd;

    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.LUNCH_START_AT) {
        lunchStart = loginResponse.data.config[i].value;
      } else if (loginResponse.data.config[i].alias == Common.LUNCH_END_AT) {
        lunchEnd = loginResponse.data.config[i].value;
      } else if (loginResponse.data.config[i].alias == Common.DINNER_START_AT) {
        dinnerStart = loginResponse.data.config[i].value;
      } else if (loginResponse.data.config[i].alias == Common.DINNER_END_AT) {
        dinnerEnd = loginResponse.data.config[i].value;
      }
    }

    var lunchStartTime = format.parse(lunchStart);
    var lunchEndTime = format.parse(lunchEnd);
    var dinnerStartTime = format.parse(dinnerStart);
    var dinnerEndTime = format.parse(dinnerEnd);
    var time = format.parse(selectedTime);

    if (time.difference(lunchStartTime).inSeconds >= 0 &&
        lunchEndTime.difference(time).inSeconds > 0) {
      value = "LUNCH";
    } else if (time.difference(dinnerStartTime).inSeconds >= 0 &&
        dinnerEndTime.difference(time).inSeconds > 0) {
      value = "DINNER";
    }
    return value;
  }

  void getDiscountAmount(Discounts discounts) {
    if (discounts != null) {
      if (cart.totalPrice >= double.parse(discounts.minumumOrderAmount)) {
        if (discounts.onFirstOrder == 1) {
          _isFirstOrder = true;
          discount = discounts;
        } else if (!_isFirstOrder) {
          discount = discounts;
        }

        if (discount != null) {
          if (discount.applyBy == "PERCENTAGE") {
            discountAmount =
                double.parse(discount.discountAmount) * cart.totalPrice / 100;
          } else {
            discountAmount = double.parse(discount.discountAmount);
          }
        }
      }
    }
    setState(() {});
  }

  void get18PlusCon() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias ==
          Common.EIGHTEEN_PLUS_CONDITION) {
        eighteenPlusCon = loginResponse.data.config[i].value;
      }
    }
  }

  String getSubscribeNote() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias ==
          Common.SUBSCRIBER_CONFIRMATION_NOTE) {
        return loginResponse.data.config[i].value;
      }
    }
  }

  void getNotes(String value) {
    List list = json.decode(value);
    for (int i = 0; i < list.length; i++) {
      notes.add(list[i]);
    }
  }

  getLondonTime() {
    return DateTime.now().timeZoneOffset.inSeconds > 0
        ? DateTime.now()
            .subtract(DateTime.now().timeZoneOffset)
            .add(Duration(hours: getTimeGMT() != null ? getTimeGMT() : 0))
        : DateTime.now()
            .add(DateTime.now().timeZoneOffset)
            .add(Duration(hours: getTimeGMT() != null ? getTimeGMT() : 0));
  }

  int getTimeGMT() {
    if (loginResponse != null) {
      for (int i = 0; i < loginResponse.data.config.length; i++) {
        if (loginResponse.data.config[i].alias == Common.GMT_VALUE) {
          return int.parse(loginResponse.data.config[i].value);
        }
      }
    }
  }

  Future<void> checkLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    getLastLocation();
    getLocation();
  }

  Future<void> getLastLocation() async {
    Position position = await Geolocator.getLastKnownPosition();
    if (position != null) {
      gotLocation(position.latitude, position.longitude);
    }
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permantly denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    gotLocation(position.latitude, position.longitude);
  }

  Future<void> gotLocation(double latitude, double longitude) async {
    final coordinates = new Coordinates(latitude, longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    _addressController.text = addresses.first.addressLine;
    _addressController.selection = TextSelection.fromPosition(
        TextPosition(offset: _addressController.text.length));
    checkCoverageArea();

    setState(() {});
  }

  Future<void> checkCoverageArea() async {
    double distanceInMeters;
    try {
      var addresses = await Geocoder.local
          .findAddressesFromQuery(_addressController.text + " London, UK");
      distanceInMeters = Geolocator.distanceBetween(
          double.parse(coverageArea.latitude),
          double.parse(coverageArea.longitude),
          addresses.first.coordinates.latitude,
          addresses.first.coordinates.longitude);
    } on Exception catch (e) {
      setState(() {
        _isLoading = false;
        _isCoverage = false;
      });
    }

    if (distanceInMeters != null) {
      if (distanceInMeters > double.parse(getMaximumDistance()) * 1609.34) {
        setState(() {
          _isCoverage = false;
        });
      }
    }
  }

  _onTapImage(BuildContext context) {
    return Container(
        color: Colors.black54,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CachedNetworkImage(
                imageUrl: "https://mustardindian.com/images/" +
                    coverageArea.deliveryDistance), // Show your Image
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                  "We are out of coverage area for your given address, please contact for direct order :",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.amber[400],
                      decoration: TextDecoration.none)),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text("Phone : " + loginResponse.data.contact.phone,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.amber[400],
                      decoration: TextDecoration.none)),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text("Email : " + loginResponse.data.contact.email,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.amber[400],
                      decoration: TextDecoration.none)),
            ),
            Container(
              alignment: Alignment.center,
              child: RaisedButton.icon(
                  color: Colors.white24,
                  textColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Close',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
          ],
        ));
  }
}

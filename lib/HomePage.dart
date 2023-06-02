import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mustard/Gallery.dart';
import 'package:mustard/Reservation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ContactPage.dart';
import 'OrderDetails.dart';
import 'ViewCart.dart';
import 'auth/SignIn.dart';
import 'auth/UpdateProfile.dart';
import 'auth/UserProfile.dart';
import 'auth/Verification.dart';
import 'auth/VerifyEmail.dart';
import 'auth/VerifyPhone.dart';
import 'auth/model/ResponseMessage.dart';
import 'database/Cart.dart';
import 'common/Common.dart';
import 'database/LoginResponse.dart';
import 'package:minimize_app/minimize_app.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePge();
  }
}

class _HomePge extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  var box;
  LoginResponse loginResponse;
  List<Products> productList = new List();
  Cart cart = new Cart();

  ScrollController _scrollController;

  bool _isLoading = true;
  bool _navBar = true;
  bool _category = false;
  bool _isMore = false;
  bool _isFirstOrder = false;

  SharedPreferences sharedPreferences;
  String token;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String currentCategory = "";
  String currentCategoryDetails = "";
  Categories parentCategory;

  Discounts discount;
  String deliveryDate;
  int day;
  String eighteenPlusCon = "";

  static const IconData login = IconData(0xe847, fontFamily: 'MaterialIcons');
  static const IconData logout = IconData(0xe848, fontFamily: 'MaterialIcons');


  @override
  void initState() {
    _scrollController = new ScrollController();
    day = getLondonTime().weekday;
    deliveryDate = DateFormat("MM/dd/yyyy").format(getLondonTime());
    checkLoginStatus();
    getLoginResponse();
    reloadProduct();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        drawer: drawerWidget(screenHeight, screenWidth),
        body: WillPopScope(
            onWillPop: () async {
              if (_scaffoldKey.currentState.isDrawerOpen) {
                Navigator.of(context).pop();
              } else {
                MinimizeApp.minimizeApp();
              }
              return false;
            },
            child: new RefreshIndicator(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: screenHeight,
                      color: Colors.black87,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 80 + MediaQuery.of(context).padding.top,
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top,
                                left: 10),
                            child: Row(
                              children: [
                                Container(
                                    alignment: Alignment.center,
                                    width: 80,
                                    child: GestureDetector(
                                      onTap: () {
                                        _scaffoldKey.currentState.openDrawer();
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.dashboard,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            child: Text(
                                              "menu",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: Container(
                                        child: GestureDetector(
                                  onTap: () {
                                    _category = false;
                                    reloadProduct();
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      child: Image.asset(
                                        "images/logo_home.png",
                                        width: screenWidth,
                                      )),
                                ))),
                                Container(
                                  alignment: Alignment.center,
                                  width: 80,
                                  child: GestureDetector(
                                      onTap: () {
                                        token != null
                                            ? showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    child: Container(
                                                        width: screenWidth * .8,
                                                        height:
                                                            screenHeight * .15,
                                                        alignment:
                                                            Alignment.center,
                                                        child: Column(
                                                            children: <Widget>[
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                width:
                                                                    screenWidth *
                                                                        .8,
                                                                height:
                                                                    screenHeight *
                                                                        .08,
                                                                child: Text(
                                                                  'Want to Log out?',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          screenHeight *
                                                                              .03),
                                                                ),
                                                              ),
                                                              Container(
                                                                height:
                                                                    screenHeight *
                                                                        .07,
                                                                child: Row(
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                        width: screenWidth *
                                                                            .4,
                                                                        height: screenHeight *
                                                                            .07,
                                                                        child:
                                                                            FlatButton(
                                                                          color:
                                                                          Colors.amber[600],
                                                                          child:
                                                                              Text(
                                                                            'No',
                                                                            style:
                                                                                TextStyle(fontSize: screenHeight * .03, color: Colors.white),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                        )),
                                                                    Expanded(
                                                                      child: SizedBox(
                                                                          height: screenHeight * .07,
                                                                          child: FlatButton(
                                                                            color:
                                                                                Colors.green,
                                                                            child:
                                                                                Text(
                                                                              'Yes',
                                                                              style: TextStyle(fontSize: screenHeight * .03, color: Colors.white),
                                                                            ),
                                                                            onPressed:
                                                                                () async {
                                                                              Navigator.of(context).pop();
                                                                              setState(() {
                                                                                token = null;
                                                                              });

                                                                              sharedPreferences = await SharedPreferences.getInstance();
                                                                              var response = await http.post(Common.BASE_URL + "user/logout", headers: headers);

                                                                              if (response.statusCode == 200) {
                                                                                sharedPreferences.setString("token", null);

                                                                                loginResponse.data.user = new User();
                                                                                loginResponse.data.orders = new List<Orders>();
                                                                                loginResponse.data.favourites = new List<Products>();
                                                                                box = await Hive.openBox(Common.DATABASE);
                                                                                discount = null;

                                                                                box.put(Common.LOGINRESPONSE, loginResponse);
                                                                                box.put(Common.CART, new Cart());

                                                                                Fluttertoast.showToast(msg: "Logout Successfully");
                                                                              } else {
                                                                                ResponseMessage responseMessage = ResponseMessage.fromJson(json.decode(response.body));
                                                                                Fluttertoast.showToast(msg: responseMessage.message);
                                                                                Navigator.pop(context);
                                                                              }
                                                                              print(response.body);
                                                                            },
                                                                          )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ])),
                                                  );
                                                })
                                            : Navigator.of(context)
                                                .push(MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        SignIn()))
                                                .then((value) {
                                                setState(() {
                                                  token = sharedPreferences
                                                      .getString("token");
                                                  getLoginResponse();
                                                });
                                              });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                         token == null ? Icon(
                                            login,
                                            color: Colors.white,
                                          ):Icon(
                                            logout,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            child: Text(
                                              token != null
                                                  ? "log out"
                                                  : "login",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ),
                          // loginResponse != null
                          //     ? Container(
                          //         child: Container(
                          //         child: loginResponse
                          //                         .data.user.isMobileVerified ==
                          //                     0 ||
                          //                 loginResponse
                          //                         .data.user.isEmailVerified ==
                          //                     0
                          //             ? Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.center,
                          //                 children: [
                          //                   loginResponse.data.user
                          //                               .isEmailVerified ==
                          //                           0
                          //                       ? Container(
                          //                           width: loginResponse
                          //                                       .data
                          //                                       .user
                          //                                       .isMobileVerified ==
                          //                                   1
                          //                               ? screenWidth
                          //                               : screenWidth * .5,
                          //                           alignment: Alignment.center,
                          //                           padding: EdgeInsets.all(5),
                          //                           child: GestureDetector(
                          //                             onTap: () {
                          //                               Navigator.of(context)
                          //                                   .push(MaterialPageRoute(
                          //                                       builder: (BuildContext
                          //                                               context) =>
                          //                                           VerifyEmail()))
                          //                                   .then((value) {
                          //                                 setState(() {});
                          //                               });
                          //                             },
                          //                             child: Row(
                          //                               mainAxisAlignment:
                          //                                   MainAxisAlignment
                          //                                       .center,
                          //                               children: [
                          //                                 Icon(
                          //                                   Icons.email,
                          //                                   color: Colors.amber,
                          //                                   size: 20,
                          //                                 ),
                          //                                 SizedBox(
                          //                                   width: 5,
                          //                                 ),
                          //                                 Text(
                          //                                   "Verify Email",
                          //                                   style: TextStyle(
                          //                                       fontSize: 14,
                          //                                       color: Colors
                          //                                           .white),
                          //                                 )
                          //                               ],
                          //                             ),
                          //                           ),
                          //                         )
                          //                       : Container(
                          //                           height: 0,
                          //                         ),
                          //                   loginResponse.data.user
                          //                               .isMobileVerified ==
                          //                           0
                          //                       ? Container(
                          //                           width: loginResponse
                          //                                       .data
                          //                                       .user
                          //                                       .isEmailVerified ==
                          //                                   1
                          //                               ? screenWidth
                          //                               : screenWidth * .5,
                          //                           alignment: Alignment.center,
                          //                           padding: EdgeInsets.all(5),
                          //                           child: GestureDetector(
                          //                             onTap: () {
                          //                               Navigator.of(context)
                          //                                   .push(MaterialPageRoute(
                          //                                       builder: (BuildContext
                          //                                               context) =>
                          //                                           VerifyPhone()))
                          //                                   .then((value) {
                          //                                 setState(() {});
                          //                               });
                          //                             },
                          //                             child: Row(
                          //                               mainAxisAlignment:
                          //                                   MainAxisAlignment
                          //                                       .center,
                          //                               children: [
                          //                                 Icon(
                          //                                   Icons.phone,
                          //                                   color: Colors.amber,
                          //                                   size: 20,
                          //                                 ),
                          //                                 SizedBox(
                          //                                   width: 5,
                          //                                 ),
                          //                                 Text(
                          //                                   "Verify Phone",
                          //                                   style: TextStyle(
                          //                                       fontSize: 14,
                          //                                       color: Colors
                          //                                           .white),
                          //                                 )
                          //                               ],
                          //                             ),
                          //                           ))
                          //                       : Container(
                          //                           height: 0,
                          //                         ),
                          //                 ],
                          //               )
                          //             : Container(
                          //                 height: 0,
                          //               ),
                          //       ))
                          //     : Container(
                          //         height: 0,
                          //       ),
                          token != null
                              ? discount != null && currentCategory == ""
                                  ? Container(
                                      padding: EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 5,
                                          bottom: 5),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Icon(
                                              Icons.info,
                                              color: Colors.amber[600],
                                              size: 20,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    discount.name,
                                                    style: TextStyle(
                                                        color:
                                                        Colors.amber[400],
                                                        fontSize: 15),
                                                  )))
                                        ],
                                      ))
                                  : Container(
                                      height: 0,
                                    )
                              : Container(
                                  height: 0,
                                ),
                          currentCategory != ""
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          currentCategory = "";
                                          getProductList();
                                          setState(() {
                                            if (_scrollController
                                                .positions.isNotEmpty)
                                              _scrollController.animateTo(0,
                                                  curve: Curves.linear,
                                                  duration: Duration(
                                                      milliseconds: 500));
                                            _isMore = false;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 10,
                                              right: 10,
                                              top: 5,
                                              bottom: 5),
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.amber[600],
                                          ),
                                        ),
                                      ),
                                      parentCategory != null
                                          ? GestureDetector(
                                              onTap: () {
                                                _category = true;
                                                getCategoryProduct(
                                                    parentCategory, null);
                                                setState(() {
                                                  if (_scrollController
                                                      .positions.isNotEmpty)
                                                    _scrollController.animateTo(
                                                        0,
                                                        curve: Curves.linear,
                                                        duration: Duration(
                                                            milliseconds: 500));
                                                });
                                              },
                                              child: Text(
                                                parentCategory.name,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: 0,
                                            ),
                                      parentCategory != null
                                          ? Text(
                                              " > ",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            )
                                          : Container(
                                              height: 0,
                                            ),
                                      Expanded(
                                        child: Text(
                                          currentCategory,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      )
                                    ],
                                  ))
                              : Container(
                                  height: 0,
                                ),
                          currentCategory != "" && currentCategoryDetails != ""
                              ? Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  child: Text(
                                    currentCategoryDetails,
                                    style: TextStyle(
                                        color: Colors.amber[400], fontSize: 16),
                                  ),
                                )
                              : Container(
                                  height: 0,
                                ),
                          productList.length != 0
                              ? Expanded(
                                  child: Container(
                                  child: ListView.builder(
                                      padding: EdgeInsets.only(
                                          bottom: _isMore ? 65 : 15),
                                      shrinkWrap: true,
                                      controller: _scrollController,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: productList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                            margin: EdgeInsets.only(
                                                left: 10, right: 10, top: 10),
                                            child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(15)),
                                                child: Container(
                                                    color: Colors.white10,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            Container(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerLeft,
                                                                      child: buildText(
                                                                          productList[index]
                                                                              .name,
                                                                          18,
                                                                          null,
                                                                          Colors
                                                                              .white),
                                                                    )),
                                                                    Container(
                                                                      child: buildText(
                                                                          "₤ " +
                                                                              productList[index].rateOnline,
                                                                          18,
                                                                          null,
                                                                          Colors.white),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        top: 0,
                                                                        bottom:
                                                                            5),
                                                                height: 1,
                                                                child: Divider(
                                                                  color: Colors
                                                                      .white24,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        productList[index]
                                                                    .details !=
                                                                null
                                                            ? Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        top: 0,
                                                                        bottom:
                                                                            5),
                                                                child: Text(
                                                                  productList[
                                                                          index]
                                                                      .details,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              )
                                                            : Container(
                                                                width: 0,
                                                              ),
                                                        productList[index]
                                                                    .is18plus ==
                                                                1
                                                            ? Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            5),
                                                                child: Text(
                                                                  eighteenPlusCon,
                                                                  style: TextStyle(
                                                                      color: Colors.amber[400],
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              )
                                                            : Container(
                                                                width: 0,
                                                              ),
                                                        productList[index]
                                                                        .details ==
                                                                    null &&
                                                                productList[index]
                                                                        .is18plus ==
                                                                    0
                                                            ? Container(
                                                                height: 0,
                                                              )
                                                            : Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                height: 1,
                                                                child: Divider(
                                                                  color: Colors
                                                                      .white24,
                                                                ),
                                                              ),
                                                        Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 5,
                                                                    top: 0),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Row(
                                                              children: [
                                                                cart.productsId.contains(
                                                                        productList[index]
                                                                            .id
                                                                            .toString())
                                                                    ? Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          _deleteButton(
                                                                              screenHeight,
                                                                              screenWidth,
                                                                              cart.productsId.indexOf(productList[index].id.toString())),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          negativeButton(
                                                                              screenHeight,
                                                                              screenWidth,
                                                                              cart.productsId.indexOf(productList[index].id.toString())),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          cart.productsId.contains(productList[index].id.toString())
                                                                              ? Container(
                                                                                  alignment: Alignment.center,
                                                                                  padding: EdgeInsets.all(10),
                                                                                  decoration: BoxDecoration(color: Colors.amber[600], shape: BoxShape.circle),
                                                                                  child: Text(
                                                                                    cart.productCartItem[cart.productsId.indexOf(productList[index].id.toString())].productQuantity.toString(),
                                                                                    style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                                                                                  ))
                                                                              : Container(
                                                                                  height: 0,
                                                                                ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          positiveButton(
                                                                              screenHeight,
                                                                              screenWidth,
                                                                              cart.productsId.indexOf(productList[index].id.toString())),
                                                                        ],
                                                                      )
                                                                    : Container(
                                                                        height:
                                                                            0,
                                                                      ),
                                                                Expanded(
                                                                    child:
                                                                        Container()),
                                                                Container(
                                                                  height: 40,
                                                                  width: 35,
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          right:
                                                                              10),
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.amber[600],
                                                                      shape: BoxShape
                                                                          .circle),
                                                                  child:
                                                                      IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      addToCart(
                                                                          productList[
                                                                              index]);
                                                                    },
                                                                    icon: Icon(
                                                                      Icons
                                                                          .shopping_cart,
                                                                      color: Colors
                                                                          .black87,
                                                                      size: 20,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                      ],
                                                    ))));
                                      }),
                                ))
                              : Expanded(
                                  child: Center(
                                      child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      currentCategory + " Item Not Found",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.amber[600]),
                                    ),
                                  )),
                                ),
                          Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Stack(
                                children: [
                                  cart.productCartItem.length != 0
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20)),
                                          child: Container(
                                              height: 60,
                                              color: Colors.amber[600],
                                              child: Row(
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 15,
                                                                  right: 10),
                                                          alignment:
                                                              Alignment.center,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                _navBar =
                                                                    !_navBar;
                                                                _isMore = false;
                                                              });
                                                            },
                                                            child: Icon(
                                                                _navBar
                                                                    ? Icons
                                                                        .keyboard_arrow_down
                                                                    : Icons
                                                                        .keyboard_arrow_up,
                                                                color: Colors
                                                                    .black87),
                                                          )),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 5),
                                                        child: Icon(
                                                            Icons.shopping_cart,
                                                            size: 20,
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                      Container(
                                                        child: Text(
                                                            cart.totalQuantity !=
                                                                    0
                                                                ? cart
                                                                    .totalQuantity
                                                                    .toString()
                                                                : "0",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .black87)),
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: !_isMore
                                                        ? Container(
                                                            alignment: Alignment
                                                                .center,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5,
                                                                    right: 5),
                                                            child: RaisedButton(
                                                              padding: EdgeInsets.all(0),
                                                              onPressed:
                                                                  () async {
                                                                var box = await Hive
                                                                    .openBox(Common
                                                                        .DATABASE);

                                                                box.put(
                                                                    Common.CART,
                                                                    cart);

                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder:
                                                                            (BuildContext context) =>
                                                                                ViewCart()))
                                                                    .then(
                                                                        (value) {
                                                                  setState(() {
                                                                    token = sharedPreferences
                                                                        .getString(
                                                                            "token");
                                                                    getLoginResponse();
                                                                  });
                                                                });
                                                              },
                                                              child: Text(
                                                                  "View Cart",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black87)),
                                                              color: Colors.amber[600],
                                                            ),
                                                          )
                                                        : Container(
                                                            height: 0,
                                                          ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 20),
                                                        child: Text(
                                                          cart.totalPrice != 0
                                                              ? "Total: " +
                                                                  "₤ " +
                                                                  cart.totalPrice
                                                                      .toStringAsFixed(
                                                                          2)
                                                              : "₤ 0",
                                                          style: TextStyle(
                                                              fontSize:  16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black87),
                                                        ),
                                                      ),
                                                      _isMore
                                                          ? Container(
                                                              height: 25,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5,
                                                                      right:
                                                                          20),
                                                              child:
                                                                  RaisedButton(
                                                                    padding: EdgeInsets.all(0),
                                                                onPressed:
                                                                    () async {
                                                                  var box = await Hive
                                                                      .openBox(
                                                                          Common
                                                                              .DATABASE);

                                                                  box.put(
                                                                      Common
                                                                          .CART,
                                                                      cart);

                                                                  Navigator.of(
                                                                      context)
                                                                      .push(MaterialPageRoute(
                                                                      builder:
                                                                          (BuildContext context) =>
                                                                          ViewCart()))
                                                                      .then(
                                                                          (value) {
                                                                        setState(() {
                                                                          token = sharedPreferences
                                                                              .getString(
                                                                              "token");
                                                                          getLoginResponse();
                                                                        });
                                                                      });
                                                                },
                                                                child: Text(
                                                                    "View Cart",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: Colors
                                                                            .black87)),
                                                                color: Colors.amber[600],
                                                              ),
                                                            )
                                                          : Container(
                                                              height: 0,
                                                            ),
                                                    ],
                                                  )
                                                ],
                                              )))
                                      : Container(
                                          height: 0,
                                        ),
                                ],
                              ),
                              _navBar || cart.productCartItem.length == 0
                                  ? Container(
                                      color: Colors.black,
                                      child: Container(
                                          color:
                                              cart.productCartItem.length == 0
                                                  ? Colors.white10
                                                  : Colors.amber[600],
                                          height: 60,
                                          padding: EdgeInsets.only(
                                              top: 5, bottom: 10),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: token != null
                                                    ? screenWidth * .19
                                                    : screenWidth * .25,
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isMore = false;
                                                      });
                                                      reloadProduct();
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.home,
                                                          color:
                                                          cart.productCartItem.length != 0 ? Colors.black87:
                                                          Colors.amber[600],
                                                          size: 24,
                                                        ),
                                                        Text(
                                                          "Home",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                              cart.productCartItem.length != 0 ? Colors.black87:
                                                              Colors.white),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              token != null
                                                  ? Container(
                                                      width: screenWidth * .19,
                                                      alignment:
                                                          Alignment.center,
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              _isMore =
                                                                  !_isMore;
                                                            });
                                                          },
                                                          child: Column(
                                                            children: [
                                                              Icon(
                                                                Icons.person,
                                                                color: cart.productCartItem.length != 0 ? Colors.black87:
                                                                Colors.amber[600],
                                                                size: 24,
                                                              ),
                                                              Text(
                                                                "Account",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: cart.productCartItem.length != 0 ? Colors.black87:
                                                                    Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          )),
                                                    )
                                                  : Container(
                                                      height: 0,
                                                    ),
                                              Container(
                                                width: token != null
                                                    ? screenWidth * .24
                                                    : screenWidth * .25,
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      //reloadProduct();
                                                      Navigator.of(
                                                          context)
                                                          .push(MaterialPageRoute(
                                                          builder:
                                                              (BuildContext context) =>
                                                              Reservation()))
                                                          .then(
                                                              (value) {
                                                            setState(() {
                                                              _isMore = false;
                                                              token = sharedPreferences
                                                                  .getString(
                                                                  "token");
                                                              getLoginResponse();
                                                            });
                                                          });
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.book,
                                                          color:
                                                          cart.productCartItem.length != 0 ? Colors.black87:
                                                          Colors.amber[600],
                                                          size: 24,
                                                        ),
                                                        Text(
                                                          "Reservation",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                              cart.productCartItem.length != 0 ? Colors.black87:
                                                              Colors.white),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              Container(
                                                width: token != null
                                                    ? screenWidth * .19
                                                    : screenWidth * .25,
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isMore = false;
                                                      });

                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  GalleryPage()));
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.image,
                                                          color:
                                                          cart.productCartItem.length != 0 ? Colors.black87:
                                                          Colors.amber[600],
                                                          size: 24,
                                                        ),
                                                        Text(
                                                          "Gallery",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                              cart.productCartItem.length != 0 ? Colors.black87:
                                                              Colors.white),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              Container(
                                                width: token != null
                                                    ? screenWidth * .19
                                                    : screenWidth * .25,
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isMore = false;
                                                      });
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  ContactPage()));
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Icon(
                                                          Icons.contact_page,
                                                          color:
                                                          cart.productCartItem.length != 0 ? Colors.black87:
                                                          Colors.amber[600],
                                                          size: 24,
                                                        ),
                                                        Text(
                                                          "Contact",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                              cart.productCartItem.length != 0 ? Colors.black87:
                                                              Colors.white),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                            ],
                                          )),
                                    )
                                  : Container(
                                      height: 0,
                                    )
                            ],
                          )),
                        ],
                      ),
                    ),
                    _isMore
                        ? Container(
                            padding: EdgeInsets.only(bottom: 60),
                            alignment: Alignment.bottomLeft,
                            child: Container(
                                width: screenWidth * .57 + 30,
                                height: 50,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    child: Container(
                                        color: cart.productCartItem.length == 0
                                            ? Colors.black87
                                            : null,
                                        alignment: Alignment.centerRight,
                                        child: Container(
                                          alignment: Alignment.center,
                                          color:
                                              cart.productCartItem.length == 0
                                                  ? Colors.white12
                                                  : Colors.amber,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: screenWidth * .19,
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isMore = false;
                                                      });
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  UserProfile()));
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.person,
                                                          color: cart.productCartItem.length != 0 ? Colors.black87:
                                                          Colors.amber[600],
                                                          size: 24,
                                                        ),
                                                        Text(
                                                          "Profile",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                              cart.productCartItem.length != 0 ? Colors.black87:
                                                              Colors.white,),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              Container(
                                                width: screenWidth * .19,
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isMore = false;
                                                      });
                                                      getCategoryFavouriteProduct(
                                                          loginResponse
                                                              .data.favourites);
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.auto_awesome,
                                                          color:
                                                          cart.productCartItem.length != 0 ? Colors.black87:
                                                          Colors.amber[600],
                                                          size: 24,
                                                        ),
                                                        Text(
                                                          "Favourites",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                              cart.productCartItem.length != 0 ? Colors.black87:
                                                              Colors.white,),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              Container(
                                                width: screenWidth * .19,
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isMore = false;
                                                      });
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  OrderDetails()));
                                                    },
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.history,
                                                          color:
                                                          cart.productCartItem.length != 0 ? Colors.black87:
                                                          Colors.amber[600],
                                                          size: 24,
                                                        ),
                                                        Text(
                                                          "Orders",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                              cart.productCartItem.length != 0 ? Colors.black87:
                                                              Colors.white,),
                                                        ),
                                                      ],
                                                    )),
                                              ),
                                              Container(
                                                  width: 25,
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        _isMore = false;
                                                      });
                                                    },
                                                    child: Icon(
                                                        _isMore
                                                            ? Icons
                                                                .keyboard_arrow_down
                                                            : Icons
                                                                .keyboard_arrow_up,
                                                        color: cart.productCartItem.length != 0 ? Colors.black87:
                                                        Colors.white,),
                                                  )),
                                            ],
                                          ),
                                        )))))
                        : Container(
                            height: 0,
                          ),
                    _isLoading
                        ? Container(
                            height: screenHeight,
                            width: screenWidth,
                            color: Colors.black,
                            child: Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).padding.top),
                              height: screenHeight,
                              width: screenWidth,
                              color: Colors.white12,
                              child: Image.asset("images/logo.png"),
                            ))
                        : Container(
                            height: 0,
                          ),
                  ],
                ),
                onRefresh: reloadProduct)));
  }

  drawerWidget(double screenHeight, double screenWidth) {
    return Container(
      color: Colors.black87,
      width: screenWidth * .80,
      child: Drawer(
          child: Container(
        color: Colors.black87,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 20,
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    Icon(Icons.category, color:Colors.amber[600]),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Menu",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              token != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 1,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            color: Colors.white54,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              _category = true;
                              getCategoryFavouriteProduct(
                                  loginResponse.data.favourites);
                              Navigator.of(context).pop();
                              setState(() {
                                if (_scrollController.positions.isNotEmpty)
                                  _scrollController.animateTo(0,
                                      curve: Curves.linear,
                                      duration: Duration(milliseconds: 500));
                              });
                            },
                            child: Text(
                              "FAVOURITES",
                              style: new TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber[500]),
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Divider(
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    )
                  : Container(
                      height: 0,
                    ),
              loginResponse != null
                  ? Container(
                      child: new ListView.builder(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: loginResponse.data.categories.length,
                        itemBuilder: (context, i) {
                          return loginResponse
                                      .data.categories[i].categories.length !=
                                  0
                              ? ExpansionTile(
                                  initiallyExpanded: isFocusedChiled(
                                          loginResponse
                                              .data.categories[i].categories)
                                      ? true
                                      : false,
                                  tilePadding: EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  title: new Text(
                                    loginResponse.data.categories[i].name,
                                    style: new TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70),
                                  ),
                                  children: <Widget>[
                                    new Column(
                                      children: _buildExpandableContent(
                                        loginResponse.data.categories[i],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 1,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Divider(
                                          color: Colors.white54,
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(
                                            left: 20,
                                            right: 20,
                                            top: 10,
                                            bottom: 10),
                                        child: GestureDetector(
                                          onTap: () {
                                            _category = true;
                                            getCategoryProduct(
                                                loginResponse
                                                    .data.categories[i],
                                                null);
                                            Navigator.of(context).pop();
                                            setState(() {
                                              if (_scrollController
                                                  .positions.isNotEmpty)
                                                _scrollController.animateTo(0,
                                                    curve: Curves.linear,
                                                    duration: Duration(
                                                        milliseconds: 500));
                                            });
                                          },
                                          child: Text(
                                            loginResponse
                                                .data.categories[i].name,
                                            style: new TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: loginResponse
                                                            .data
                                                            .categories[i]
                                                            .name ==
                                                        currentCategory
                                                    ? Colors.white
                                                    : Colors.white70),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 1,
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: Divider(
                                          color: Colors.white54,
                                        ),
                                      ),
                                    ],
                                  ));
                        },
                      ),
                    )
                  : Container(
                      height: 0,
                    ),
            ],
          ),
        ),
      )),
    );
  }

  _buildExpandableContent(Categories category) {
    List<Widget> columnContent = [];

    columnContent.add(
      new Container(
        child: new ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          itemCount: category.categories.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, i2) {
            return category.categories[i2].categories.length != 0
                ? ExpansionTile(
                    maintainState: true,
                    title: new Text(
                      category.categories[i2].name,
                      style: new TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                    ),
                    children: <Widget>[
                      new Column(
                        children:
                            _buildExpandableContent2(category.categories[i2]),
                      ),
                    ],
                  )
                : Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 1,
                          padding: EdgeInsets.only(left: 30, right: 20),
                          child: Divider(
                            color: Colors.white54,
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(
                                left: 30, right: 20, top: 10, bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                _category = true;
                                getCategoryProduct(
                                    category.categories[i2], category);
                                Navigator.of(context).pop();
                                setState(() {
                                  if (_scrollController.positions.isNotEmpty)
                                    _scrollController.animateTo(0,
                                        curve: Curves.linear,
                                        duration: Duration(milliseconds: 500));
                                });
                              },
                              child: Text(
                                category.categories[i2].name,
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: category.categories[i2].name ==
                                            currentCategory
                                        ? Colors.white
                                        : Colors.white70),
                              ),
                            )),
                      ],
                    ));
          },
        ),
      ),
    );

    return columnContent;
  }

  _buildExpandableContent2(Categories category) {
    List<Widget> columnContent = [];

    for (int i = 0; i < category.categories.length; i++)
      columnContent.add(
        new ListTile(
          onTap: () {
            _category = true;
            getCategoryProduct(category.categories[i], category);
            Navigator.of(context).pop();
            setState(() {
              if (_scrollController.positions.isNotEmpty)
                _scrollController.animateTo(0,
                    curve: Curves.linear,
                    duration: Duration(milliseconds: 500));
            });
          },
          title: new Text(
            category.categories[i].name,
            style: new TextStyle(fontSize: 14.0, color: Colors.white70),
          ),
          leading: new Icon(Icons.category),
        ),
      );

    return columnContent;
  }

  buildText(String name, double fontSize, Color color, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
      ),
      padding: EdgeInsets.only(left: 5, right: 0),
      margin: EdgeInsets.only(right: 5, top: 2.5, bottom: 2.5),
      child: Text(
        name,
        style: TextStyle(
          fontSize: fontSize,
          color: textColor,
        ),
      ),
    );
  }

  negativeButton(double screenHeight, double screenWidth, int index) {
    return Container(
      height: 40,
      width: 40,
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
                                      color:Colors.amber[600],
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
                                          setState(() {
                                            _navBar = false;
                                            _isMore = false;
                                          });
                                          Navigator.of(context).pop();
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
      height: 40,
      width: 40,
      alignment: Alignment.center,
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
                                        setState(() {
                                          _navBar = false;
                                          _isMore = false;
                                        });
                                        Navigator.of(context).pop();
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
        },
      ),
    );
  }

  positiveButton(double screenHeight, double screenWidth, int index) {
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      child: IconButton(
        padding: EdgeInsets.all(0),
        icon: Icon(
          Icons.add_box,
          size: 40,
          color:Colors.amber[600],
        ),
        onPressed: () {
          cart.productCartItem[index].productQuantity =
              cart.productCartItem[index].productQuantity + 1;
          cart.totalPrice = cart.totalPrice +
              double.parse(cart.productCartItem[index].unitPrice);
          cart.totalQuantity = cart.totalQuantity + 1;
          getDiscount();
          setState(() {
          });
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

  Future<void> getLoginResponse() async {
    sharedPreferences = await SharedPreferences.getInstance();
    box = await Hive.openBox(Common.DATABASE);
    loginResponse = box.get(Common.LOGINRESPONSE) as LoginResponse;
    if (Common.ISLOGED) {
      cart = box.get(Common.CART) as Cart;
    } else {
      Cart cart = new Cart();
      box.put(Common.CART, cart);
      Common.ISLOGED = true;
    }
    //box.close();
    if (loginResponse != null) {
      getConfig();
      if (!_category) getProductList();
      getDiscount();
      setState(() {
        _isLoading = false;
      });
    }
  }

  getProductList() {
    currentCategory = "";
    productList.clear();
    for (int i = 0; i < loginResponse.data.productList.length; i++) {
      productList.add(loginResponse.data.productList[i]);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void addToCart(Products product) {
    if (cart.productsId.contains(product.id.toString())) {
      setState(() {
        cart.productCartItem[cart.productsId.indexOf(product.id.toString())]
            .productQuantity = cart
                .productCartItem[cart.productsId.indexOf(product.id.toString())]
                .productQuantity +
            1;
        cart.totalQuantity++;
        cart.totalPrice = cart.totalPrice + double.parse(product.rateOnline);
        _navBar = false;
        _isMore = false;
      });
    } else {
      ProductCartItem productCart = new ProductCartItem();
      productCart.productId = product.id.toString();
      productCart.productName = product.name;
      productCart.unitPrice = product.rateOnline;
      productCart.productQuantity = 1;
      productCart.is18Plus = product.is18plus == 1 ? 1 : 0;

      setState(() {
        cart.productCartItem.add(productCart);
        cart.productsId.add(product.id.toString());
        cart.totalQuantity++;
        cart.totalPrice = cart.totalPrice + double.parse(product.rateOnline);
        _navBar = false;
        _isMore = false;
      });
    }
  }

  Future<void> reloadProduct() async {
    //currentCategory = "";
    sharedPreferences = await SharedPreferences.getInstance();

    String info = "";
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      info = androidInfo.fingerprint;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      info = iosInfo.identifierForVendor;
    }

    var response;

    if (token != null) {
      response = await http.get(Common.BASE_URL + "sync?finger_print=" + info,
          headers: headers);
    } else {
      response = await http.get(Common.BASE_URL + "sync");
    }

    print(response.body);

    if (response.statusCode == 200) {
      LoginResponse reloadLoginResponse = new LoginResponse();

      reloadLoginResponse = LoginResponse.fromJson(json.decode(response.body));

      if (loginResponse != null) {
        loginResponse.data.orders = reloadLoginResponse.data.orders;
        discount = null;

        if(reloadLoginResponse.data.contact != null){
          loginResponse.data.contact = reloadLoginResponse.data.contact;
        }
        if(reloadLoginResponse.data.payment_link != null){
          loginResponse.data.payment_link = reloadLoginResponse.data.payment_link;
        }

        if (reloadLoginResponse.data.categories.length != 0 ||
            reloadLoginResponse.data.discounts.length != 0 ||
            reloadLoginResponse.data.favourites.length != 0 ||
            reloadLoginResponse.data.config.length != 0 ||
            reloadLoginResponse.data.productList.length != 0) {
          loginResponse.data.categories =
              reloadLoginResponse.data.categories.length != 0
                  ? reloadLoginResponse.data.categories
                  : loginResponse.data.categories;
          loginResponse.data.discounts =
              reloadLoginResponse.data.discounts.length != 0
                  ? reloadLoginResponse.data.discounts
                  : loginResponse.data.discounts;

          loginResponse.data.favourites =
              reloadLoginResponse.data.favourites.length != 0
                  ? reloadLoginResponse.data.favourites
                  : loginResponse.data.favourites;
          loginResponse.data.config =
              reloadLoginResponse.data.config.length != 0
                  ? reloadLoginResponse.data.config
                  : loginResponse.data.config;

          loginResponse.data.productList =
              reloadLoginResponse.data.productList.length != 0
                  ? reloadLoginResponse.data.productList
                  : loginResponse.data.productList;
        }
        var box = await Hive.openBox(Common.DATABASE);
        box.put(Common.LOGINRESPONSE, loginResponse);
        getLoginResponse();
      } else {
        loginResponse = reloadLoginResponse;
        var box = await Hive.openBox(Common.DATABASE);
        box.put(Common.LOGINRESPONSE, loginResponse);
        getLoginResponse();
      }
    }else if (response.statusCode == 401) {
      sharedPreferences.setString("token", null);
      loginResponse.data.user = new User();
      loginResponse.data.orders = new List<Orders>();
      loginResponse.data.favourites = new List<Products>();
      box = await Hive.openBox(Common.DATABASE);
      discount = null;
      box.put(Common.LOGINRESPONSE, loginResponse);
      box.put(Common.CART, new Cart());

      setState(() {
        token = null;
        _isLoading = false;
      });
    }
  }

  getCategoryProduct(Categories categories, Categories parent) {
    if (parent != null) {
      parentCategory = parent;
    } else {
      parentCategory = null;
    }
    currentCategory = categories.name;
    if (categories.details != null) {
      currentCategoryDetails = categories.details;
    } else {
      currentCategoryDetails = "";
    }

    productList.clear();
    for (int i = 0; i < categories.products.length; i++) {
      productList.add(categories.products[i]);
    }

    setState(() {
      if (productList.length == 0) _category = false;
      _isMore = false;
      // _scrollController.animateTo(
      //   _scrollController.position.minScrollExtent,
      //   duration: Duration(milliseconds: 500),
      //   curve: Curves.fastOutSlowIn,
      // );
    });
  }

  getCategoryFavouriteProduct(List<Products> favourites) {
    currentCategory = "Favourites";
    productList.clear();
    for (int i = 0; i < favourites.length; i++) {
      productList.add(favourites[i]);
    }

    setState(() {
      if (productList.length == 0) _category = false;
      // _scrollController.animateTo(
      //   _scrollController.position.minScrollExtent,
      //   duration: Duration(milliseconds: 500),
      //   curve: Curves.fastOutSlowIn,
      // );
    });
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

      for (int i = 0; i < loginResponse.data.discounts.length; i++) {
        checkDiscount(loginResponse.data.discounts[i]);
      }
    }
  }

  checkDiscount(Discounts discounts) {
    //print(discounts.toJson());

    if (loginResponse.data.orders.length == 0 && discounts != null) {
      if (discounts.isOnline == 1 &&
      discounts.onDelivery == 1 &&
          discounts.onCollection == 1 &&
          discounts.on_cash == 1 &&
          getWeekDay(discounts) == 1 &&
          getDate(discounts) == 1) {
        getDiscountAmount(discounts, "on Cash");
      } else if (discounts.isOnline == 1 && discounts.onDelivery == 1 &&
          discounts.on_cash == 1 &&
          getWeekDay(discounts) == 1 &&
          getDate(discounts) == 1) {
        getDiscountAmount(discounts, "on Delivery & Cash");
      } else if (discounts.isOnline == 1 && discounts.onCollection == 1 &&
          discounts.on_cash == 1 &&
          getWeekDay(discounts) == 1 &&
          getDate(discounts) == 1) {
        getDiscountAmount(discounts, "on Collection & Cash");
      }
    } else if (discounts != null) {
      if (discounts.isOnline == 1 && discounts.onDelivery == 1 &&
          discounts.onCollection == 1 &&
          discounts.on_cash == 1 &&
          getWeekDay(discounts) == 1 &&
          getDate(discounts) == 1 &&
          discounts.onFirstOrder == 0) {
        getDiscountAmount(discounts, "on Cash");
      } else if (discounts.isOnline == 1 && discounts.onDelivery == 1 &&
          discounts.on_cash == 1 &&
          getWeekDay(discounts) == 1 &&
          getDate(discounts) == 1 &&
          discounts.onFirstOrder == 0) {
        getDiscountAmount(discounts, "on Delivery & Cash");
      } else if (discounts.isOnline == 1 && discounts.onCollection == 1 &&
          discounts.on_cash == 1 &&
          getWeekDay(discounts) == 1 &&
          getDate(discounts) == 1 &&
          discounts.onFirstOrder == 0) {
        getDiscountAmount(discounts, "on Collection & Cash");
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

  void getDiscountAmount(Discounts discounts, String text) {

    if (discounts != null) {
        if(discounts.onFirstOrder == 1){
          _isFirstOrder = true;
          discount = discounts;
        }else if(!_isFirstOrder){
          discount = discounts;
        }
    }
    setState(() {});
  }

  void getConfig() {
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias ==
          Common.EIGHTEEN_PLUS_CONDITION) {
        eighteenPlusCon = loginResponse.data.config[i].value;
      }
    }
  }

  isFocusedChiled(List<Categories> categories) {
    bool isFocuesed = false;
    for (int i = 0; i < categories.length; i++) {
      if (categories[i].name == currentCategory) isFocuesed = true;
    }
    return isFocuesed;
  }

  Future<void> checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      setState(() {
        token = sharedPreferences.getString("token");
      });
    }
  }

  getLondonTime() {
    return DateTime.now().timeZoneOffset.inSeconds > 0
        ? DateTime.now().subtract(DateTime.now().timeZoneOffset)
        : DateTime.now().add(DateTime.now().timeZoneOffset);
  }
}

// productList.length != 0
// ? Expanded(
// child: Container(
// child: ListView.builder(
// padding: EdgeInsets.only(bottom: 15),
// shrinkWrap: true,
// controller: _scrollController,
// physics: ClampingScrollPhysics(),
// itemCount: productList.length,
// itemBuilder:
// (BuildContext context, int index) {
// return Card(
// margin: EdgeInsets.only(
// left: 10, right: 10, top: 15),
// color: Colors.white12,
// shape: RoundedRectangleBorder(
// borderRadius:
// BorderRadius.circular(15.0),
// ),
// child: Column(
// children: [
// Container(
// height: screenWidth * .5,
// child: Row(
// children: <Widget>[
// Stack(
// children: <Widget>[
// Container(
// alignment: Alignment
//     .center,
// padding:
// EdgeInsets.all(
// 10),
// height:
// screenWidth *
// .5,
// width: screenWidth *
// .5,
// child: Icon(
// Icons.photo,
// size:
// screenWidth *
// .5 -
// 20,
// color: Colors
//     .white12,
// ),
// ),
// Container(
// padding:
// EdgeInsets.all(
// 10),
// height:
// screenWidth *
// .5,
// width: screenWidth *
// .5,
// child:
// GestureDetector(
// onTap: () async {
// box = await Hive
//     .openBox(Common
//     .DATABASE);
// box.put(
// Common.CART,
// cart);
//
// Navigator.of(
// context)
//     .push(MaterialPageRoute(
// builder: (BuildContext
// context) =>
// DetailsPage(productList[
// index])))
//     .then(
// (value) {
// setState(() {
// if (cart.productCartItem
//     .length !=
// 0) {
// _navBar =
// false;
// }
// });
// });
// },
// child: ClipRRect(
// borderRadius: BorderRadius.only(
// bottomLeft:
// Radius.circular(
// 15),
// bottomRight:
// Radius.circular(
// 15),
// topLeft: Radius
//     .circular(
// 15),
// topRight: Radius
//     .circular(
// 15)),
// child:
// CachedNetworkImage(
// fit: BoxFit
//     .cover,
// imageUrl: loginResponse
//     .data
//     .productPath +
// productList[
// index]
//     .imgSrc,
// ),
// ),
// ),
// ),
// cart.productsId.contains(
// productList[
// index]
//     .id
//     .toString())
// ? Container(
// margin: EdgeInsets.only(
// left:
// 15.0,
// top: 10),
// padding:
// EdgeInsets
//     .all(
// 10),
// decoration: BoxDecoration(
// color: Color(
// 0xffB72027),
// shape: BoxShape
//     .circle),
// child: Text(
// cart
//     .productCartItem[cart
//     .productsId
//     .indexOf(productList[index].id.toString())]
//     .productQuantity
//     .toString(),
// style: TextStyle(
// color: Colors
//     .white),
// ))
//     : Container(
// height: 0,
// )
// ],
// ),
// Column(
// mainAxisAlignment:
// MainAxisAlignment
//     .start,
// children: [
// SizedBox(height: 10),
// Container(
// height: 20,
// width: screenWidth *
// .5 -
// 20,
// padding:
// EdgeInsets.only(
// right: 0),
// alignment: Alignment
//     .centerLeft,
// child: buildText(
// productList[
// index]
//     .name,
// 16,
// null,
// Colors.white),
// ),
// Container(
// width: screenWidth *
// .5 -
// 20,
// height: 20,
// margin:
// EdgeInsets.only(
// bottom: 0),
// child: buildText(
// "Price : ₤ " +
// productList[
// index]
//     .rateOnline,
// 16,
// null,
// Colors.white),
// ),
// SizedBox(
// height: 10,
// ),
// Container(
// height:
// screenWidth *
// .5 -
// 120,
// width:
// screenWidth *
// .5 -
// 20,
// padding: EdgeInsets
//     .only(
// right: 5),
// child:
// SingleChildScrollView(
// physics:
// ClampingScrollPhysics(),
// child: Wrap(
// alignment:
// WrapAlignment
//     .start,
// direction: Axis
//     .horizontal,
// children: <
// Widget>[
// productList[index].isNew ==
// 1
// ? buildText(
// "New",
// 14,
// Colors.red,
// Colors.white)
//     : Container(
// width:
// 0,
// ),
// productList[index].isVegetarian ==
// 1
// ? buildText(
// "Vegetarian",
// 14,
// Colors.green,
// Colors.white)
//     : Container(
// width:
// 0,
// ),
// productList[index].isHalal ==
// 1
// ? buildText(
// "Halal",
// 14,
// Colors.white,
// Colors.black)
//     : Container(
// width:
// 0,
// ),
// productList[index].is18plus ==
// 1
// ? buildText(
// "18+",
// 14,
// Colors.deepOrange,
// Colors.white)
//     : Container(
// width:
// 0,
// ),
// productList[index].isVegetarian ==
// 1
// ? buildText(
// "Fish",
// 14,
// Colors.amber,
// Colors.black)
//     : Container(
// width:
// 0,
// ),
// productList[index].isVegetarian ==
// 1
// ? buildText(
// "SeaFood",
// 14,
// Colors.blue,
// Colors.white)
//     : Container(
// width:
// 0,
// ),
// productList[index].hasNut ==
// 1
// ? buildText(
// "Nut",
// 14,
// Colors.orangeAccent,
// Colors.black)
//     : Container(
// width:
// 0,
// ),
// productList[index].hasGluten ==
// 1
// ? buildText(
// "Gluten",
// 14,
// Colors.amberAccent,
// Colors.black)
//     : Container(
// width:
// 0,
// ),
// ],
// ),
// )),
// Expanded(
// child:
// Container()),
// Container(
// padding: EdgeInsets
//     .only(
// bottom:
// 10,
// top: 10),
// width:
// screenWidth *
// .5 -
// 20,
// alignment: Alignment
//     .centerLeft,
// child: Row(
// children: [
// Container(
// height: 35,
// width: 35,
// decoration: BoxDecoration(
// color: Color(
// 0xffB72027),
// shape: BoxShape
//     .circle),
// child:
// IconButton(
// onPressed:
// () {
// addToCart(
// productList[index]);
// },
// icon:
// Icon(
// Icons
//     .shopping_cart,
// color: Colors
//     .white,
// size:
// 20,
// ),
// ),
// ),
// Expanded(
// child: Container(
// height: 25,
// alignment: Alignment.center,
// child: RaisedButton(
// padding:
// EdgeInsets.all(0),
// color:
// Color(0xffB72027),
// onPressed:
// () async {
// box = await Hive.openBox(Common.DATABASE);
// box.put(Common.CART, cart);
//
// Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DetailsPage(productList[index]))).then((value) {
// setState(() {
// if (cart.productCartItem.length != 0) {
// _navBar = false;
// }
// });
// });
// },
// child:
// Text(
// "Details",
// style: TextStyle(color: Colors.white),
// ),
// )))
// ],
// )),
// ],
// ),
// ],
// ),
// ),
// productList[index].details !=
// null
// ? Container(
// alignment: Alignment
//     .centerLeft,
// padding:
// EdgeInsets.only(
// left: 10,
// right: 10,
// bottom: 10),
// child: Text(
// productList[index]
//     .details,
// style: TextStyle(
// color:
// Colors.white),
// maxLines: 2,
// ),
// )
//     : Container(
// width: 0,
// ),
// ],
// ));
// }),
// ))
// : Expanded(
// child: Center(
// child: Container(
// padding: EdgeInsets.all(10),
// child: Text(
// currentCategory + " Item Not Found",
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 25, color: Colors.red),
// ),
// )),
// ),

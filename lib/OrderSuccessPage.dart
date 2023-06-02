import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'HomePage.dart';
import 'Paypal.dart';
import 'common/Common.dart';
import 'database/Cart.dart';
import 'database/LoginResponse.dart';

class OrderSuccessPage extends StatefulWidget {
  String message, paymentToken;
  OrderSuccessPage(this.message, this.paymentToken, {Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderSuccessPage();
  }
}

class _OrderSuccessPage extends State<OrderSuccessPage> {
  LoginResponse loginResponse;
  Cart cart;
  SharedPreferences sharedPreferences;
  bool _isLoading = false;
  Orders orders;

  @override
  void initState() {
    getLoginResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => HomePage()));
            return false;
          },
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                height: screenHeight,
                color: Colors.black87,
                // decoration: BoxDecoration(
                //     // borderRadius:
                //     // BorderRadius.all(Radius.circular(50.0)),
                //     gradient: LinearGradient(
                //         begin: Alignment.bottomLeft,
                //         end: Alignment.topRight,
                // colors: [Colors.purple, Color(0xffB72027)])),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                        height: MediaQuery.of(context).padding.top + 80,
                        color: Colors.amber[600],
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top),
                          child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Order Details",
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
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  HomePage()));
                                    }),
                              ),
                            ],
                          ),
                        )),
                    orders != null && widget.message != ""
                        ? Container(
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Text(
                              widget.message,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.amber[400]),
                            ),
                          )
                        : Container(
                            height: 20,
                          ),

                    getSpamMessage() != ""?
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 0, bottom: 10),
                      child: Text(getSpamMessage(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16, color: Colors.red),
                      ),
                    ):Container(height: 0,),
                    loginResponse != null
                        ? orders != null
                            ? orders.paymentMethod != "CASH" &&
                                    orders.paymentStatus != "PAID"
                                ? Container(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 20, bottom: 0),
                                    child: Card(
                                        color: Colors.white24,
                                        child: Container(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.all(5),
                                                    child:
                                                        getPaymentFailureMessage() !=
                                                                ""
                                                            ? Text(
                                                                getPaymentFailureMessage() +
                                                                    " " +
                                                                    orders
                                                                        .orderCode,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .amber[
                                                                        400],
                                                                    fontSize:
                                                                        18),
                                                              )
                                                            : Container(
                                                                height: 0)),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    "Phone : " +
                                                        loginResponse
                                                            .data.contact.phone,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    "Email : " +
                                                        loginResponse
                                                            .data.contact.email,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                )
                                              ],
                                            ))))
                                : Container(
                                    height: 0,
                                  )
                            : !_isLoading
                                ? Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Order Not Found, \nIt might be Expired",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.amber[400]),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              left: 25,
                                              right: 25,
                                              top: 20,
                                              bottom: 20),
                                          child: RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          HomePage()));
                                            },
                                            color: Colors.amber[600],
                                            child: Container(
                                              padding: EdgeInsets.all(12),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Back to Home",
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
                                        ),
                                      ],
                                    ))
                                : Container(
                                    height: 0,
                                  )
                        : Container(
                            height: 0,
                          ),
                    orders != null
                        ? orders.paymentStatus != "PAID" &&
                                orders.paymentMethod != "CASH"
                            ? !isHasTime(orders.delivery_time)
                                ? Container(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      PayPal(
                                                          "",
                                                          orders
                                                              .payment_token)));
                                        },
                                        child: Container(
                                          color: Colors.white24,
                                          width: 100,
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            "Pay Now",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        )))
                                : Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.only(bottom: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Order Expired",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  )
                            : Container(
                                height: 0,
                              )
                        : Container(
                            height: 0,
                          ),
                    // Container(
                    //   padding: EdgeInsets.only(left: 20, bottom: 10),
                    //   alignment: Alignment.centerLeft,
                    //   child: Text(
                    //     "Order Details : ",
                    //     style: TextStyle(fontSize: 20, color: Colors.amber[400]),
                    //   ),
                    // ),
                    loginResponse != null && orders != null
                        ? Expanded(
                            child: Container(
                            padding: EdgeInsets.only(left: 10),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    child: Text(
                                      "Order Ref: " + orders.orderCode,
                                      style: TextStyle(
                                          color: Colors.amber[400],
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  buildText("Order time: " +
                                      DateFormat("dd/MM/yyyy hh:mm a").format(
                                          DateFormat("yyyy-MM-ddTHH:mm:ss")
                                              .parse(orders.createdAt))),
                                  buildText("Order Type: " + orders.type),
                                  buildText((orders.order_for == "LATER" ? "Requested ": "")+ (orders.type == "DELIVERY" ? "Delivery": orders.type == "COLLECTION"? "Collection":"Reservation")+ " Time: " +
                                      orders.delivery_time_text),
                                  buildText("Delivery Status : " +
                                      orders.deliveryStatus),
                                  buildText("Item Quantity: " +
                                      orders.qty.toString()),
                                  buildText("Payment amount: ₤ " +
                                      orders.paymentAmount),
                                  buildText("Payment Method: " +
                                      orders.paymentMethod),
                                  orders.paymentStatus == "PAID"
                                      ? buildText("Payment Status: " +
                                          orders.paymentStatus)
                                      : buildText(
                                          "Payment Status: " + "NOT PAID"),
                                  buildText("Delivery charge: ₤ " +
                                      orders.deliveryCharge),
                                  double.parse(orders.discountAmount) > 0
                                      ? buildText("Discount Amount: ₤ " +
                                          orders.discountAmount)
                                      : Container(
                                          height: 0,
                                        ),

                                  // orders.type ==
                                  //         Common.DELIVERY_TIME
                                  //     ? buildText("We will serve you within " +
                                  //         getDeliveryTime())
                                  //     : buildText("We will serve you within " +
                                  //         getCollectionTime()),
                                  Container(
                                    padding:
                                        EdgeInsets.only(top: 20, right: 20),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        padding: EdgeInsets.only(),
                                        itemCount: orders.detail.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              // setState(() {
                                              //   detailIndex = index;
                                              //   _detailPage = true;
                                              // });
                                            },
                                            child: Card(
                                              color: Colors.white10,
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: screenWidth * .5,
                                                      child: buildText(orders
                                                          .detail[index]
                                                          .productName),
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      children: [
                                                        buildText("x " +
                                                            orders.detail[index]
                                                                .qty
                                                                .toString()),
                                                        buildText("₤ " +
                                                            orders.detail[index]
                                                                .unitPrice
                                                                .toString()),
                                                      ],
                                                    ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left: 5,
                                        right: 25,
                                        top: 20,
                                        bottom: 20),
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        HomePage()));
                                      },
                                      color: Colors.amber[600],
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Back to Home",
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
                                  ),
                                ],
                              ),
                            ),
                          ))
                        : Container(
                            height: 0,
                          ),
                  ],
                )),
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
          )),
    );
  }

  Future<void> getLoginResponse() async {
    var box = await Hive.openBox(Common.DATABASE);
    loginResponse = box.get(Common.LOGINRESPONSE);
    cart = box.get(Common.CART);

    getOrder();

    box.close();
    setState(() {});
  }

  buildText(text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
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

  Future<void> reloadProduct() async {
    setState(() {
      _isLoading = true;
    });
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

    var response = await http.get(Common.BASE_URL + "sync?finger_print=" + info,
        headers: headers);

    print(response.body);

    if (response.statusCode == 200) {
      LoginResponse reloadLoginResponse = new LoginResponse();

      reloadLoginResponse = LoginResponse.fromJson(json.decode(response.body));

      if (reloadLoginResponse.data.categories.length != 0 ||
          reloadLoginResponse.data.discounts.length != 0 ||
          reloadLoginResponse.data.orders.length != 0 ||
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
        loginResponse.data.orders = reloadLoginResponse.data.orders.length != 0
            ? reloadLoginResponse.data.orders
            : loginResponse.data.orders;
        loginResponse.data.favourites =
            reloadLoginResponse.data.favourites.length != 0
                ? reloadLoginResponse.data.favourites
                : loginResponse.data.favourites;
        loginResponse.data.config = reloadLoginResponse.data.config.length != 0
            ? reloadLoginResponse.data.config
            : loginResponse.data.config;

        loginResponse.data.productList =
            reloadLoginResponse.data.productList.length != 0
                ? reloadLoginResponse.data.productList
                : loginResponse.data.productList;

        var box = await Hive.openBox(Common.DATABASE);
        box.put(Common.LOGINRESPONSE, loginResponse);

        for (int i = 0; i < loginResponse.data.orders.length; i++) {
          if (widget.paymentToken ==
              loginResponse.data.orders[i].payment_token) {
            orders = loginResponse.data.orders[i];
            setState(() {});
          }
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, String> get headers => {
        "Accept": "application/json",
        "Authorization": "Bearer " + sharedPreferences.getString("token")
      };

  String getPaymentFailureMessage() {
    String text = "";
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.PAYMENT_FAILURE_MESSAGE)
        text = loginResponse.data.config[i].value;
    }
    return text;
  }

  void getOrder() {
    for (int i = 0; i < loginResponse.data.orders.length; i++) {
      if (widget.paymentToken == loginResponse.data.orders[i].payment_token) {
        orders = loginResponse.data.orders[i];
        if (orders.paymentMethod != "CASH") {
          orders = null;
          reloadProduct();
        }
      }
    }
  }

  bool isHasTime(String delivery_time) {
    return DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(getLondonTime().toString())
                .difference(
                    DateFormat("yyyy-MM-dd HH:mm:ss").parse(delivery_time))
                .inSeconds >
            600
        ? true
        : false;
  }

  getLondonTime() {
    return DateTime.now().timeZoneOffset.inSeconds > 0
        ? DateTime.now().subtract(DateTime.now().timeZoneOffset)
        : DateTime.now().add(DateTime.now().timeZoneOffset);
  }

  String getSpamMessage() {
    if(loginResponse != null)
    for(int i = 0; i < loginResponse.data.config.length; i++){
      if (loginResponse.data.config[i].alias == Common.EMAIL_CHECK_NOTE) {
        return loginResponse.data.config[i].value;
      }
    }
    return "";
  }
}

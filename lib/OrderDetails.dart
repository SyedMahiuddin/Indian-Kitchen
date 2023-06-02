import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mustard/Paypal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'HomePage.dart';
import 'common/Common.dart';
import 'database/LoginResponse.dart';

class OrderDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OrderDetails();
  }
}

class _OrderDetails extends State<OrderDetails> {
  LoginResponse loginResponse;
  bool _detailPage = false;
  int detailIndex = 0;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: WillPopScope(
            onWillPop: () async {
              if (_detailPage) {
                setState(() {
                  _detailPage = false;
                });
              } else
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => HomePage()));
              return false;
            },
            child: Container(
              height: screenHeight,
              color: Colors.black,
              child: Stack(
                children: [
                  Column(
                    children: [
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
                                  "Your Orders",
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
                          )),
                      loginResponse != null
                          ? loginResponse.data.orders.length != 0
                              ? Expanded(
                                  child: Container(
                                  padding: EdgeInsets.all(10),
                                  color: Colors.black87,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      padding: EdgeInsets.only(),
                                      itemCount:
                                          loginResponse.data.orders.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              detailIndex = index;
                                              _detailPage = true;
                                            });
                                          },
                                          child: Card(
                                            color: loginResponse
                                                        .data
                                                        .orders[index]
                                                        .deliveryStatus ==
                                                    "DELIVERED"
                                                ? Colors.green[800]
                                                : loginResponse
                                                            .data
                                                            .orders[index]
                                                            .deliveryStatus ==
                                                        "ON WAY"
                                                    ? Colors.green[900]
                                                    : loginResponse
                                                                .data
                                                                .orders[index]
                                                                .deliveryStatus ==
                                                            "PROCESSING"
                                                        ? Colors.amber[900]
                                                        : loginResponse
                                                                    .data
                                                                    .orders[
                                                                        index]
                                                                    .deliveryStatus ==
                                                                "CANCELLED"
                                                            ? Colors.red
                                                            : loginResponse
                                                                        .data
                                                                        .orders[
                                                                            index]
                                                                        .deliveryStatus ==
                                                                    "RECEIVED"
                                                                ? Colors.blueGrey[
                                                                    900]
                                                                : Colors
                                                                    .white10,
                                            child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width:
                                                              screenWidth * .5 -
                                                                  40,
                                                          child: Column(
                                                            children: [
                                                              buildText("Order Ref: " +
                                                                  loginResponse
                                                                      .data
                                                                      .orders[
                                                                  index]
                                                                      .orderCode),
                                                              loginResponse
                                                                  .data
                                                                  .orders[
                                                              index]
                                                                  .type == "RESERVATION" ?
                                                              buildText("RESERVATION") :
                                                              buildText("₤ " +
                                                                  loginResponse
                                                                      .data
                                                                      .orders[
                                                                  index]
                                                                      .paymentAmount),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                            child: Column(
                                                          children: [
                                                            buildText(DateFormat(
                                                                "dd/MM/yyyy")
                                                                .format(DateFormat(
                                                                "yyyy-MM-dd")
                                                                .parse(loginResponse
                                                                .data
                                                                .orders[
                                                            index]
                                                                .updatedAt))),
                                                            buildText(
                                                                loginResponse
                                                                    .data
                                                                    .orders[
                                                                index]
                                                                    .deliveryStatus),
                                                          ],
                                                        ))
                                                      ],
                                                    ),
                                                    loginResponse
                                                        .data
                                                        .orders[
                                                    index]
                                                        .type != "RESERVATION" ?
                                                    loginResponse
                                                                .data
                                                                .orders[index]
                                                                .paymentMethod !=
                                                            "CASH"
                                                        ? Container(
                                                            alignment: Alignment
                                                                .center,
                                                            child: loginResponse
                                                                        .data
                                                                        .orders[
                                                                            index]
                                                                        .paymentStatus ==
                                                                    "PAID"
                                                                ? Container(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    child: Text(
                                                                      "PAID ONLINE",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )
                                                                : !isHasTime(loginResponse
                                                                            .data
                                                                            .orders[
                                                                                index]
                                                                            .delivery_time)
                                                                    ? Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child: GestureDetector(
                                                                            onTap: () {
                                                                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => PayPal("", loginResponse.data.orders[index].payment_token)));
                                                                            },
                                                                            child: Container(
                                                                              color: Colors.white24,
                                                                              width: 100,
                                                                              padding: EdgeInsets.all(5),
                                                                              child: Text(
                                                                                "Pay Now",
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontSize: 16, color: Colors.white),
                                                                              ),
                                                                            )))
                                                                    : Container(
                                                                        padding:
                                                                            EdgeInsets.all(5),
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          "Order Expired",
                                                                          style: TextStyle(
                                                                              fontSize: 16,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ))
                                                        : Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "CASH PAYMENT",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ):Container(height: 0,)
                                                  ],
                                                )),
                                          ),
                                        );
                                      }),
                                ))
                              : Expanded(
                                  child: Center(
                                      child: Container(
                                    child: Text(
                                      "No Order Found",
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.amber[600]),
                                    ),
                                  )),
                                )
                          : Container(
                              height: 0,
                            )
                    ],
                  ),
                  _detailPage
                      ? Container(
                          color: Colors.black,
                          child: Container(
                              height: screenHeight,
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
                                              "Orders Details",
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
                                                  setState(() {
                                                    _detailPage = false;
                                                  });
                                                }),
                                          ),
                                        ],
                                      )),

                                  SizedBox(height: 10,),

                                  loginResponse != null &&
                                          loginResponse.data.orders[detailIndex]
                                                  .paymentMethod !=
                                              "CASH" &&
                                          loginResponse.data.orders[detailIndex]
                                                  .paymentStatus !=
                                              "PAID"
                                      ? Container(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20, top: 10),
                                          child: Card(
                                              color: Colors.white24,
                                              child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          padding:
                                                              EdgeInsets.all(5),
                                                          child:
                                                              getPaymentFailureMessage() !=
                                                                      ""
                                                                  ? Text(
                                                                      getPaymentFailureMessage() +
                                                                          " " +
                                                                          loginResponse
                                                                              .data
                                                                              .orders[detailIndex]
                                                                              .orderCode,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .amber[400],
                                                                          fontSize:
                                                                              18),
                                                                    )
                                                                  : Container(
                                                                      height:
                                                                          0)),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          "Phone : " +
                                                              loginResponse
                                                                  .data
                                                                  .contact
                                                                  .phone,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                          "Email : " +
                                                              loginResponse
                                                                  .data
                                                                  .contact
                                                                  .email,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                        ),
                                                      )
                                                    ],
                                                  ))))
                                      : Container(
                                          height: 0,
                                        ),
                                  loginResponse.data.orders[detailIndex]
                                                  .paymentStatus !=
                                              "PAID" &&
                                          loginResponse.data.orders[detailIndex]
                                                  .paymentMethod !=
                                              "CASH"
                                      ? !isHasTime(
                                              loginResponse
                                                  .data
                                                  .orders[detailIndex]
                                                  .delivery_time)
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
                                                                    loginResponse
                                                                        .data
                                                                        .orders[
                                                                            detailIndex]
                                                                        .payment_token)));
                                                  },
                                                  child: Container(
                                                    color: Colors.white24,
                                                    width: 100,
                                                    padding: EdgeInsets.all(5),
                                                    margin: EdgeInsets.only(bottom: 10),
                                                    child: Text(
                                                      "Pay Now",
                                                      textAlign:
                                                          TextAlign.center,
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
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                            )
                                      : Container(
                                          height: 0,
                                        ),
                                  loginResponse != null
                                      ? Expanded(
                                          child: SingleChildScrollView(
                                              child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: [

                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5,
                                                    bottom: 5),
                                                child: Text(
                                                  "Order Ref: " +
                                                      loginResponse
                                                          .data
                                                          .orders[detailIndex]
                                                          .orderCode,
                                                  style: TextStyle(
                                                      color: Colors.amber[400],
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              buildText("Order time: " +
                                                  DateFormat("dd/MM/yyyy hh:mm a")
                                                      .format(DateFormat(
                                                              "yyyy-MM-ddTHH:mm:ss")
                                                          .parse(loginResponse
                                                              .data
                                                              .orders[
                                                                  detailIndex]
                                                              .createdAt))),
                                              buildText("Order Type: " +
                                                  loginResponse
                                                      .data
                                                      .orders[detailIndex]
                                                      .type),
                                              buildText((loginResponse
                                                  .data
                                                  .orders[detailIndex].order_for == "LATER" ? "Requested ": "")+ (loginResponse
                                                  .data
                                                  .orders[detailIndex].type == "DELIVERY" ? "Delivery": loginResponse
                                                  .data
                                                  .orders[detailIndex].type == "COLLECTION"? "Collection":"Reservation")+ " Time: " +
                                                  loginResponse
                                                      .data
                                                      .orders[detailIndex].delivery_time_text),
                                              buildText("Delivery Status : " +
                                                  loginResponse
                                                      .data
                                                      .orders[detailIndex]
                                                      .deliveryStatus),
                                              buildText("Item Quantity: " +
                                                  loginResponse.data
                                                      .orders[detailIndex].qty
                                                      .toString()),
                                              buildText("Payment amount: ₤ " +
                                                  loginResponse
                                                      .data
                                                      .orders[detailIndex]
                                                      .paymentAmount),
                                              buildText("Payment Method: " +
                                                  loginResponse
                                                      .data
                                                      .orders[detailIndex]
                                                      .paymentMethod),

                                              loginResponse
                                                          .data
                                                          .orders[detailIndex]
                                                          .paymentStatus ==
                                                      "PAID"
                                                  ? buildText(
                                                      "Payment Status: " +
                                                          loginResponse
                                                              .data
                                                              .orders[
                                                                  detailIndex]
                                                              .paymentStatus)
                                                  : buildText(
                                                  "Payment Status: NOT PAID"),
                                              buildText("Delivery charge: ₤ " +
                                                  loginResponse
                                                      .data
                                                      .orders[detailIndex]
                                                      .deliveryCharge),

                                              double.parse(loginResponse
                                                  .data
                                                  .orders[detailIndex]
                                                  .discountAmount) > 0 ?
                                              buildText("Discount Amount: ₤ " +
                                                  loginResponse
                                                      .data
                                                      .orders[detailIndex]
                                                      .discountAmount): Container(height: 0,),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 5,
                                                    top: 20,
                                                    right: 20),
                                                child: ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        ClampingScrollPhysics(),
                                                    padding: EdgeInsets.only(),
                                                    itemCount: loginResponse
                                                        .data
                                                        .orders[detailIndex]
                                                        .detail
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
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
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  width:
                                                                      screenWidth *
                                                                          .5,
                                                                  child: buildText(loginResponse
                                                                      .data
                                                                      .orders[
                                                                          detailIndex]
                                                                      .detail[
                                                                          index]
                                                                      .productName),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  children: [
                                                                    buildText("x " +
                                                                        loginResponse
                                                                            .data
                                                                            .orders[detailIndex]
                                                                            .detail[index]
                                                                            .qty
                                                                            .toString()),
                                                                    buildText("₤ " +
                                                                        loginResponse
                                                                            .data
                                                                            .orders[detailIndex]
                                                                            .detail[index]
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
                                                    left: 10,
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
                                                    width:
                                                        MediaQuery.of(context)
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
                                                        BorderRadius.circular(
                                                            0.0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )))
                                      : Container(
                                          height: 0,
                                        ),
                                ],
                              )),
                        )
                      : Container(
                          height: 0,
                        ),
                ],
              ),
            )));
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

  Future<void> getData() async {
    var box = await Hive.openBox(Common.DATABASE);
    loginResponse = box.get(Common.LOGINRESPONSE) as LoginResponse;

    box.close();
    reloadProduct();
    setState(() {});
  }

  Future<void> reloadProduct() async {
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

      loginResponse.data.orders = reloadLoginResponse.data.orders;

      var box = await Hive.openBox(Common.DATABASE);
      box.put(Common.LOGINRESPONSE, loginResponse);

      setState(() {});
    }
  }

  Map<String, String> get headers => {
        "Accept": "application/json",
        "Authorization": "Bearer " + sharedPreferences.getString("token")
      };

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

  String getPaymentFailureMessage() {
    String text = "";
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.PAYMENT_FAILURE_MESSAGE)
        text = loginResponse.data.config[i].value;
    }
    return text;
  }

  getLondonTime() {
    return DateTime.now().timeZoneOffset.inSeconds > 0
        ? DateTime.now().subtract(DateTime.now().timeZoneOffset)
        : DateTime.now().add(DateTime.now().timeZoneOffset);
  }

  bool isHasTime(String delivery_time) {
    return DateFormat("yyyy-MM-dd HH:mm:ss")
                .parse(getLondonTime().toString())
                .difference(DateFormat("yyyy-MM-dd HH:mm:ss")
                    .parse(delivery_time))
                .inSeconds >
            600
        ? true
        : false;
  }
}

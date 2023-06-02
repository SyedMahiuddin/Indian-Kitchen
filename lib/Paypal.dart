import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:mustard/OrderSuccessPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'HomePage.dart';
import 'OrderDetails.dart';
import 'common/Common.dart';
import 'database/Cart.dart';
import 'database/LoginResponse.dart';

class PayPal extends StatefulWidget {
  String message, paymentToken;
  PayPal(this.message, this.paymentToken, {Key key}) : super(key: key);

  @override
  _PayPal createState() => _PayPal();
}

class _PayPal extends State<PayPal> {

  Cart cart;
  LoginResponse loginResponse;
  int callTimes = 0;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
            onWillPop: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => OrderSuccessPage(widget.message, widget.paymentToken)));
              return false;
            },
            child:  Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                // decoration: BoxDecoration(
                //     // borderRadius:
                //     // BorderRadius.all(Radius.circular(50.0)),
                //     gradient: LinearGradient(
                //         begin: Alignment.bottomLeft,
                //         end: Alignment.topRight,
                //         colors: [Colors.purple, Color(0xffB72027)])),

                child: Column(
                  children: [
                    Container(
                        height: MediaQuery.of(context).padding.top + 80,
                        padding:
                        EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                        color: Colors.amber[600],
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Payment",
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
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (BuildContext context) => OrderSuccessPage(widget.message, widget.paymentToken)));
                                  }),
                            ),
                          ],
                        )),

                    Expanded(child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        loginResponse != null ?
                        Container(
                            color: Colors.white,
                            padding: EdgeInsets.all(20),
                            child:
                            getPaymentWindowMessage() !=
                                ""
                                ? Text(
                              getPaymentWindowMessage(),
                              style: TextStyle(
                                  color: Colors
                                      .amber[600],
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                                : Container(height: 0)): Container(height: 0,),

                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              right: 20,
                              left: 20,
                              bottom: 20),
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => OrderSuccessPage(widget.message, widget.paymentToken)));
                            },
                            color: Colors.amber[600],
                            child: Container(
                              padding: EdgeInsets.all(12),
                              width: MediaQuery.of(context)
                                  .size
                                  .width,
                              alignment: Alignment.center,
                              child: Text(
                                "See Order Status",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  10.0),
                            ),
                          ),

                        )
                      ],
                    ))

                    // widget.orderCode != null ?
                    // Expanded(child: Container(
                    //   color: Colors.white,
                    //   child: WebView(
                    //   initialUrl: "https://www.mustardindian.com/paypal/" + widget.orderCode,
                    //   javascriptMode: JavascriptMode.unrestricted,
                    // ),
                    // ),): Expanded(child: Container(color: Colors.white,),)


                  ],
                ))));
  }

  Future<void> getData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    var box = await Hive.openBox(Common.DATABASE);
    loginResponse = box.get(Common.LOGINRESPONSE);
    cart = box.get(Common.CART);
    box.close();

    String url =
        "https://www.mustardindian.com/"+loginResponse.data.payment_link + "/" + widget.paymentToken;
    if (await canLaunch(url)) {
      await launch(url, enableJavaScript: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }


    callStatus();

    setState(() {});
  }

  buildText(text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 18),
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

  String getPaymentWindowMessage() {
    String text = "";
    for (int i = 0; i < loginResponse.data.config.length; i++) {
      if (loginResponse.data.config[i].alias == Common.PAYMENT_WINDOW_MESSAGE)
        text = loginResponse.data.config[i].value;
    }
    return text;
  }

  callStatus(){
    Future.delayed(const Duration(milliseconds: 10000), () async {

      callTimes++;
      if(callTimes >= 1 && callTimes <= 18) {

        String device = "";
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        if (Platform.isAndroid) {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          device = "android";
        } else if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          device = "iphone";
        }

        var response = await http.get("http://mustardindian.com/api/order/paymentupdate/" +
            widget.paymentToken+"?device="+device, headers: headers);

        if(response.statusCode == 200){
          Updated updated = Updated.fromJson(json.decode(response.body));
          print(updated.updated.toString());
          if(updated.updated == 1){
            callTimes = 18;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => OrderSuccessPage(widget.message, widget.paymentToken)));
            await closeWebView();
          }
        }
      }
      // else if(callTimes >= 30){
      //   Navigator.of(context).pushReplacement(MaterialPageRoute(
      //       builder: (BuildContext context) => OrderSuccessPage(widget.message, widget.paymentToken)));
      //   await closeWebView();
      // }
      if(callTimes < 18)
      callStatus();
    });
  }

  Map<String, String> get headers => {
    "Accept": "application/json",
    "Authorization": "Bearer " + sharedPreferences.getString("token")
  };
}

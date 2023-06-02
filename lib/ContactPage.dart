import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common/Common.dart';
import 'database/LoginResponse.dart';

class ContactPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ContactPage();
  }
}

class _ContactPage extends State<ContactPage> {
  var box;
  LoginResponse loginResponse;

  @override
  void initState() {
    getLoginResponse();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).padding.top + 80,
                color: Colors.amber[600],
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Contact",
                          style: TextStyle(fontSize: 25, color: Colors.black87),
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
            loginResponse != null
                ? Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth,
                            padding: EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                              child: CachedNetworkImage(
                                imageUrl: "https://www.mustardindian.com/" +
                                    loginResponse.data.contactPath +
                                    loginResponse.data.contact.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          loginResponse != null
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    loginResponse.data.contact.phone != null
                                        ? buildText(
                                            loginResponse.data.contact.phone,
                                            Icon(Icons.phone,
                                                color: Colors.white),
                                            false)
                                        : Container(
                                            height: 0,
                                          ),
                                    loginResponse.data.contact.email != null
                                        ? buildText(
                                            loginResponse.data.contact.email,
                                            Icon(Icons.email,
                                                color: Colors.white),
                                            false)
                                        : Container(
                                            height: 0,
                                          ),
                                    loginResponse.data.contact.website != null
                                        ? GestureDetector(
                                            onTap: () async {
                                              String url =
                                                  "https://${loginResponse.data.contact.website}";
                                              if (await canLaunch(url)) {
                                                await launch(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            },
                                            child: buildText(
                                                loginResponse
                                                    .data.contact.website,
                                                Icon(Icons.web,
                                                    color: Colors.white),
                                                true))
                                        : Container(
                                            height: 0,
                                          ),
                                    loginResponse.data.contact.address != null
                                        ? buildText(
                                            loginResponse.data.contact.address,
                                            Icon(Icons.location_on,
                                                color: Colors.white),
                                            false)
                                        : Container(
                                            height: 0,
                                          ),
                                    SizedBox(height: 20,),

                                  ],
                                )
                              : Container(
                                  height: 0,
                                ),
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> getLoginResponse() async {
    box = await Hive.openBox(Common.DATABASE);
    loginResponse = box.get(Common.LOGINRESPONSE) as LoginResponse;
    print( "https://www.mustardindian.com/" +
        loginResponse.data.contactPath +
        loginResponse.data.contact.image);
    setState(() {});
  }

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
                    fontSize: 18,
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
}

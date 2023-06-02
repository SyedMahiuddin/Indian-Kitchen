
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import 'common/Common.dart';
import 'database/LoginResponse.dart';

class GalleryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _GalleryPage();
  }
}

class _GalleryPage extends State<GalleryPage> {

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
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Gallery",
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

            loginResponse != null ?
            loginResponse.data.galleryList.length != 0
                ? Expanded(
                child: Container(
                  child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 15),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: loginResponse.data.galleryList.length,
                      itemBuilder:
                          (BuildContext context, int index) {
                        return Container(
                            margin: EdgeInsets.only(
                                left: 10, right: 10, top: 10),
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(15)),
                                child: CachedNetworkImage(imageUrl: "https://www.mustardindian.com/" + loginResponse.data.galaryPath+ loginResponse.data.galleryList[index].image,
                                  fit: BoxFit.cover,
                                )
                                    ));
                      }),
                ))
           : Container(height: 0,): Container(height: 0,),

          ],
        ),
      ),
    );
  }

  Future<void> getLoginResponse() async {
    box = await Hive.openBox(Common.DATABASE);
    loginResponse = box.get(Common.LOGINRESPONSE) as LoginResponse;
    setState(() {

    });
  }

  buildText(String text, Icon icon, bool link) {
    return Container(
      child: Row(
        children: [
          SizedBox(width: 10,),
          icon,
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
              child: Text(text, style: TextStyle(fontSize: 20, color: Colors.white,  decoration: link ? TextDecoration.underline: TextDecoration.none),),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'HomePage.dart';
import 'auth/SignIn.dart';
import 'database/Cart.dart';
import 'database/LoginResponse.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(LoginResponseAdapter());
  Hive.registerAdapter(DataAdapter());
  Hive.registerAdapter(OrdersAdapter());
  Hive.registerAdapter(OrderDetailAdapter());
  Hive.registerAdapter(CategoriesAdapter());
  Hive.registerAdapter(ProductsAdapter());
  Hive.registerAdapter(DiscountsAdapter());
  Hive.registerAdapter(ConfigAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(CartAdapter());
  Hive.registerAdapter(ProductCartItemAdapter());
  Hive.registerAdapter(ContactAdapter());
  Hive.registerAdapter(GalleryAdapter());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

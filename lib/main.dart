//@dart=2.9

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_shopping_app/providers/auth_provider.dart';
import 'package:flutter_shopping_app/providers/location_provider.dart';
import 'package:flutter_shopping_app/providers/store_provider.dart';
import 'package:flutter_shopping_app/screens/homeScreen.dart';
import 'package:flutter_shopping_app/screens/landing_screen.dart';
import 'package:flutter_shopping_app/screens/login_screen.dart';
import 'package:flutter_shopping_app/screens/main_screen.dart';
import 'package:flutter_shopping_app/screens/map_screen.dart';
import 'package:flutter_shopping_app/screens/product_details_screen.dart';
import 'package:flutter_shopping_app/screens/product_list_screen.dart';
import 'widgets/products/product_list.dart';
import 'package:flutter_shopping_app/screens/shop_home_screen.dart';

import 'package:flutter_shopping_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.deepOrangeAccent),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        MapScreen.id: (context) => MapScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        MainScreen.id: (context) => MainScreen(),
        ShopHomeScreen.id: (context) => ShopHomeScreen(),
        ProductListScreen.id: (context) => ProductListScreen(),
        ProductDetailsScreen.id: (context) => ProductDetailsScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}

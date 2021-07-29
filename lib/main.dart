

import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapfollow/provider/auth.dart';
import 'package:mapfollow/provider/cart.dart';
import 'package:mapfollow/provider/category.dart';
import 'package:mapfollow/provider/orders.dart';
import 'package:mapfollow/provider/restaurant.dart';
import 'package:mapfollow/provider/restaurants.dart';
import 'package:mapfollow/provider/thems.dart';
import 'package:mapfollow/screens/enable_location.dart';
import 'package:mapfollow/screens/logn.dart';
import 'package:location/location.dart';
import 'package:mapfollow/screens/restaurantScreen.dart';
import 'package:mapfollow/screens/splash_page.dart';
import 'package:mapfollow/services/geolocator_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './screens/map.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();

    runApp(MyApp());
}
class enableLocation extends StatefulWidget {
  @override
  _enableLocationState createState() => _enableLocationState();
}

class _enableLocationState extends State<enableLocation> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'عزومات',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      debugShowCheckedModeBanner: false,
      home: enable_location(),

    );
  }
}


class MyApp extends StatefulWidget {
  /*var to_map;
  MyApp(this.to_map);
   */

  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  Position  myposition ;
  var is_loading=true;
  var app;
  @override
  void initState() {



    Timer(Duration(seconds: 1), (){
      setState(() {
        is_loading=false;
      });
    });
    // TODO: implement initState
    super.initState();






  }


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: restaurant(),
        ),

        /*ChangeNotifierProvider.value(
          value: restaurants(),
        ),*/
        ChangeNotifierProxyProvider<Auth,restaurants>(
          create: (context) => restaurants(),
          update: (_,auth,res) => res..setUser(auth.token,auth.userId)
        ),
        ChangeNotifierProxyProvider<Auth,Meals>(
            create: (context) => Meals(),
            update: (_,auth,res) => res..setUser(auth.token,auth.userId)
        ),
        ChangeNotifierProxyProvider<Auth,Cart>(
            create: (context) => Cart(),
            update: (_,auth,res) => res..setUser(auth.token,auth.userId)
        ),
        ChangeNotifierProxyProvider<Auth,orders>(
            create: (context) => orders(),
            update: (_,auth,res) => res..setUser(auth.token,auth.userId)
        ),
        ChangeNotifierProxyProvider<Auth,themes>(
            create: (context) => themes(),
            update: (_,auth,res) => res..setdeftMode(auth.mode)
        ),
       



        /*ChangeNotifierProvider.value(
          value: Meals(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),*/




      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => Consumer<themes>(
          builder: (context,theme,_)=> MaterialApp(
            //builder: DevicePreview.appBuilder,
            title: 'عزومات',
            theme:theme.getthemeData(),/* ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
            ),*/
            debugShowCheckedModeBanner: false,
            //home: SplashPage(),
            home: is_loading?SplashPage():(auth.isAuth?/*Map()*/restaurantScreen():FutureBuilder(future:/*Provider.of<Auth>(context,listen: false)*/auth.autologin(),builder: (ctxn,snapshot)=>snapshot.connectionState==ConnectionState.waiting?SplashPage():login())/*:?:login()*/),

            //home: Directionality(textDirection: TextDirection.rtl,child: MealsScreen()),

          ),
        ),
      ),
    );


  }
}

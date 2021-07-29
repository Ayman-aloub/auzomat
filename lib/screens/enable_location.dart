
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mapfollow/main.dart';
import 'package:mapfollow/screens/logn.dart';
import 'package:mapfollow/screens/splash_page.dart';
import 'package:mapfollow/services/geolocator_service.dart';
import 'package:mapfollow/screens/map.dart';
import 'package:shared_preferences/shared_preferences.dart';
class enable_location extends StatefulWidget {
  @override
  _enable_locationState createState() => _enable_locationState();
}

class _enable_locationState extends State<enable_location> {
  var app;

  var looding=false;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:Theme.of(context).backgroundColor,
            title:  Center(child: Text('تشغيل الموقع')),


          ),


          body:looding?Center(child:CircularProgressIndicator()):Center(
              child: InkWell(
                onTap: () async {
                  setState(() {
                    looding=true;
                  });
                  Location location = new Location();

                  bool _serviceEnabled;
                  PermissionStatus _permissionGranted;


                  _serviceEnabled = await location.serviceEnabled();
                  if (!_serviceEnabled) {
                    _serviceEnabled = await location.requestService();
                    if (!_serviceEnabled) {
                      setState(() {
                        looding=false;
                      });
                    }
                  }

                  _permissionGranted = await location.hasPermission();
                  if (_permissionGranted == PermissionStatus.denied) {
                    _permissionGranted = await location.requestPermission();
                    if (_permissionGranted != PermissionStatus.granted) {
                      setState(() {
                        looding=false;
                      });
                    }
                  }
                  _serviceEnabled = await location.serviceEnabled();
                  if(_serviceEnabled){
                    setState(() {
                      looding=true;
                    });



                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Map()));


                      setState(() {
                        looding=false;
                      });




                  }
                  setState(() {
                    looding=false;
                  });
                },
                child: Text(' يجب عليك تفعيل الموقع من هنا',
                  style:TextStyle(fontSize: 20,color: Color(0xFFFF7643),fontWeight: FontWeight.bold),),
              ),
            ),


          ),


      ),
    );
  }
}

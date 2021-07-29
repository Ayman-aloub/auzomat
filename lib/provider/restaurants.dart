import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mapfollow/provider/restaurant.dart';

import '../models/http_exception.dart';


class restaurants with ChangeNotifier {
  String _userId;
  String _token;
  setUser(t,uId){
    _userId=uId;
    _token=t;
    //print("1111tokken"+_token);

  }
  List<restaurant> _items = [];
  List<restaurant> _currentitems = [];



  restaurants();

  List<restaurant> get items {
    return [..._items];

  }
  List<restaurant> get currentitems {
    return [..._currentitems];
  }



  restaurant findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
  Future<void> fetchAndSetProducts() async {

    var url =
        'https://termproject-81a0e-default-rtdb.firebaseio.com/restaurants.json?auth=$_token';


    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }


      
      final List<restaurant> loadedProducts = [];
      List<String> keys=extractedData.keys.toList();
      List<dynamic> values=extractedData.values.toList();
      for(var i=0;i<extractedData.length;i++){
        var cur=values[i] as Map<String, dynamic> ;
        loadedProducts.add( restaurant(
            id: keys[i],
            name: cur['name'],
            description: cur['describtion'],
            price: cur['service_price'],
            time:cur['time'],
            imageUrl:cur['img_url'] ,
            location:  LatLng(cur['latitude'],cur['longitude'])

        ));



      }

       /*extractedData.forEach((resId, resData) async {
        final ref = FirebaseStorage.instance.ref().child(resData['img_url']);
        String image_url=await ref.getDownloadURL();
        loadedProducts.add( restaurant(
          id: resId,
          name: resData['name'],
          description: resData['describtion'],
          price: resData['service_price'],
          time:resData['time'],
          imageUrl: image_url,
          location:  LatLng(resData['latitude'],resData['longitude'])

        ));
      });*/

      _items = loadedProducts;
       print('iiiiii'+loadedProducts.length.toString());

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchcurrentitems(LatLng myloc) async{
    final List<restaurant> loadedProducts = [];

    try{
      /*
      final coordinates = new Coordinates(
          myloc.latitude, myloc.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          coordinates);
      var first = addresses.first;
      print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
      print('adress');*/
      

     //_items.forEach((tx) async{
      for(var i=0;i<_items.length;i++){
        var tx = _items[i];
        double value=await Geolocator().distanceBetween(tx.location.latitude, tx
            .location.longitude, myloc.latitude, myloc.longitude);


        if(value<=10000) {
          loadedProducts.add(restaurant(
              id: tx.id,
              name: tx.name,
              description: tx.description,
              price: tx.price,
              time:tx.time,
              imageUrl: tx.imageUrl,
              location:  LatLng(tx.location.latitude,tx.location.longitude)

          ));


        }
        _currentitems=loadedProducts;

      }


    }catch (error) {
      throw (error);
    }
  }


}

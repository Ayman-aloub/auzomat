import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  var mode ;
  String _userId;
  Timer _authTimer;
  LatLng _myLocation;
  String _name;
  String _phone;
  String get name {
    return _name;
  }
  String get phone {
    return _phone;
  }


   setLocation(LatLng location){
     _myLocation=location;


  }
  LatLng get myLocation {
    return _myLocation;
  }
  bool get isAuth {
    return token != null;
  }

  Future<bool> autologin() async {
    SharedPreferences value=await SharedPreferences.getInstance();
    if(!value.containsKey('token')){
      return false;
    }
    var expire = value.getString('expiryDate');
    if(DateTime.parse(expire).isBefore(DateTime.now())){
      return false;
    }
    var token = value.getString('token');
    var userid =value.getString('userId');
    if(value.containsKey('mode')){
      mode=value.getString('mode');
    }



    _token=token;
    _userId=userid;
    _expiryDate=DateTime.parse(expire) ;
    //print("tokken"+_token);
    await getMoreInformation();
    notifyListeners();
    _autoLogout();
    return true;

  }


  Future<void> addMyLocation(LatLng mydefaultlocation) async {
    final url =
        'https://termproject-81a0e-default-rtdb.firebaseio.com/users/$_userId.json?auth=$_token';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'Lat': mydefaultlocation.latitude,
            'Long': mydefaultlocation.longitude,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }


      notifyListeners();
    } catch (error) {
      throw error;
    }

  }
  Future<LatLng> getMyLocation() async {
    final url =
        'https://termproject-81a0e-default-rtdb.firebaseio.com/users/$_userId.json?auth=$_token';
    try {
      final response = await http.get(
        url,

      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> data=responseData.values.toList();
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _myLocation=LatLng(data[1]['Lat'],data[1]['Long']);
      return _myLocation;



      notifyListeners();
    } catch (error) {
      return null;
      //throw error;
    }



  }
  Future<void> getMoreInformation() async {
    final url =
        'https://termproject-81a0e-default-rtdb.firebaseio.com/users/$_userId.json?auth=$_token';
    try {
      final response = await http.get(
        url,

      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      List<dynamic> data=responseData.values.toList();
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _name=data[0]['name'];
      _phone=data[0]['phone'];


      notifyListeners();
    } catch (error) {
      throw error;
    }



  }

  String get token {
   // return _token;
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;


  }

  String get userId {
    return _userId;
  }
  Future<void> addMoreInformation(String name ,String phone,String token,String id) async {
    final url =
        'https://termproject-81a0e-default-rtdb.firebaseio.com/users/$id.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'name': name,
            'phone': phone,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }


      notifyListeners();
    } catch (error) {
      throw error;
    }

  }
  Future<void> _authenticate(
      String email, String password, String urlSegment,{String name =' ',String phone=' '}) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyBJi9V1w8dvUYxslU9vwl3LFGuRH4LXz2E';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      if (urlSegment == 'signupNewUser') {
        addMoreInformation(name, phone,responseData['idToken'],responseData['localId']);
      }
      if(urlSegment=='verifyPassword') {
        SharedPreferences _pref=await SharedPreferences.getInstance();
        _pref.setString('token', responseData['idToken']);
        _pref.setString('userId', responseData['localId']);
       // _pref.setString('mode','false');
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(
              responseData['expiresIn'],
            ),
          ),
        );
        _pref.setString('expiryDate', _expiryDate.toString());
         _token=responseData['idToken'];
         _userId=responseData['localId'];
         _expiryDate = DateTime.now().add(
           Duration(
             seconds: int.parse(
               responseData['expiresIn'],
             ),
           ),
         );
        await getMoreInformation();
         //print("myid"+_userId);





        _autoLogout();
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }

  }

  Future<void> signup(String email, String password,String uname ,String uphone) async {
     return _authenticate(email, password, 'signupNewUser',name: uname,phone:uphone );

  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');

  }

  void logout() async{
    _token = null;
    _userId = null;
    _phone=null;
    _name=null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();

    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);

  }
}

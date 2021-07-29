import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class CartItem {
  final String name;
  final double price;
  final int quantity;


  CartItem({
    @required this.name,
    @required this.price,
    @required this.quantity,

  });
}

class Cart with ChangeNotifier {
  String _userId;
  String _token;
  setUser(t,uId){
    _userId=uId;
    _token=t;
    //print("1111tokken"+_token);

  }
  String _restaurantID;
  String get restaurantID {
    return _restaurantID;

  }
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }
  bool is_contained(String name){
    if (_items.containsKey(name)){
      return true;
    }else {
      return false;
    }
    notifyListeners();

  }
  Map<String,dynamic> addItems() {
    Map<String,dynamic> x={};
    items.forEach((key, value) {
      x.putIfAbsent(key, () => {
        'name': value.name,
        'price': value.price,
        'quantity': value.quantity,
      });


    
    /*items.map((key, value) {
      x.putIfAbsent(key, () => {
        'name': value.name,
        'price': value.price,
        'quantity': value.quantity,
      });
      x.putIfAbsent(value.name,
              () =>{
        'name': value.name,
        'price': value.price,
        'quantity': value.quantity,
      }
    );*/
    });
    Map<String,dynamic> y={};
    y.putIfAbsent('information', () => {
      'restaurantId':_restaurantID,
      'datetime':DateTime.now().toString(),
      'is_received':false

    });
    y.putIfAbsent("items", () => x);
    return y;

    notifyListeners();
  }


  void addItem(
      String restaurantId,
      String productName,
      double price,

      ) {
      _items.putIfAbsent(
        productName,
            () => CartItem(
          name: productName,
          price: price,
          quantity: 1,
        ),
      );
      _restaurantID=restaurantId;

    notifyListeners();
  }

  void removeItem(String productName) {
    _items.remove(productName);
    if(_items.length==0){
      _restaurantID=null;
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
              (existingCartItem) => CartItem(
            name: existingCartItem.name,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity - 1,
          ));
    } else {
      _items.remove(productId);
      if(_items.length==0){
        _restaurantID=null;
      }
    }
    notifyListeners();
  }
  void addSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

      _items.update(
          productId,
              (existingCartItem) => CartItem(
            name: existingCartItem.name,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity + 1,
          ));

    notifyListeners();
  }

  void clear() {
    _restaurantID=null;
    _items = {};
    notifyListeners();
  }


  Future<void> uploadCart() async {
    Map<String,dynamic> x=addItems();

    final url =
        'https://termproject-81a0e-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_token';

    try {
      final response = await http.post(
        url,


      body: json.encode(
          x
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
}

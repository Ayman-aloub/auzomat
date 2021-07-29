import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mapfollow/provider/cart.dart';

import '../models/http_exception.dart';
class order {
   final DateTime orderTime;
   final String restaurantID;
   final String orderID;
   final bool is_received;
   final List< CartItem> items ;
   double get totalAmount {
     var total = 0.0;
     items.forEach((cartItem) {
       total += cartItem.price * cartItem.quantity;
     });
     return total;
   }
   order(this.items,this.restaurantID,this.is_received,this.orderTime,this.orderID);






}
class orders with ChangeNotifier {
   List<order> _myOrders=[];
  String _userId;
  String _token;
  setUser(t,uId){
    _userId=uId;
    _token=t;
    //print("1111tokken"+_token);

  }
  List<order> get items {
    return [..._myOrders];

  }




  Future<void> downloadOrders() async {
    final List<order> load=[];
    //_myOrders.clear();
    //Map<String,dynamic> x=addItems();

    final url =
        'https://termproject-81a0e-default-rtdb.firebaseio.com/orders/$_userId.json?auth=$_token';

    try {
      final response = await http.get(
        url,
      );
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData['error'] != null) {
        throw HttpException(extractedData['error']['message']);
      }
      //print(extractedData);
      extractedData.forEach((orderid, value  ) {
        //print(value['information']['restaurantId']);
        Map<String, dynamic> currentItems=value['items'];
        final List< CartItem> toitems =[];
        //currentItems.map((key, value) => print(value['name']));
        currentItems.forEach((itemkey, itemvalue) {
          toitems.add(new  CartItem(
            name: itemvalue['name'],
            price: itemvalue['price'],
            quantity: itemvalue['quantity'],
          ),);

        });
        //print(toitems[0].name);
        //toitems.map((e) => print('tttttt'));
        load.add(new order(toitems, value['information']['restaurantId'], value['information']['is_received'], DateTime.parse(value['information']['datetime']), orderid));



      });
      _myOrders=load;

      //print('tttttt');
     // _myOrders[0].items.forEach((element) {print(element.name);});
    //print(_myOrders[0].orderTime);



      notifyListeners();
    } catch (error) {
      throw error;
    }

  }
  Future<void> deleteProduct(String id) async {
    final url =
        'https://termproject-81a0e-default-rtdb.firebaseio.com/orders/$_userId/$id.json?auth=$_token';
    final existingProductIndex = _myOrders.indexWhere((prod) => prod.orderID == id);
    var existingProduct = _myOrders[existingProductIndex];
    _myOrders.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _myOrders.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

}

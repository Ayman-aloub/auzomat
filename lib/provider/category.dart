import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mapfollow/provider/restaurant.dart';

class foodItem {
  final String name;
  final int price;

  foodItem({
    @required this.name,
    @required this.price
  });
}
class  searchItem{
  final int index;
  final String name;
  final String restaurant_ID;

  searchItem({
    @required this.index,
    @required this.name,
    @required this.restaurant_ID
  });
}
class categoryItem {
  final String name;
  final String restaurant_ID;
  final List<foodItem> products;

  categoryItem({
    @required this.name,
    @required this.restaurant_ID,
    @required this.products,

  });
}
class Meals with ChangeNotifier {
  List<searchItem> _searchloadedOrders = [];
  List<categoryItem> _categories = [];
  String _userId;
  String _token;
  setUser(t,uId){
    _userId=uId;
    _token=t;
    //print("1111tokken"+_token);

  }
  //final String authToken;
  //final String userId;

  //Meals(this.authToken, this.userId);

  List<categoryItem> get categories {
    return [..._categories];
  }


  Future<void> fetchAndSetOrders(String restautantID) async {
    //print(restautantID);
    final url = 'https://termproject-81a0e-default-rtdb.firebaseio.com/categories/$restautantID.json?auth=$_token';
    final response = await http.get(url);
    final List<categoryItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
   //print(extractedData);
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {


     loadedOrders.add(
        categoryItem(
          name: orderId,
          restaurant_ID: restautantID,
          products: (orderData as List<dynamic>)
              .map(

                (item) => foodItem(
              price: item['price'],
              name: item['name'],
            ),
          )
              .toList(),
        ),
      );
    });
    _categories = loadedOrders.reversed.toList();
    notifyListeners();
  }
  Future<List<searchItem>> getUserSuggestion(String query) async {
    //print(restautantID);
    if(_searchloadedOrders.isEmpty) {
      final url = 'https://termproject-81a0e-default-rtdb.firebaseio.com/categories.json?auth=$_token';
      final response = await http.get(url);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      if (extractedData == null) {
        return [];
      }


      extractedData.forEach((resId, meals) {
        Map<String, dynamic> currentItems = meals as Map<String, dynamic>;
        print(currentItems.keys.toString());
        List<String> mykeys = currentItems.keys.toList();

        for (var i = 0; i < mykeys.length; i++) {
          print(resId);
          _searchloadedOrders.add(
            searchItem(
                index: mykeys.length-i-1,
                restaurant_ID: resId,
                name: mykeys[i].toString()
            ),
          );
        }
      });
    }
    return _searchloadedOrders.where((user) {
      final userLower = user.name.toLowerCase();
      final queryLower = query.toLowerCase();

      return userLower.contains(queryLower);
    }).toList();
    //return [...loadedOrders];
  }



}


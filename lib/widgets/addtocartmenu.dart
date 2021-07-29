import 'package:flutter/material.dart';
import 'package:mapfollow/provider/cart.dart';
import 'package:mapfollow/screens/cart_screen.dart';
import 'package:provider/provider.dart';
class AddToCartMenu extends StatefulWidget {
  CartItem item;

  AddToCartMenu(this.item);

  @override
  _AddToCartMenuState createState() => _AddToCartMenuState();
}

class _AddToCartMenuState extends State<AddToCartMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {



                Provider.of<Cart>(context, listen: false).addSingleItem(widget.item.name);
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>FoodOrderPage()));


            },
            icon: Icon(Icons.add),
            color: Color(0xFFfd2c2c),
            iconSize: 18,
          ),

          InkWell(
            child: Container(
              width: 100.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: Color(0xFFFF7643),
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Text(
                  ' ${widget.item.quantity}',
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {

                Provider.of<Cart>(context, listen: false).removeSingleItem(widget.item.name);
                //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>FoodOrderPage()));


            },
            icon: Icon(Icons.remove),
            color: Colors.black,
            iconSize: 18,
          ),

        ],
      ),
    );
  }
}
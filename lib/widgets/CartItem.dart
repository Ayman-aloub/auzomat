import 'package:flutter/material.dart';
import 'package:mapfollow/provider/cart.dart';
import 'package:mapfollow/widgets/addtocartmenu.dart';
import 'package:provider/provider.dart';
class cartitem extends StatefulWidget {

  CartItem item;
  cartitem(this.item);

  @override
  _cartitemState createState() => _cartitemState();
}

class _cartitemState extends State<cartitem> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dismissible(
        background: Container(
          color: Colors.red,
          child:Center(child:Icon(Icons.delete,size: 60, color: Colors.white)),


        ),
        key: UniqueKey(),
        direction: DismissDirection.startToEnd,
        onDismissed: (DismissDirection direction){
          Provider.of<Cart>(context, listen: false).removeItem(widget.item.name);
          setState(() {


          });
        },
        child: Column(
          children: [
            Container(
              width: 250,
              //height: 130,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Color(0xFFfae3e2).withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ]),
              child: Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[

                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "الوجبة:${widget.item.name}",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF3a3a3b),
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: Text(
                                        "السعر:${widget.item.price*widget.item.quantity}(ج.م)",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF3a3a3b),
                                            fontWeight: FontWeight.w400),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),

                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              alignment: Alignment.center,
                              child: AddToCartMenu(widget.item),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

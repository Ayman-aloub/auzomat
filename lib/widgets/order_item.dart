import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapfollow/provider/orders.dart';
import 'package:mapfollow/provider/restaurant.dart';
import 'package:mapfollow/provider/restaurants.dart';
import 'package:mapfollow/screens/oderItemsScreen.dart';
import 'package:provider/provider.dart';
class order_item extends StatelessWidget {
  order item;
  restaurant res;
  order_item(order curitem){
    this.item=curitem;
  }
  @override
  Widget build(BuildContext context) {
    res=Provider.of<restaurants>(context).findById(item.restaurantID);
    return InkWell(
        key: UniqueKey(),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>orderItemsScreen(item,res)));
      },
      child: Column(
        children: [
          ListTile(
            leading: Card(

              child: Container(
                width: 70,
                height: 150,
                foregroundDecoration:  BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          res.imageUrl
                      ),
                      fit: BoxFit.fill),
                ),
              ),
            ),
            //dense: true,
            title: Text(res.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('جاري التوصيل',style: TextStyle(color: Colors.red),),
                Text('  ${item.orderTime.hour}:${item.orderTime.minute}  ${item.orderTime.day}/${item.orderTime.month}/${item.orderTime.year}'),
              ],
            ),
            isThreeLine: true ,
          ),
          Divider(),
        ],
      ),

        );
  }
}

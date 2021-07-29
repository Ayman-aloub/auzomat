import 'package:flutter/material.dart';
import 'package:mapfollow/provider/orders.dart';
import 'package:mapfollow/widgets/app_drawer.dart';
import 'package:mapfollow/widgets/order_item.dart';
import 'package:provider/provider.dart';
class order_screen extends StatefulWidget {
  @override
  _order_screenState createState() => _order_screenState();
}

class _order_screenState extends State<order_screen> {
  var is_loading=true;
  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Provider.of<orders>(context, listen: false).downloadOrders().then((value){
      setState(() {
        is_loading=false;
      });
    }).catchError((onError){
      setState(() {
        is_loading=false;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    var mywidth=MediaQuery.of(context).size.width;
    return SafeArea(
      child: Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:Theme.of(context).backgroundColor,
            title:  Center(child: const Text('طلباتك')),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,

              ),
              onPressed: () => Navigator.of(context).pop(),
            ),


          ),
          endDrawer: AppDrawer(),
          body: is_loading?Center(child: CircularProgressIndicator(),):Consumer<orders>(
            builder: (ctx,dataSnapshot,child){

                  // ...
                  // Do error handling stuff
                 // return Center(child: Text('لا يوجد طلبات',style:TextStyle(fontSize: 20,color: Color(0xFFFF7643),fontWeight: FontWeight.bold),),);

                  return dataSnapshot.items.length>0?GridView.count(
                    crossAxisCount:mywidth>700?2:1 ,
                    childAspectRatio: 3,
                    crossAxisSpacing: 0.5,
                    mainAxisSpacing: 0.5,
                    children: dataSnapshot.items
                        .map((tx) => order_item(tx))
                        .toList(),
                  ):Center(
                    child: Text('عفوا لا يوجد طلبات سابقة',
                      style:TextStyle(fontSize: 20,color: Color(0xFFFF7643),fontWeight: FontWeight.bold),),
                  );
                })

          ),
        ),
      );

  }
}

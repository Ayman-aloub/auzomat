import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapfollow/provider/auth.dart';

import 'package:mapfollow/provider/cart.dart';
import 'package:mapfollow/provider/orders.dart';
import 'package:mapfollow/provider/restaurant.dart';
import 'package:mapfollow/provider/restaurants.dart';
import 'package:mapfollow/widgets/CartItem.dart';
import 'package:mapfollow/widgets/TotalCalculationWidget.dart';
import 'package:mapfollow/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class orderItemsScreen extends StatefulWidget {
  order orderItem;
  restaurant resInfo;
  orderItemsScreen(this.orderItem,this.resInfo);

  @override
  _orderItemsScreenState createState() => _orderItemsScreenState();
}

class _orderItemsScreenState extends State<orderItemsScreen> {

  @override
  void initState() {
    //widget.orderItem.items.forEach((element) {print(element.name);});


    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    //var is_loading=false;
    //var mywidth=MediaQuery.of(context).size.width;
    //final myheight=MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top;
    //final cart = Provider.of<Cart>(context).items;
    //final restaurant resInfo=widget.cart.length>0?Provider.of<restaurants>(context, listen: false).items.firstWhere((element) => element.id==Provider.of<Cart>(context, listen: false).restaurantID):restaurant(id: null, name: null, description: null, price: null, time: null, location: null, imageUrl: null);
    return Directionality(
      textDirection:  TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,

                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Center(
                child: Text(
                  "الطلبات",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              //brightness: Brightness.light,

            ),
            endDrawer: AppDrawer(),
            body: SingleChildScrollView(
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Card(

                      child: Container(
                        width: 70,
                        height: 150,
                        foregroundDecoration:  BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                widget.resInfo.imageUrl
                              ),
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    //dense: true,
                    title: Text(widget.resInfo.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('جاري التوصيل',style: TextStyle(color: Colors.red),),
                        Text('  ${widget.orderItem.orderTime.hour}:${widget.orderItem.orderTime.minute}  ${widget.orderItem.orderTime.day}/${widget.orderItem.orderTime.month}/${widget.orderItem.orderTime.year}'),
                      ],
                    ),
                    isThreeLine: true ,
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.shop,size: 60,),
                    isThreeLine: true,
                    title: Text('معلومات عن الطالب',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text('الاسم : ${Provider.of<Auth>(context,listen: false).name}'),
                      Text('رقم الهاتف : ${Provider.of<Auth>(context,listen: false).phone}'),

                    ],),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('تفاصيل الطلب',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                    ],
                  ),
                      for(var i in widget.orderItem.items) Container(
                        height: 40,
                        child:Padding(
                          padding: const EdgeInsets.only(left:10.0, right: 10),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('x${i.quantity}  ${i.name}'),
                            Text('${i.quantity*i.price}(ج.م)'),
                          ],
                      ),
                        ),),

                       Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('الايصال',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
                    ],
                  ),
                  Container(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(left:10.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('سعر الطلبات' ,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('${widget.orderItem.totalAmount}(ج.م)'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(left:10.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('سعر الخدمة' ,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('${widget.resInfo.price}(ج.م)'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    child: Padding(
                      padding: const EdgeInsets.only(left:10.0, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('الاجمالي' ,style: TextStyle(fontWeight: FontWeight.bold),),
                          Text('${widget.resInfo.price+widget.orderItem.totalAmount}(ج.م)'),
                        ],
                      ),
                    ),
                  ),





                       /*widget.orderItem.items.length>0?ListView(
                        children: widget.orderItem.items.map((e) => Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('${e.quantity}x  ${e.name}'),
                            Text('${e.quantity*e.price}(ج.م)'),
                          ],
                        )).toList(),
                      ):Center(
                        child: Text('عفوا لا يوجد مطاعم متوفرة قريبة منك',
                          style:TextStyle(fontSize: 20,color: Color(0xFFFF7643)),),
                      ),*/






                ],
              ),
            ), /*is_loading?Center(child: CircularProgressIndicator()):widget.cart.length==0?Center(
              child: Text('عفوا السلة فارغة',
                style:TextStyle(fontSize: 20,color: Color(0xFFFF7643),fontWeight: FontWeight.bold),),
            ):SingleChildScrollView(

              child: Container(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      /*Container(
                  height: MediaQuery.of(context).orientation==Orientation.portrait? ( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.05:( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.05,
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          "المطعم:${resInfo.name}",
                          style: TextStyle(
                              fontSize: MediaQuery.of(context).orientation==Orientation.portrait? ( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.03:( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.03,
                              color: Color(0xFF3a3a3b),
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                        ),
                      ),*/
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        height:  myheight*0.6,
                        child: GridView.count(
                          crossAxisCount:mywidth>600?2:1 ,
                          childAspectRatio: 2,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                          children: widget.cart.values.map(
                                  ( value,) => cartitem(value)).toList(),
                        ),
                      ),


                      Container(
                          height: myheight*0.27,
                          child: SingleChildScrollView(child: TotalCalculationWidget(widget.resInfo,widget.total))),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        //height: MediaQuery.of(context).orientation==Orientation.portrait?( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.3:( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.3,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: FlatButton(
                          child: Text('تم الاستلام', style: TextStyle(fontSize: 24)),
                          onPressed: ()    async {
                            try {
                              await Provider.of<orders>(context, listen: false)
                                  .deleteProduct(widget.orderID);
                            } catch (error) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Deleting failed!', textAlign: TextAlign.center,),
                                ),
                              );
                            }
                            Navigator.pop(context);


                          },
                          color: Color(0xFFFF7643),
                          textColor: Colors.white,
                        ),
                      ),


                    ],
                  )
              ),
            )*/
        ),
      ),
    );
  }
}
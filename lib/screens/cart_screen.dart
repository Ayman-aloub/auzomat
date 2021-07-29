import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapfollow/provider/cart.dart';
import 'package:mapfollow/provider/restaurant.dart';
import 'package:mapfollow/provider/restaurants.dart';
import 'package:mapfollow/widgets/CartItem.dart';
import 'package:mapfollow/widgets/TotalCalculationWidget.dart';
import 'package:mapfollow/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class FoodOrderPage extends StatefulWidget {

  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {

  

  @override
  Widget build(BuildContext context) {
    var is_loading=false;
    var mywidth=MediaQuery.of(context).size.width;
    final myheight=MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top;
    final cart = Provider.of<Cart>(context).items;
    final restaurant resInfo=cart.length>0?Provider.of<restaurants>(context, listen: false).items.firstWhere((element) => element.id==Provider.of<Cart>(context, listen: false).restaurantID):restaurant(id: null, name: null, description: null, price: null, time: null, location: null, imageUrl: null);
    return Directionality(
      textDirection:  TextDirection.rtl,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFFFF7643),
              elevation: 0,
              /*actions: [
                endDrawer: AppDrawer(),
                PopupMenuButton(
                  onSelected: (_) {
                    setState(() {
                      Provider.of<Cart>(context).clear();

                    });
                  },
                  icon: Icon(
                    Icons.more_vert,
                  ),
                  itemBuilder: (_) => [

                    PopupMenuItem(
                      child: Text('تفريغ السلة'),
                      //value: true,
                    ),
                  ],
                ),
              ],*/
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,

                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Center(
                child: Text(
                  "السلة",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              brightness: Brightness.light,

            ),
            endDrawer: AppDrawer(),
            body:  is_loading?Center(child: CircularProgressIndicator()):cart.length==0?Center(
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
                      children: cart.values.map(
                              ( value,) => cartitem(value)).toList(),
                    ),
                  ),


                      Container(
                          height: myheight*0.27,
                          child: SingleChildScrollView(child: TotalCalculationWidget(resInfo))),
                      SizedBox(
                        height: 3,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        //height: MediaQuery.of(context).orientation==Orientation.portrait?( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.3:( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.3,
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height*0.06,
                        child: FlatButton(
                          child: Text('اطلب من هناا', style: TextStyle(fontSize: 24)),
                          onPressed: ()    async {
                            setState(() {
                              is_loading=true;
                            });

                            await Provider.of<Cart>(context, listen: false).uploadCart();
                            Provider.of<Cart>(context, listen: false).clear();
                            setState(() {
                              is_loading=false;
                            });

                          },
                          color: Color(0xFFFF7643),
                          textColor: Colors.white,
                        ),
                      ),


                    ],
                  )
                ),
            )
            ),
      ),
    );
  }
}
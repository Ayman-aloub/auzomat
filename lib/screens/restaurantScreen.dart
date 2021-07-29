import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapfollow/provider/category.dart';
import 'package:mapfollow/provider/orders.dart';
import 'package:mapfollow/provider/restaurant.dart';
import 'package:mapfollow/provider/restaurants.dart';
import 'package:mapfollow/widgets/HomeAppDrawer.dart';
import 'package:mapfollow/widgets/app_drawer.dart';
import 'package:mapfollow/widgets/restaurant_item.dart';
import 'package:mapfollow/widgets/restaurant_list.dart';
import 'package:provider/provider.dart';

class restaurantScreen extends StatefulWidget {
  /*LatLng p;
  restaurantScreen(this.p);*/





  @override
  _restaurantScreenState createState() => _restaurantScreenState();
}

class _restaurantScreenState extends State<restaurantScreen> {
  var is_loading=true;


  
  List<restaurant> _restaurantsitems=[] ;

Future<void> loadItems(BuildContext context) async{
  if(Provider.of<restaurants>(context ,listen: false).items.length==0){
    await Provider.of<restaurants>(context ,listen: false).fetchAndSetProducts();

  }
  /*await Provider.of<restaurants>(context, listen: false).fetchcurrentitems(widget.p);
 // _restaurantsitems=Provider.of<restaurants>(context).currentitems;
 _restaurantsitems=Provider.of<restaurants>(context, listen: false).currentitems;*/
  _restaurantsitems=Provider.of<restaurants>(context, listen: false).items;




}


  @override
  void didChangeDependencies() {
   //Provider.of<orders>(context ,listen: false).downloadOrders().then((value) => null);
   /*Provider.of<restaurants>(context ,listen: false).fetchAndSetProducts().then((value){


   }).catchError((onError){});
   if(Provider.of<restaurants>(context ,listen: false).items.length>0){
     Provider.of<restaurants>(context, listen: false).fetchcurrentitems(widget.p).then((value){
       _restaurantsitems=Provider.of<restaurants>(context, listen: false).currentitems;
       setState(() {
         is_loading=false;
       });
     }).catchError((onError){});




   }*/
   loadItems(context).then((value){
     setState(() {
     is_loading=false;
   });
   }).catchError((onError){});





    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:Theme.of(context).backgroundColor,
            title:  const Text('المطاعم'),


          ),
          endDrawer: homeAppDrawer(),

          body:/*is_loading?Center(child: CircularProgressIndicator()):FutureBuilder(
            future: Provider.of<restaurants>(context, listen: false).fetchcurrentitems(widget.p),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  // ...
                  // Do error handling stuff
                  return Center(
                    child: Text('An error occurred!'),
                  );
                } else {
                  _restaurantsitems=Provider.of<restaurants>(context).currentitems;
                  return _restaurantsitems.length>0?ListView(
                    children: _restaurantsitems
                        .map((tx) => restaurantItem(
                      key: ValueKey(tx.id),
                      transaction: tx,

                    ))
                        .toList(),
                  ):Center(
                    child: Text('عفوا لا يوجد مطاعم متوفرة قريبة منك',
                      style:TextStyle(fontSize: 20,color: Color(0xFFFF7643),fontWeight: FontWeight.bold),),
                  );
                }
              }
            },
          ),*/
          is_loading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Directionality(
            textDirection: TextDirection.rtl,

              child: _restaurantsitems.length>0?ListView(
                children: _restaurantsitems
                    .map((tx) => restaurantItem(
                  key: ValueKey(tx.id),
                  transaction: tx,
                ))
                    .toList(),
              ):Center(
                child: Text('عفوا لا يوجد مطاعم متوفرة قريبة منك',
                  style:TextStyle(fontSize: 20,color: Color(0xFFFF7643)),),
              ),


          ),

        ),
      ),
    );
  }
}

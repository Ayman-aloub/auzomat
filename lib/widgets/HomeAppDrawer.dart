import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:location/location.dart';
import 'package:mapfollow/provider/auth.dart';
import 'package:mapfollow/provider/cart.dart';
import 'package:mapfollow/provider/thems.dart';
import 'package:mapfollow/screens/SearchScreen.dart';
import 'package:mapfollow/screens/cart_screen.dart';
import 'package:mapfollow/screens/enable_location.dart';
import 'package:mapfollow/screens/logn.dart';
import 'package:mapfollow/screens/order_screen.dart';
import 'package:mapfollow/screens/restaurantScreen.dart';
import 'package:mapfollow/services/geolocator_service.dart';
import 'package:mapfollow/screens/map.dart';
import 'package:mapfollow/widgets/badge.dart';
import 'package:provider/provider.dart';



class homeAppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _showChart=Provider.of<themes>(context,listen: false).is_dart;
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('مرحبا بكم'),
            backgroundColor:Color(0xFFFF7643),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('البحث'),
            onTap: () async {

              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>search()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('تحديد الموقع'),
            onTap: () async {

              Navigator.pop(context);

              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>Map()));
            },
          ),
          Divider(),
          ListTile(
            leading: Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child:  Icon(
                Icons.shopping_cart,
              ),

            ),
            title: Text('السلة'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>FoodOrderPage()));

            },
          ),
          Divider(),
          ListTile(
            leading:  Icon(
                Icons.add_alert,
              ),

            title: Text('الطلبات'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (_)=>order_screen()));



            },
          ),

          Divider(),
          ListTile(
            leading: Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) {
                if(!val){
                  //_showChart=false;
                  Provider.of<themes>(context,listen:false).setlightMode();

                }else{
                  Navigator.pop(context);
                  Provider.of<themes>(context,listen:false).setDartMode();
                  //_showChart=true;

                }
              },
            ),
            title: Text('الوضع المظلم'),

          ),
          Divider(),
          /*ListTile(
            leading: Icon(Icons.restaurant),
            title: Text('لمطاعم'),
            onTap: () {
              Navigator.of(context).pop();

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              LatLng p=Provider.of<Auth>(context,listen: false).myLocation;
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) =>restaurantScreen(p)));
            },
          ),
          Divider(),*/
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('تسحيل الخروج'),
            onTap: () {
              Navigator.of(context).pop();

              // Navigator.of(context)
              //     .pushReplacementNamed(UserProductsScreen.routeName);
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>login()));
            },
          ),

        ],
      ),
    );
  }
}

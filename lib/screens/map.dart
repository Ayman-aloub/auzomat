import 'dart:async';


import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mapfollow/provider/auth.dart';
import 'package:mapfollow/provider/restaurants.dart';
import 'package:mapfollow/screens/enable_location.dart';
import 'package:mapfollow/screens/restaurantScreen.dart';
import 'package:mapfollow/services/geolocator_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Map extends StatefulWidget {
  var saveLocation;
  Map([this.saveLocation=false]);

  static const routeName = '/map';



  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<Map> {
  final GeolocatorService geoService = GeolocatorService();


  Completer<GoogleMapController> _controller = Completer();
  String searchAddr;
  List<Marker> markers;
  LatLng p;
  bool is_apload=false;
  LatLng inti;



  @override void didChangeDependencies() {
    //inti = LatLng(41.676388,-86.250275) ;
    //41.676388,-86.250275
    markers=[];
    //final geoService = GeolocatorService();
    //Location location = new Location();
    markers=[];
    enablelocation().then((value){
      inti = LatLng(value.latitude,value.longitude) ;
      p=inti;
      setState(() {
        is_apload= true;
      });

    }).catchError((onError){});


    /*
    //bool _serviceEnabled;
    //PermissionStatus _permissionGranted;
    location.hasPermission().then((_permissionGranted ) => {
      if (_permissionGranted == PermissionStatus.denied){
        location.requestPermission().then((value) => {


        });

      }
    location.serviceEnabled().then((value) => {});


    });




    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return runApp(enableLocation());
      }
    }
*/



    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }


  @override
  void initState() {
    /*geoService.getCurrentLocation().listen((position) {
      centerScreen(position);
    });*/

     /*p=LatLng(widget.initialPosition.latitude,
        widget.initialPosition.longitude);*/


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: !is_apload?Center(child: CircularProgressIndicator(),):Stack(
                  children: [
                    GoogleMap(
                      onTap: (mkposition){
                        Marker mk=Marker(markerId: MarkerId('orderPosition'),position: mkposition);
                        // print("latitude"+(mkposition.latitude).toString());
                        //print("longitude"+(mkposition.longitude).toString());
                        print('marker :${mkposition.latitude}');

                        setState(() {
                          p=LatLng(mkposition.latitude,mkposition.longitude);
                          markers.add(mk);

                        });
                      },
                      markers:Set.from(markers),



                      initialCameraPosition: CameraPosition(
                          target: inti/*LatLng(/*widget.initialPosition*/inti.latitude,
                      /*widget.initialPosition*/inti.longitude)*/,
                          zoom: 17.0),
                      mapType: MapType.normal,


                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },

                    ),
                    Positioned(
                      top: 30.0,
                      right: 15.0,
                      left: 15.0,
                      child:Container(
                        height: 50.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0), color: Colors.white,
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Enter Address',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                            suffixIcon: IconButton(
                                icon: Icon(Icons.search), color: Color(0xFFFF7643),
                                onPressed: searchandNavigate,
                                iconSize: 30.0),

                          ),
                          onChanged: (val) {
                            setState(() {
                              searchAddr = val;
                            });
                          },


                        ),

                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height*0.07,
                        child: FlatButton(
                          child: Text('وصل هنا', style: TextStyle(fontSize: 30)),
                          onPressed: ()    async {

                            /*if(is_apload==false){
                        if(!Provider.of<Auth>(context,listen: false).isAuth){
                          SharedPreferences value=await SharedPreferences.getInstance();
                          var token = value.getString('token');
                          var userid =value.getString('userId');
                          var expire = value.getString('expiryDate');
                          Provider.of<Auth>(context,listen: false).setToken(token, userid, DateTime.parse(expire) );
                        }

                      print("ssssss");
                      is_apload=true;


                      }
                      final ref = FirebaseStorage.instance.ref().child('picture2.jpg');
                      String image_url=await ref.getDownloadURL();
                      print("llllllll"+image_url);*/
                            if(widget.saveLocation){
                              Provider.of<Auth>(context,listen: false).addMyLocation(p);
                            }

                            Provider.of<Auth>(context,listen: false).setLocation(p);

                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) =>restaurantScreen(/*p*/)));


                            /*await Provider.of<restaurants>(context, listen: false)
                          .fetchcurrentitems(p);
                      if(Provider.of<restaurants>(context, listen: false).currentitems.isEmpty){
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) =>
                                Directionality(textDirection: TextDirection.rtl,
                                    child: restaurantScreen())));
                    }else{
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (ctx) =>
                                Directionality(textDirection: TextDirection.rtl,
                                    child: restaurantScreen())));
                      }*/
                          },
                          color: Color(0xFFFF7643),
                          textColor: Colors.white,
                        ),
                      ),
                    ),

                  ])

        ),
    );

  }

  Future<void> centerScreen(Position position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 18.0)));
  }
  Future<Position> enablelocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    /*PermissionStatus _permissionGranted;
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>enable_location()));

      }
    }*/


    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>enable_location()));
      }
    }


    Position value=await geoService.getInitialLocation();
    //inti = LatLng(value.latitude,value.longitude) ;
    //p=inti;
    return value;

  }
  Future<void> searchandNavigate() async {
    final GoogleMapController controller = await _controller.future;
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
          LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 17.0)));


    }

    );




  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapfollow/provider/restaurants.dart';
import 'package:mapfollow/screens/regi_page.dart';
import 'package:mapfollow/screens/restaurantScreen.dart';
import 'package:mapfollow/services/geolocator_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/auth.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';
import '../screens/map.dart';

import '../utils/color.dart';
import '../utils/constants.dart';
import '../widgets/btn_widget.dart';
import '../widgets/herder_container.dart';


class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  final _formkey = GlobalKey<FormState>();
  bool visible=true;
  bool isLogin =false;


  TextEditingController _emailcontroller = TextEditingController();

  TextEditingController _passwordcontroller = TextEditingController();



  void _showErrorDialog(String message,BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {


    _emailcontroller.dispose();

    _passwordcontroller.dispose();



    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            children: <Widget>[
              HeaderContainer("تسجيل الدخول"),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Form(
                    key: _formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailcontroller,
                            decoration: kTextFieldDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Email',
                              hintText: 'Enter Your Email',
                            ),
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Please Fill Email Input';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _passwordcontroller,
                            obscureText: visible,
                            decoration: kTextFieldDecoration.copyWith(
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              labelText: 'Password',

                              hintText: 'Enter Your Password',
                              suffixIcon: IconButton(
                                icon:new Icon(Icons.visibility),
                                onPressed: ()=>{setState((){visible=!visible;}) },

                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty || value.length < 6) {
                                return 'Please Fill Password Input';
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),



                             Container(
                               width: double.infinity,
                               height: MediaQuery.of(context).size.height*0.08,


                               child: RaisedButton(
                                 shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(28.0),
                                     side: BorderSide(color: Color(0xFFFF7643))
                                 ),



                                color: Color(0xFFFF7643),
                                child: isLogin ? CircularProgressIndicator( ):Text(
                                  'logn in',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  try{
                                    if (_formkey.currentState.validate()) {
                                      setState(() {
                                        isLogin = true;
                                      });
                                      var result = await Provider.of<Auth>(
                                          context, listen: false).login(
                                          _emailcontroller.text,
                                          _passwordcontroller.text
                                      );
                                      LatLng x=await Provider.of<Auth>(
                                          context, listen: false).getMyLocation();
                                      if(x!=null){
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (_) =>restaurantScreen() /*Map()*/));

                                      }else{
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (_) => Map(true)));
                                      }

                                      setState(() {
                                        isLogin = false;
                                      });
                                    }
//                              getmap();



                                    //final geoService = GeolocatorService();

                                    //final position =  await geoService.getInitialLocation();


                                    /*SharedPreferences value=await SharedPreferences.getInstance();

                                    var token = value.getString('token');
                                    var userid =value.getString('userId');
                                    var expire = value.getString('expiryDate');
                                    Provider.of<Auth>(context,listen: false).setToken(token, userid, DateTime.parse(expire) );

                                     */
                                    //Provider.of<Auth>(context,listen: false).setToken(token, userid, DateTime.parse(expire) );

                                    //if(Provider.of<Auth>(context,listen: false).isAuth) {

                                    //}

                                  }on HttpException catch (error) {
                                    var errorMessage = 'Authentication failed';
                                    if (error.toString().contains('EMAIL_EXISTS')) {
                                      errorMessage = 'This email address is already in use.';
                                    } else if (error.toString().contains('INVALID_EMAIL')) {
                                      errorMessage = 'This is not a valid email address';
                                    } else if (error.toString().contains('WEAK_PASSWORD')) {
                                      errorMessage = 'This password is too weak.';
                                    } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
                                      errorMessage = 'Could not find a user with that email.';
                                    } else if (error.toString().contains('INVALID_PASSWORD')) {
                                      errorMessage = 'Invalid password.';
                                    }
                                    _showErrorDialog(errorMessage,context);
                                    setState(() {
                                      isLogin = false;
                                    });
                                  } catch (error) {
                                    const errorMessage =
                                        'Could not authenticate you. Please try again later.';
                                    _showErrorDialog(error.toString(),context);
                                    setState(() {
                                      isLogin = false;
                                    });
                                  }
                                },
                            ),
                             ),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "Don't have an account ? ",
                        style: TextStyle(color: Colors.black)),
                    TextSpan(

                          text: "Registor",
                          style: TextStyle(color: orangeColors)),


                  ]),
                ),
                onTap: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>RegPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}

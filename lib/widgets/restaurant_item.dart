import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapfollow/provider/restaurant.dart';
import 'package:mapfollow/screens/meals.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class restaurantItem extends StatefulWidget {
  const restaurantItem({
    @required Key key,
    @required this.transaction,


  }) : super(key: key);

  final restaurant transaction;


  @override
  _restaurantItemState createState() => _restaurantItemState();
}

class _restaurantItemState extends State<restaurantItem> {
  Color _bgColor;
  var image=false;


  @override
  void initState() {


    const availableColors = [
      Colors.red,
      Colors.black,
      Colors.blue,
      Colors.purple,
    ];

    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.transaction.imageUrl);
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>MealsScreen(widget.transaction.id)));

          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _bgColor,
              radius: 30,
              backgroundImage:NetworkImage(widget.transaction.imageUrl) ,


            ),
            title: Text(
              widget.transaction.name,
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Text(
                widget.transaction.description,

            ),
            trailing: Text(
              '${widget.transaction.time.toString()}دقيقة'

            ),
          ),
        ),
      ),
    );
  }
}

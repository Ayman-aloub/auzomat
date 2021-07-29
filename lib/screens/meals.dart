import 'package:flutter/material.dart';
import 'package:mapfollow/provider/cart.dart';
import 'package:mapfollow/provider/category.dart';
import 'package:mapfollow/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class MealsScreen extends StatefulWidget {
  String restaurantId;
  int myindex;
  MealsScreen(this.restaurantId,[this.myindex=0]);

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  var x;
  var color;
  var is_loading=true;
  @override void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    x=widget.myindex;
    Provider.of<Meals>(context, listen: false).fetchAndSetOrders(widget.restaurantId).then((value){
      setState(() {
        is_loading=false;
      });
    }).catchError((onError){});

  }

  Widget buildConsumer(BuildContext context){
    final cart = Provider.of<Cart>(context);
    Future<void> _showMyDialog(order) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text('اهلا بك')),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('هل تريد تفريغ السلة للطلب من مطعم اخر؟'),
                  //Text('Would you like to approve of this message?'),
                ],
              ),
            ),
            actions: <Widget>[
              
              TextButton(
                child: Text('نعم'),
                onPressed: () {
                  cart.clear();
                  cart.addItem(widget.restaurantId,order.name.toString(), order.price.toDouble());
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('لا'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    return Consumer<Meals>(
        builder: (ctx, orderData, child) { return Column(
          children: [
            /*Container(
              height:MediaQuery.of(context).orientation==Orientation.portrait?( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.1:( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.2,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: orderData.categories.length,
                itemBuilder: (ctx, i) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: MediaQuery.of(context).size.width*0.01, color:  Colors.white),
                    ),
                    child: InkWell(
                      child:Container(color: Color(0xFFFF7643),child: Center(child: Text(orderData.categories[i].name.toString(),style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).orientation==Orientation.portrait? MediaQuery.of(context).size.width*0.08:MediaQuery.of(context).size.height*0.08),))) ,
                      onTap: (){

                        setState(() {
                          x=i;
                        });
                      },
                    ),
                  );
                },
              ),
            ),*/
            CustomTabView(
              initPosition: x,
              itemCount: orderData.categories.length,

              tabBuilder: (context, index) => Tab(text: orderData.categories[index].name),
         // pageBuilder: (context, index) => Center(child: Text(data[index])),

              onPositionChange: (index){
                print('current position: $index');
                setState(() {
                  x = index;
                });

          },
          onScroll: (position) => print('$position'),
        ),

            Container(
              height: MediaQuery.of(context).orientation==Orientation.portrait?( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.9:( MediaQuery.of(context).size.height-AppBar().preferredSize.height-MediaQuery.of(context).padding.top)*0.8,
              child: ListView.builder(
                itemCount: orderData.categories[x].products.length,
                itemBuilder: (ctx, z) {
                  return Container(child: GestureDetector(
                    child:Card(
                      child: ListTile(
                          title: Text(orderData.categories[x].products[z].name.toString()) ,
                          subtitle: Text("السعر: "+orderData.categories[x].products[z].price.toString()+"(ج.م)"),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.shopping_cart,
                          ),
                          onPressed: () async {
                            if(cart.is_contained(orderData.categories[x].products[z].name)){
                              cart.removeItem(orderData.categories[x].products[z].name);
                              setState(() {
                                widget.myindex=x;
                              });


                            }else if(cart.restaurantID==widget.restaurantId||cart.restaurantID==null){
                              cart.addItem(widget.restaurantId,orderData.categories[x].products[z].name.toString(), orderData.categories[x].products[z].price.toDouble());
                              setState(() {
                                widget.myindex=x;
                              });
                            }else if(cart.restaurantID!=widget.restaurantId){
                              await _showMyDialog(orderData.categories[x].products[z]);
                              setState(() {
                                widget.myindex=x;
                              });


                            }




                          },
                            color: cart.is_contained(orderData.categories[x].products[z].name)?Theme.of(context).accentColor:Colors.grey[400],


                        ),
                      ),

                    ) ,

                  ),
                  );


                },
              ),

            ),
          ],
        );


        }
    );

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:Theme.of(context).backgroundColor,
            title: Center(child: Text('قائمة الوجبات')),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,

              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          endDrawer: AppDrawer(),
          body:is_loading?Center(child: CircularProgressIndicator(),)
          :SingleChildScrollView(child:buildConsumer(context)),
        ),
      ),
    );
  }
}
class CustomTabView extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;
  final Widget stub;
  final ValueChanged<int> onPositionChange;
  final ValueChanged<double> onScroll;
  final int initPosition;

  CustomTabView({
    @required this.itemCount,
    @required this.tabBuilder,
    @required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView> with TickerProviderStateMixin {
  TabController controller;
  int _currentCount;
  int _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount,
      vsync: this,
      initialIndex: _currentPosition,
    );
    controller.addListener(onPositionChange);
    controller.animation.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.animation.removeListener(onScroll);
      controller.removeListener(onPositionChange);
      controller.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 :
        _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            if(mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        controller.animation.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller.animateTo(widget.initPosition);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.animation.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount < 1) return widget.stub ?? Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            labelStyle: TextStyle(
                //fontFamily: "BalooTamma",
                fontWeight: FontWeight.bold,
                fontSize: 25),
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).accentColor,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(

              widget.itemCount,
                  (index) => widget.tabBuilder(context, index),
            ),
          ),
        ),

      ],
    );
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll(controller.animation.value);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:mapfollow/provider/restaurant.dart';
import 'package:mapfollow/provider/restaurants.dart';
import 'package:mapfollow/widgets/restaurant_item.dart';
import 'package:provider/provider.dart';




class restaurant_list extends StatefulWidget {
  @override
  _restaurant_listState createState() => _restaurant_listState();
}

class _restaurant_listState extends State<restaurant_list> {
  List<restaurant> _restaurantsitems=[] ;

 /* Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<restaurants>(context, listen: false)
        .fetchAndSetProducts();
  }*/

  @override
  Widget build(BuildContext context) {
    //_refreshProducts(context);
    _restaurantsitems=Provider.of<restaurants>(context).items;
    print(_restaurantsitems.length);
    print('build() TransactionList');
    return /* transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.title,
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : */ListView(
            children: _restaurantsitems
                .map((tx) => restaurantItem(
                      key: ValueKey(tx.id),
                      transaction: tx,
                    ))
                .toList(),
          );
     /* FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
        snapshot.connectionState == ConnectionState.waiting
            ? Center(
          child: CircularProgressIndicator(),
        )
            : RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Consumer<restaurants>(
            builder: (ctx, productsData, _) => Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, i) => Column(
                  children: [
                    restaurantItem(
                      key: ValueKey(productsData.items[i].id),
                      transaction:productsData.items[i],
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      );*/
  }
}

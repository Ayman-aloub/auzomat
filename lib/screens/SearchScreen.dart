import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mapfollow/screens/meals.dart';
import 'package:mapfollow/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:mapfollow/provider/category.dart';
class search extends StatefulWidget {
  @override
  _searchState createState() => _searchState();
}

class _searchState extends State<search> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:Theme.of(context).backgroundColor,
            title:  Center(child: const Text('البحث')),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,

              ),
              onPressed: () => Navigator.of(context).pop(),
            ),


          ),
          endDrawer: AppDrawer(),
          body: Column(
            children: [
              TypeAheadField(
                  hideSuggestionsOnKeyboardHide: false,
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      hintText: ' البحث',
                    ),
                  ),
                  suggestionsCallback: (pattern) async {
                    return await Provider.of<Meals>(context ,listen: false).getUserSuggestion(pattern);
                  },
                  itemBuilder: (context,searchItem suggestion) {


                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: ListTile(
                        title: Text(suggestion.name.toString()),
                      ),
                    );
                  },
                  noItemsFoundBuilder: (context) => Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        'لا يوجد مقترحات',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  onSuggestionSelected: ( searchItem suggestion) {

                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_)=>MealsScreen(suggestion.restaurant_ID,suggestion.index)));

                  },
                ),

            ],
          ),
        ),
      ),
    );
  }
}

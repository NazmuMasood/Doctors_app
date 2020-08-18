import 'package:doctors_app/widgets/patient/category_item.dart';
import 'package:flutter/material.dart';
import 'package:doctors_app/dummy/category_data.dart';


class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: 13,
                      color: Colors.teal,
                    ),
                    Text(
                      'Your Location',
                      style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.w300,
                          fontSize: 13),
                    ),
                  ],
                ),
                Text(
                  '329 Momin Road',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                )
              ],
            )
          //Text('Icon',style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold),),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  color: Colors.redAccent,
                ),
                onPressed: () => null),
          ),
        ],
      ),
      body: GridView(
        children: DUMMY_CATEGORIES
            .map(
              (catData) => CategoryItemWidget(
              catData.id, catData.title, catData.avatar, catData.text),
        )
            .toList(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 1.3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 5,
        ),
      ),
    );
  }
}
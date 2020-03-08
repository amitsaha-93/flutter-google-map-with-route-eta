//import 'package:flutter/material.dart';
//import 'package:map_design/views/design_list/ui/CarListItem.dart';
//
//const Color violet = Color(0xff4150B5);
//
//
//class CarLists extends StatefulWidget {
//  @override
//  _CarListsState createState() => _CarListsState();
//}
//
//class _CarListsState extends State<CarLists> {
//
//  GlobalKey globalKey = new GlobalKey();
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text("Car List", style: TextStyle(color: violet, fontSize: 15),),
//          centerTitle: true,
//          backgroundColor: Colors.white,
//        ),
//        body: Container(
//          child: ListView.builder(
//            itemBuilder: (context, index) {
//              return index==0?Dismissible(
//                key: Key(index.toString()),
//                  child: CarListItem(index: index)):CarListItem(index: index);
//            },
//            itemCount: 15,
//          ),
//        ),
//      ),
//    );
//  }
//}
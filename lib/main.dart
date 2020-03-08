import 'package:flutter/material.dart';

import 'views/moving_car/ui/moving_car.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {

    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: MovingCarScreen()
    );
  }
}

import 'package:flutter/material.dart';
import 'Views/geomap_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS_APP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(), // Display the GeoMapPage
    );
  }
}

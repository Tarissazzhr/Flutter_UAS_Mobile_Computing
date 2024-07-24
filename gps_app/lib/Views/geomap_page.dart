import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'dart:html' as html;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _latitude;
  double? _longitude;
  String? _address;
  MapboxMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() {
    html.window.navigator.geolocation.getCurrentPosition().then((pos) {
      setState(() {
        _latitude = pos.coords?.latitude as double?;
        _longitude = pos.coords?.longitude as double?;
      });
      _getAddressFromLatLng();
    });
  }

  Future<void> _getAddressFromLatLng() async {
    if (_latitude != null && _longitude != null) {
      final url = Uri.https('nominatim.openstreetmap.org', '/reverse', {
        'format': 'jsonv2',
        'lat': '$_latitude',
        'lon': '$_longitude',
      });

      final response = await html.HttpRequest.getString(url.toString());
      final json = jsonDecode(response);
      setState(() {
        _address = json['display_name'];
      });
    }
  }

  void _onMapCreated(MapboxMapController controller) {
    _mapController = controller;
    if (_latitude != null && _longitude != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(
        LatLng(_latitude!, _longitude!),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Location App'),
      ),
      body: Center(
        child: _latitude == null || _longitude == null
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: MapboxMap(
                      accessToken: 'YOUR_MAPBOX_ACCESS_TOKEN',
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_latitude!, _longitude!),
                        zoom: 15.0,
                      ),
                      myLocationEnabled: true,
                      myLocationTrackingMode: MyLocationTrackingMode.Tracking,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          'Latitude: $_latitude',
                          style: TextStyle(fontSize: 22.0),
                        ),
                        Text(
                          'Longitude: $_longitude',
                          style: TextStyle(fontSize: 22.0),
                        ),
                        if (_address != null)
                          Text(
                            'Address: $_address',
                            style: TextStyle(fontSize: 22.0),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
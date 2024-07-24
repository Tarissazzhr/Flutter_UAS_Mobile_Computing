import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WiFi Info App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WiFiInfoPage(),
    );
  }
}

class WiFiInfoPage extends StatefulWidget {
  const WiFiInfoPage({super.key});

  @override
  _WiFiInfoPageState createState() => _WiFiInfoPageState();
}

class _WiFiInfoPageState extends State<WiFiInfoPage> {
  String? _publicIP;

  @override
  void initState() {
    super.initState();
    _getPublicIP();
  }

  Future<void> _getPublicIP() async {
    final url = Uri.parse('https://api.ipify.org?format=json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _publicIP = data['ip'];
      });
    } else {
      setState(() {
        _publicIP = 'Failed to get public IP';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WiFi Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Public IP: $_publicIP'),
          ],
        ),
      ),
    );
  }
}

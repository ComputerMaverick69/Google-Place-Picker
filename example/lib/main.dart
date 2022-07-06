import 'package:flutter/material.dart';
import 'package:google_place_picker/google_place_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Place Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Google Place Picker Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String address = '';
  String city = '';
  String latitude = '';
  String longitude = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Address: $address',
            ),
            Text(
              'City: $city',
            ),
            Text(
              'Latitude: $latitude',
            ),
            Text(
              'Longitude: $longitude',
            ),
            RaisedButton(
              color: Colors.blue,
              elevation: 0.0,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GooglePlacePicker(
                      apiKey: 'YOUR_API_KEY',
                      getAddress: (completeAddress) {
                        setState(() {
                          address = completeAddress.completeAddress.toString();
                          city = completeAddress.city.toString();
                          latitude =
                              completeAddress.position!.latitude.toString();
                          longitude =
                              completeAddress.position!.longitude.toString();
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('Pick a Place on Google Maps'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HelpTruck extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help Requested!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
            child: Container(
                child: Text(
                  'You have successfully requested Truck breakdown assistance to this current location.',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, backgroundColor: Colors.redAccent),))),
      ),
    );
  }
}

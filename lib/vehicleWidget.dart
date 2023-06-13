import 'package:flutter/material.dart';

class VehicleWidget extends StatefulWidget {
  @override
  _VehicleWidgetState createState() => _VehicleWidgetState();
}

class _VehicleWidgetState extends State<VehicleWidget> {
  @override

  Widget build(BuildContext context) {
    return Container(
        child: Row(
          children: <Widget>[
            InkWell(
              highlightColor: Colors.greenAccent,
              onTap: () {},
              child: Column(
                children: <Widget>[
                Image(image: AssetImage('images/icons8-car-50.png'),),
                  Text('Car'),
                ],
              ),
            ),

            Divider(),

           InkWell(
             highlightColor: Colors.greenAccent,
             onTap: () {},
             child:  Column(
               children: <Widget>[
                 Image(image: AssetImage('images/icons8-scooter-50.png'),),
                 Text('Motorbike'),
               ],
             ),
           ),

            Divider(),

            InkWell(
              highlightColor: Colors.greenAccent,
              onTap: () {},
              child: Column(
                children: <Widget>[
                  Image(image: AssetImage('images/icons8-truck-64.png'),),
                  Text('Truck'),
                ],
              ),
            ),
          ],
      ),
    );
  }
}

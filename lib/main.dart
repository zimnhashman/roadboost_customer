import 'package:flutter/material.dart';
import 'directions_model.dart';
import 'directions_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'helpCar.dart';
import 'helpTruck.dart';
import 'helpBike.dart';
import 'package:location/location.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}



class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-17.838129, 31.006380),
    zoom: 40.0,
  );


  Set<Marker> markers = new Set();
  GoogleMapController _googleMapController;
  Marker _origin;
  Marker _destination;
  Directions _info;
  LatLng currentPosition;

  static const LatLng actionBreakdown = const LatLng(-17.8341637, 31.0824784);
  static const LatLng miguelBreakdown = const LatLng(-17.7999056, 31.1280522);
  static const LatLng roadAngels = const LatLng(-17.787937, 31.040438);
  static const LatLng johnkayAuto = const LatLng(-17.782812, 30.988937);
  static const LatLng quicklyRescue = const LatLng(-17.846438, 31.063063);
  static const LatLng towjam = const LatLng(-17.763813, 31.007188);

  Location location = new Location();


  //BehaviorSubject<double> radius = BehaviorSubject(seedValue: 100);
  Stream<dynamic> query;



  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Roadboost Breakdown '),
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () =>
                  _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: _origin.position,
                        zoom: 14.5,
                        tilt: 50.0,
                      ),
                    ),
                  ),
              style: TextButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () =>
                  _googleMapController.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: _destination.position,
                        zoom: 14.5,
                        tilt: 50.0,
                      ),
                    ),
                  ),
              style: TextButton.styleFrom(
                primary: Colors.blue,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GoogleMap(
            trafficEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              if (_origin != null) _origin,
              if (_destination != null) _destination,
            },

            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
            onLongPress: _addMarker,
          ),
          if (_info != null)
            Positioned(
              top: 20.0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    )
                  ],
                ),
                child: Text(
                  '${_info.totalDistance}, ${_info.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 6.0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 5.0,
              ),
              alignment: Alignment.bottomCenter,
              height: 100.0,
              width: 200.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: InkWell(
                      highlightColor: Colors.greenAccent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HelpCar()));
                        print('Car is clicked');
                      },
                      child: Column(
                        children: <Widget>[
                          Image(image: AssetImage('images/icons8-car-50.png'),),
                          Text('Car'),
                        ],
                      ),
                    ),
                  ),

                  Divider(),

                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: InkWell(
                      highlightColor: Colors.greenAccent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HelpBike()));
                        print('Motorbike is clicked');
                      },
                      child: Column(
                        children: <Widget>[
                          Image(image: AssetImage(
                              'images/icons8-scooter-50.png'),),
                          Text('Motorbike'),
                        ],
                      ),
                    ),
                  ),

                  Divider(),

                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: InkWell(
                      highlightColor: Colors.greenAccent,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HelpTruck()));
                        print('Truck is clicked');
                      },
                      child: Column(
                        children: <Widget>[
                          Image(image: AssetImage(
                              'images/icons8-truck-64.png'),),
                          Text('Truck'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        foregroundColor: Colors.black,
        onPressed: () =>
            _googleMapController.animateCamera(
              _info != null
                  ? CameraUpdate.newLatLngBounds(_info.bounds, 100.0)
                  : CameraUpdate.newCameraPosition(_initialCameraPosition),
            ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }


  Set<Marker> getmarkers() {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(actionBreakdown.toString()),
        position: actionBreakdown,

        infoWindow: InfoWindow(
            title: 'Action Breakdown Services',
            snippet: 'Action'
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ));

      markers.add(Marker(
        markerId: MarkerId(miguelBreakdown.toString()),
        position: miguelBreakdown,

        infoWindow: InfoWindow(
            title: 'Miguel Breakdown Recovery',
            snippet: 'Miguel'
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ));

      markers.add(Marker(
        markerId: MarkerId(roadAngels.toString()),
        position: roadAngels,

        infoWindow: InfoWindow(
            title: 'Road Angels Pvt Ltd',
            snippet: 'Road Angels'
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ));

      markers.add(Marker(
        markerId: MarkerId(johnkayAuto.toString()),
        position: johnkayAuto,

        infoWindow: InfoWindow(
            title: 'John Kay Auto Recovery',
            snippet: 'John Kay Auto'
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ));

      markers.add(Marker(
        markerId: MarkerId(quicklyRescue.toString()),
        position: quicklyRescue,

        infoWindow: InfoWindow(
            title: 'Quickly Rescue and  Recovery',
            snippet: 'Quickly'
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ));

      markers.add(Marker(
        markerId: MarkerId(towjam.toString()),
        position: towjam,

        infoWindow: InfoWindow(
            title: 'Towjam Pvt Ltd',
            snippet: 'TowJam'
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ));
    });
    return markers;
  }


  void _addMarker(LatLng pos) async {
    if (_origin == null || (_origin != null && _destination != null)) {
      // Origin is not set OR Origin/Destination are both set
      // Set origin
      setState(() {
        _origin = Marker(
          markerId: const MarkerId('current_Position'),
          infoWindow: const InfoWindow(title: 'Current Position'),
          icon:
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: pos,
        );
        // Reset destination
        _destination = null;
        // Reset info
        _info = null;
      });
    } else {
      // Origin is already set
      // Set destination
      setState(() {
        _destination = Marker(
          markerId: const MarkerId('destination'),
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue),
          position: pos,
        );
      });

      // Get directions
      final directions = await DirectionsRepository()
          .getDirections(origin: _origin.position, destination: pos);
      setState(() => _info = directions);
    }
  }
}
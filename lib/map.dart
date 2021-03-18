import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:untitled1/istanbul.dart';
import 'package:untitled1/izmir.dart';

void map(lat,lon,city,data,data2) {
  runApp(MapView(lat,lon,city,data,data2));
}

class MapView extends StatelessWidget {
  var data;
  var data2;
  var city;
  var lon;
  var lat;
  MapView(this.lat,this.lon,this.city,this.data, this.data2);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home:  Map(this.lat,this.lon,this.city,this.data, this.data2),
    );
  }
}

class Map extends StatefulWidget {
  var data;
  var data2;
  var lon;
  var lat;
  var city;
  Map(this.lat,this.lon,this.city,this.data, this.data2);

  @override
  _MapState createState() => _MapState(this.lat,this.lon,this.city,this.data, this.data2);
}

class _MapState extends State<Map> {
  String _instruction = "";
  MapBoxNavigation _directions;
  MapBoxOptions _options;
  bool _arrived = false;
  bool _isMultipleStop = false;
  double _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  var lon;
  var lat;
  var i=1;
  var data;
  var data2;
  var city;
  _MapState(this.lat,this.lon,this.city,this.data, this.data2);

  @override
  void initState() {
    super.initState();
    initialize();
    _isMultipleStop = true;
    var wayPoints = List<WayPoint>();

   var _origin = WayPoint(
        name: "Start",
        latitude: this.lat,
        longitude: this.lon);
    var _stop1 = WayPoint(
        name: "Park",
        latitude: data,
        longitude: data2);

    wayPoints.add(_origin);
    wayPoints.add(_stop1);

    _directions.startNavigation(
        wayPoints: wayPoints,
        options: MapBoxOptions(
            mode: MapBoxNavigationMode.drivingWithTraffic,
            simulateRoute: true,
            language: "en",
            alternatives: true,
            units: VoiceUnits.metric)
    );
  }

  Future<void> initialize() async {
    if (!mounted) return;
    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
  }

  @override
  Widget build(BuildContext context) {
    returned();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
      ),
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await _directions.distanceRemaining;
    _durationRemaining = await _directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        _arrived = progressEvent.arrived;
        if (progressEvent.currentStepInstruction != null)
          _instruction = progressEvent.currentStepInstruction;
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        _arrived = true;
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }

  void returned() {
    if(this._isNavigating==false){
      if(city=="Istanbul") {
        Istanbul();
      }
      else{
        Izmir();
      }
    }
  }

}
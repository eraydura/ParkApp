import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import './modals/autopark_bloc.dart';
import './screens/pages.dart';

void main() {
  runApp(ParkView());
}

class ParkView extends StatelessWidget {
  final AutoparkBloc _autoparkBloc = AutoparkBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Splash(autoparkBloc: _autoparkBloc),
    );
  }
}

class Splash extends StatefulWidget {
  final AutoparkBloc autoparkBloc;

  Splash({required this.autoparkBloc});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds and then navigate to Parks screen
    Future.delayed(const Duration(seconds: 3), () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Parks(autoparkBloc: widget.autoparkBloc)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/parking.png", height: 150, width: 150),
            SizedBox(height: 25),
            Text(
              "ParkApp",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class Parks extends StatefulWidget {
  final AutoparkBloc autoparkBloc;

  Parks({required this.autoparkBloc});

  @override
  _ParksState createState() => _ParksState();
}

class _ParksState extends State<Parks> {
  Position? _currentPosition; // Variable to store the current position
  bool _showButtons = false; // Variable to control the visibility of buttons

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get the user's current location
  }

  void _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        setState(() {
          _showButtons = true; // Set showButtons to true if permission is denied
        });
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _showButtons = true; // Set showButtons to true after getting the current position
      });
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _showButtons = true; // Set showButtons to true if there's an error while getting the location
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_showButtons) ...[ // Show buttons only if _showButtons is true
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/parking.png", height: 50, width: 50),
                        Text(
                          "ParkApp",
                          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    SizedBox(height: 25),
                    ButtonTheme(
                      minWidth: 500.0,
                      height: 50.0,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to PageScreen with the current location and city name
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageScreen(
                                autoparkBloc: widget.autoparkBloc,
                                city: "Izmir",
                                location: _currentPosition,
                              ),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20.0), // right, bottom, left, top
                          ),
                        ),
                        child: Text("Izmir", style: TextStyle(fontSize: 25)),
                      ),
                    ),
                    SizedBox(height: 10),
                    ButtonTheme(
                      minWidth: 300.0,
                      height: 50.0,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PageScreen(
                                autoparkBloc: widget.autoparkBloc,
                                city: "Istanbul",
                                location: _currentPosition,
                              ),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white70),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.fromLTRB(85.0, 20.0, 85.0, 20.0), // right, bottom, left, top
                          ),
                        ),
                        child: Text("Istanbul", style: TextStyle(fontSize: 25),),
                      ),
                    ),
                  ] else ...[ // Show a loading indicator while waiting for the current location
                    CircularProgressIndicator(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

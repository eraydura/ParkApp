import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:untitled1/istanbul.dart';
import 'package:untitled1/izmir.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled1/map.dart';

void main() {
  runApp(ParkView());
}

class ParkView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home:  Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () async {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => new Parks()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("assets/parking.png",height: 150,width: 150,),
            //Image.asset('assets/images/flutterlogo.png', width: 40, height: 40,),
            SizedBox(
              height: 25,
            ),
            Text(
              "ParkApp",
              style: GoogleFonts.nunito(fontSize: 30,fontWeight: FontWeight.bold,textStyle: TextStyle(color: Colors.white70) ),
            ),
          ],
        ),
      ),
    );
  }
}

class Parks extends StatefulWidget {
  @override
  ParksPage createState() => ParksPage();
}

class ParksPage extends State<Parks> {

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "ParkApp",
                  style: GoogleFonts.nunito(fontSize: 40,fontWeight: FontWeight.bold,textStyle: TextStyle(color: Colors.white70)),
                ),
                SizedBox(height: 20,),
              ButtonTheme(
              minWidth: 300.0,
              height: 50.0,
              child:RaisedButton(
                  onPressed: (){ Izmir(); } ,
                   textColor: Colors.white70,
                   color: Colors.blueGrey,
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    "Izmir",style: GoogleFonts.nunito(fontWeight: FontWeight.bold,fontSize: 20),
                  ),
                )
              ),

                SizedBox(height: 10,),

                ButtonTheme(
                minWidth: 300.0,
                height: 50.0,
                child:RaisedButton(
                  onPressed: (){Istanbul();} ,
                  textColor: Colors.white70,
                  color: Colors.blueGrey,
                  padding: const EdgeInsets.all(8.0),
                  child: new Text(
                    "Istanbul",style: GoogleFonts.nunito(fontWeight: FontWeight.bold,fontSize: 20),
                  ),
                 )
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class HelperFunctions{
  static Future<double> getUserLongitude() async{
    var position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position.longitude;
  }
  static Future<double> getUserLatitude() async{
    var position = await GeolocatorPlatform.instance.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position.latitude;
  }
}
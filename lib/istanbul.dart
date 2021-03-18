import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:untitled1/map.dart';
import 'camera.dart';
import 'main.dart';

void Istanbul() async {
  HttpOverrides.global = new DevHttpOverrides();
  List data2;
  var lat;
  var lon;
  HelperFunctions.getUserLatitude().then((value) => lat=value);
  HelperFunctions.getUserLongitude().then((value) => lon=value);
  await getJSON().then((value) =>  data2=find_nearest(value,lat,lon));
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.keyboard_return),
              onPressed: () {main();},
            ),
            centerTitle: true,
            title: Text('Istanbul Autopark'),
          ),
          body: Center(
            child: ListView.builder(
              itemCount: data2.length,
              padding: EdgeInsets.all(10.5),
              itemBuilder: (BuildContext context,int position){
                return Column(
                  children: <Widget>[
                    Divider(
                      height: 2.2,
                    ),
                    ListTile(
                        title: Text(data2[position]['parkName'],style: TextStyle(fontSize: 12.9),
                        ),
                        subtitle: Text("Occupied: " +(data2[position]['capacity']-data2[position]['emptyCapacity']).toString()+" "+"Free: " +data2[position]['emptyCapacity'].toString(),style: TextStyle(fontSize: 12.9)
                        ),
                        leading: CircleAvatar(child: Text(data2[position]['isOpen'].toString()=="1" ? "Opened" : "Closed", style: TextStyle(color: Colors.white),
                        ), radius: 35, backgroundColor: data2[position]['isOpen'].toString()=="1" ? Colors.green: Colors.red,
                        ),
                        onTap: () {
                          if(lat!=null && lon!=null) {
                            map(lat,lon, "Istanbul", double.parse(data2[position]['lat']),double.parse(data2[position]['lng']));
                          }
                        }
                    ),
                  ],
                );
              }
              ,
            ),
          ),
        floatingActionButton: new FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () {
            camera("Istanbul");
          },
        ),
      ),
    ),
  );
}

List find_nearest(List data, lat, lon) {
  final Distance distance = new Distance();

  List<double> meters=[];
  List<double> meters_second=[];
  List data2=[];

  for(int i=0; i<data.length; i++) {
    double meter = distance(new LatLng(double.parse(data[i]['lat']),double.parse(data[i]['lng'])), new LatLng(lat,lon));
    meters.add(meter);
    meters_second.add(meter);
  }

  meters.sort();

  for(int i=0; i<meters_second.length; i++){
    int a=meters_second.indexOf(meters[i]);
    data2.add(data[a]);
  }

  return data2;
}

Future<List> getJSON() async {
  String apiURL = 'https://api.ibb.gov.tr/ispark/Park';
  http.Response response = await http.get(apiURL);
  return json.decode(response.body);
  //return 'hello';
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
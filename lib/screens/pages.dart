import 'package:flutter/material.dart';
import '../modals/autopark_bloc.dart';
import './map.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

class PageScreen extends StatefulWidget {
  final AutoparkBloc autoparkBloc;
  final String city;
  final Position? location;

  PageScreen({required this.autoparkBloc, required this.city, required this.location});

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  Stream<List<dynamic>>? _stream;

  @override
  void initState() {
    super.initState();
    final String istanbulApiUrl = 'https://api.ibb.gov.tr/ispark/Park';
    final String izmirApiUrl = 'https://openapi.izmir.bel.tr/api/ibb/izum/otoparklar';

    // Fetch data based on the city
    if (widget.city == "Istanbul") {
      _stream = _sortLocations(widget.autoparkBloc.fetchAutoparks(istanbulApiUrl));
    } else if (widget.city == "Izmir") {
      _stream = _sortLocations(widget.autoparkBloc.fetchAutoparks(izmirApiUrl));
    }
  }

  Stream<List<dynamic>> _sortLocations(Stream<List<dynamic>> stream) async* {
    if (widget.location == null) {
      yield [];
      return;
    }

    await for (var data in stream) {
      // Iterate through the fetched data
      for (var item in data) {
        // Calculate distance manually using Haversine formula
        double distance = _calculateDistance(
          widget.location!.latitude,
          widget.location!.longitude,
          double.parse(item['lat'].toString()),
          double.parse(item['lng'].toString()),
        );

        // Add distance to the item
        item['distance'] = distance;
      }
      // Sort the data based on distance
      data.sort((a, b) => (a['distance'] as double).compareTo(b['distance'] as double));
      yield data;
    }
  }

  // Function to calculate distance using Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const int earthRadius = 6371; // Radius of the Earth in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  // Function to convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city == "Istanbul" ? 'Istanbul Autopark' : 'Izmir Autopark'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<dynamic>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<dynamic> data = snapshot.data!;
                  if (widget.city == "Istanbul") {
                    return _buildIstanbulList(data, context);
                  } else if (widget.city == "Izmir") {
                    return _buildIzmirList(data, context);
                  }
                }
                return Center(child: Text('No data available'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIstanbulList(List<dynamic> data, BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        var parkingLot = data[index];
        return ListTile(
          title: Text(parkingLot['parkName']),
          subtitle: Text("Occupied: ${parkingLot['capacity'] - parkingLot['emptyCapacity']} Free: ${parkingLot['emptyCapacity']}"),
          leading: CircleAvatar(
            backgroundColor: parkingLot['isOpen'] == "1" ? Colors.green : Colors.red,

          ),
          onTap: () {
            double lat = double.parse(parkingLot['lat'].toString());
            double lon = double.parse(parkingLot['lng'].toString());

            String url = 'https://www.google.com/maps/dir/?api=1&origin=' +
                widget.location!.latitude.toString() +
                ',' +
                widget.location!.longitude.toString() +
                '&destination=' +
                lat.toString() +
                ',' +
                lon.toString() +
                '&travelmode=driving&dir_action=navigate';
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapWebView(
                 url: url,

                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIzmirList(List<dynamic> data, BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      padding: EdgeInsets.all(10.5),
      itemBuilder: (BuildContext context, int position) {
        var parkingLot = data[position];
        return Column(
          children: <Widget>[
            Divider(
              height: 2.2,
            ),
            ListTile(
              title: Text(parkingLot['name'], style: TextStyle(fontSize: 12.9)),
              subtitle: Text("Occupied: ${parkingLot['occupancy']['total']['occupied']} Free: ${parkingLot['occupancy']['total']['free']}", style: TextStyle(fontSize: 12.9)),
              leading: CircleAvatar(
                radius: 35,
                backgroundColor: parkingLot['status'].toString() == "Opened" ? Colors.green : Colors.red,
              ),
              onTap: () {
                double lat = double.parse(parkingLot['lat'].toString());
                double lon = double.parse(parkingLot['lng'].toString());

                String url = 'https://www.google.com/maps/dir/?api=1&origin=' +
                    widget.location!.latitude.toString() +
                    ',' +
                    widget.location!.longitude.toString() +
                    '&destination=' +
                    lat.toString() +
                    ',' +
                    lon.toString() +
                    '&travelmode=driving&dir_action=navigate';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapWebView(
                      url: url,
                    ),
                  ),
                );
              },

            ),
          ],
        );
      },
    );
  }
}

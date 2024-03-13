import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AutoparkBloc {
  Stream<List<dynamic>> fetchAutoparks(String apiUrl) async* {
    try {
      http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        yield data; // Emit the data once
      } else {
        throw Exception('Failed to fetch autoparks');
      }
    } catch (e) {
      throw Exception('Failed to fetch autoparks');
    }
  }
}

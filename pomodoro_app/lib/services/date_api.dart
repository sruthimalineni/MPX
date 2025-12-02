import 'dart:convert';
import 'package:http/http.dart' as http;

class DateApi {
  Future<DateTime> fetchCurrentDate() async {
    final response = await http.get(Uri.parse('https://worldtimeapi.org/api/ip'));

    if (response.statusCode != 200) {
      throw Exception("Failed to load date");
    }

    final data = jsonDecode(response.body);
    return DateTime.parse(data['datetime']);
  }
}
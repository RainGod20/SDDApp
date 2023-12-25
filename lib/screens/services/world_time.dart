import "package:http/http.dart";
import "dart:convert";

import "package:intl/intl.dart";

class WorldTime {
  String location; // Location name for UI
  late String time; // Time in that location
  String flag; // URL to the flag icon asset
  String url; // Location URL for API endpoint

  WorldTime({
    required this.location,
    required this.flag,
    required this.url,
  });

  Future<void> getTime() async {
    try {
      // Make HTTP request to World Time Api
      var URL = Uri.parse("http://worldtimeapi.org/api/timezone/$url");
      Response response = await get(URL);
      Map timezoneData = jsonDecode(response.body);

      // Get properties of timezoneData
      String dateTime = timezoneData['datetime'];
      int rawOffset = timezoneData['raw_offset'];
      String offset = timezoneData['utc_offset'];

      // Create datetime object
      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(seconds: rawOffset));
      time = DateFormat.jm().format(now); // Set time property
    } catch (e) {
      print(e);
      time = "Could not retrieve time data";
    }
  }
}

import "package:flutter/material.dart";
import "package:http/http.dart";
import "dart:convert";

import "package:intl/intl.dart";

class WorldTime {
  late String countryAndCity; // e.g. Sydney, Australia
  late String offsetAndAbbrev; // e.g. +1:00 HRS | EST
  late String time; // Time in that location
  late String period; // AM or PM
  String flag; // URL to the flag icon asset
  String url; // Location URL for API endpoint

  WorldTime({
    required this.flag,
    required this.url,
  });

  Future<void> getTime() async {
    print('Started getTime()');
    print('URL: $url, Flag: $flag');
    try {
      // Make HTTP request to World Time Api
      print("Started HTTP request");
      var URL = Uri.parse("http://worldtimeapi.org/api/timezone/$url");
      print("Http Request 1 - URL: $URL");
      Response response = await get(URL);
      print("Http Request 2 - URL, $URL, Response: $response");
      Map timezoneData = jsonDecode(response.body);
      print("Made HTTP request = TimezoneData: $timezoneData");

      // Get properties of timezoneData
      String dateTime = timezoneData['datetime'];
      int rawOffset = timezoneData['raw_offset'];
      String offset = timezoneData['utc_offset'];
      String abbrev = timezoneData['abbreviation'];
      if (url.contains('/')) {
        countryAndCity = url.split('/').reversed.toList().join(", ");
        if (countryAndCity.contains('_')) {
          countryAndCity = countryAndCity.split('_').join(" ");
        }
        print(countryAndCity);
      } else {
        countryAndCity = "Invalid Country";
      }
      offsetAndAbbrev = "$offset HRS | $abbrev";

      // Create datetime object
      DateTime now = DateTime.parse(dateTime);
      now = now.add(Duration(seconds: rawOffset));
      time = DateFormat('hh:mm').format(now); // Set time property
      period = DateFormat('a').format(now);
      print("got to end of getTime()");
      print(
          "Variables in getTime: $countryAndCity, $offsetAndAbbrev, $period, $time, $flag, $url");
    } catch (e) {
      print(e);
      time = "Could not retrieve time data";
    }
  }
}

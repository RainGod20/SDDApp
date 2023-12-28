import 'dart:async';
import 'dart:ffi';

import 'package:clock_app_flutter/screens/home_screen/components/clock.dart';
import 'package:clock_app_flutter/screens/home_screen/components/country_card.dart';
import 'package:clock_app_flutter/screens/home_screen/components/time_in_hour_and_minute.dart';
import 'package:clock_app_flutter/screens/services/world_time.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class Body extends StatefulWidget {
  Map? data;

  Body({
    super.key,
    this.data,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String locationData = "";

  void getCurrLocation() async {
    bool userAcceptedLocationPerms = false;
    int maxTries = 7; // Max number of attempts to access location if user gave permission
    do {
      try {
        LocationPermission permission;
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          userAcceptedLocationPerms = true;
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true,
            timeLimit: Duration(seconds: 10),
          );
          try {
            List<Placemark> placemarks =
                await placemarkFromCoordinates(position.latitude, position.longitude);
            if (placemarks[0].administrativeArea == null) {
              if (placemarks[0].isoCountryCode == null) {
                locationData = DateTime.now().timeZoneName.toString();
              } else {
                locationData =
                    "${placemarks[0].isoCountryCode} | ${DateTime.now().timeZoneName}";
              }
            } else {
              if (placemarks[0].isoCountryCode == null) {
                locationData =
                    "${placemarks[0].administrativeArea} | ${DateTime.now().timeZoneName.toString()}";
              } else {
                locationData =
                    "${placemarks[0].administrativeArea}, ${placemarks[0].isoCountryCode} | ${DateTime.now().timeZoneName}";
              }
            }

            setState(() {});
          } catch (e) {
            // If geocoding threw an exception
            print("Geocoding Exception: $e");
            maxTries--;
          }
        } else {
          throw Exception("User denied permission to access device's location");
        }
      } catch (e) {
        // If geolocator threw an exception
        print("Geolocator Exception: $e");
        if (e != "User denied permission to access device's location") {
          maxTries--;
        }
      }
    } while (userAcceptedLocationPerms && maxTries > 0);
  }

  List<Widget> countryCards = [];
  List<List> newLocations = [
    [
      tz.getLocation("America/Chicago"),
      "Chicago, America | ${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneName}",
      'UTC ${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.isNegative ? "-" : "+"}${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs()}' : '0${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs()}'}:${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}' : '0${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}'}'
    ],
    [
      tz.getLocation("Australia/Sydney"),
      "Sydney, Australia | ${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneName}",
      'UTC ${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.isNegative ? "-" : "+"}${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs()}' : '0${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs()}'}:${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}' : '0${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}'}'
    ],
  ];

  @override
  void initState() {
    super.initState();
    getCurrLocation();
    if (widget.data != null) {
      newLocations.add([
        widget.data?['placeLocation'],
        widget.data?['placeName'],
        widget.data?['placeUtcOffset']
      ]);
    }
    for (var location in newLocations) {
      countryCards.add(UpdateCountryCard(
        locationName: location[0],
        locationString: location[1],
        locationOffset: location[2],
      ));
    }
    newLocations = List.empty();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              locationData,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            TimeInHourAndMinute(),
            Spacer(),
            Clock(),
            Spacer(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: countryCards,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:ffi';

import 'package:clock_app_flutter/screens/home_screen/components/clock.dart';
import 'package:clock_app_flutter/screens/home_screen/components/country_card.dart';
import 'package:clock_app_flutter/screens/home_screen/components/time_in_hour_and_minute.dart';
import 'package:clock_app_flutter/screens/services/world_time.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Body extends StatefulWidget {
  Body({super.key});

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

  List locations = ["America/New_York", "Australia/Sydney"];

  @override
  void initState() {
    super.initState();
    getCurrLocation();
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
                children: [
                  UpdateCountryCard(
                    // country: "Sydney, AU",
                    // timeZone: "+19 HRS | AEST",
                    // iconSrc: "assets/icons/Sydney.svg",
                    // time: "1:20",
                    // period: "AM",
                    flag: 'Sydney.png',
                    url: 'Australia/Sydney',
                  ),
                  UpdateCountryCard(
                    // country: "New York, USA",
                    // timeZone: "+3 HRS | EST",
                    // iconSrc: "assets/icons/Liberty.svg",
                    // time: "9:20",
                    // period: "PM",
                    flag: 'New_York.png',
                    url: 'America/New_York',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

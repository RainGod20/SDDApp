// ignore_for_file: avoid_print

import 'dart:async';

import 'package:clock_app_flutter/screens/home_screen/components/clock.dart';
import 'package:clock_app_flutter/screens/home_screen/components/country_card.dart';
import 'package:clock_app_flutter/screens/home_screen/components/time_in_hour_and_minute.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatefulWidget {
  final Map? data;

  const Body({
    super.key,
    this.data,
  });

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String locationData = "";
  final List<Widget> countryCards = [];

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
            timeLimit: const Duration(seconds: 10),
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
            maxTries--;
          }
        } else {
          throw Exception("User denied permission to access device's location");
        }
      } catch (e) {
        // If geolocator threw an exception
        if (e != "User denied permission to access device's location") {
          maxTries--;
        }
      }
    } while (userAcceptedLocationPerms && maxTries > 0);
  }

  Future<void> getCountryCards(int? removeCardIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int numLocations;
    // Check if it is the user's first time opening the app
    bool? firstTime = prefs.getBool("firstTime");
    if (firstTime != null && !firstTime) {
      numLocations = prefs.getInt('numLocations')!;
      // Not first time
      if (widget.data != null &&
          (widget.data?['removeCardIndex'] == null || widget.data?['removeCardIndex'] == -1)) {
        // Check if the user has selected a location from location screen and add it to prefs
        numLocations++;
        await prefs.setInt('numLocations', numLocations);
        await prefs.setStringList('Location $numLocations', [
          widget.data!['placeLocation'].toString(),
          widget.data?['placeName'],
          widget.data?['placeUtcOffset'],
        ]);
      }
    } else {
      prefs.clear();
      prefs.setBool("firstTime", false);
      // Is first time so add default locations to prefs
      numLocations = 2;
      await prefs.setInt('numLocations', numLocations);
      await prefs.setStringList('Location 1', [
        'Australia/Sydney',
        "Sydney, Australia | ${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneName}",
        'UTC ${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.isNegative ? "-" : "+"}${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs()}' : '0${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs()}'}:${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}' : '0${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}'}',
      ]);

      // await prefs.setStringList('Location 2', [
      //   'America/Chicago',
      //   'Chicago, America | ${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneName}',
      //   'UTC ${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.isNegative ? "-" : "+"}${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs()}' : '0${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs()}'}:${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}' : '0${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}'}',
      // ]);
      await prefs.setStringList('Location 2', ['UTC', 'UTC | UTC', 'UTC +00:00']);
    }

    if (removeCardIndex != -1 && removeCardIndex != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      int numLocations = prefs.getInt('numLocations')!;
      prefs.remove('Location $removeCardIndex');
      for (var i = removeCardIndex + 1; i <= numLocations; i++) {
        List<String>? temp = prefs.getStringList('Location $i');
        if (temp != null) {
          prefs.setStringList('Location ${i - 1}', temp);
        } else {
          print("Null location in prefs");
        }

        if (i == prefs.getKeys().length - 2) {
          prefs.remove('Location $i');
        }
      }
      numLocations--;
      prefs.setInt('numLocations', numLocations);

      // Change the removeCardIndex
      widget.data?['removeCardIndex'] = -1;
    }

    for (var i = 1; i <= numLocations; i++) {
      List<String>? locationData = prefs.getStringList('Location $i');
      if (locationData != null) {
        countryCards.add(
          UpdateCountryCard(
            locationName: tz.getLocation(locationData[0]),
            locationString: locationData[1],
            locationOffset: locationData[2],
            cardIndex: i,
          ),
        );
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrLocation();
    getCountryCards(widget.data?['removeCardIndex']);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                locationData,
                style: Theme.of(context).textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
              const TimeInHourAndMinute(),
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              const Clock(),
              SizedBox(
                height: getProportionateScreenHeight(30),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: countryCards,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

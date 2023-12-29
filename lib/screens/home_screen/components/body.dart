import 'dart:async';

import 'package:clock_app_flutter/screens/home_screen/components/clock.dart';
import 'package:clock_app_flutter/screens/home_screen/components/country_card.dart';
import 'package:clock_app_flutter/screens/home_screen/components/time_in_hour_and_minute.dart';
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

  // late int? locationCounter;

  // Future<bool> isFirstTime() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? firstTime = prefs.getBool("firstTime");

  //   if (firstTime != null && !firstTime) {
  //     // Not first time
  //     return false;
  //   } else {
  //     prefs.setBool("firstTime", false);
  //     return true;
  //   }
  // }

  // Future<void> firstTimeStartup() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // At the very first startup, the 2 locations below will be displayed
  //   await prefs.setInt('numLocations', 2);

  //   await prefs.setStringList('Location 1', [
  //     "America/Chicago",
  //     "Chicago, America | ${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneName}",
  //     'UTC ${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.isNegative ? "-" : "+"}${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs()}' : '0${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs()}'}:${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}' : '0${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}'}',
  //   ]);

  //   await prefs.setStringList('Location 2', [
  //     "Australia/Sydney",
  //     "Sydney, Australia | ${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneName}",
  //     'UTC ${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.isNegative ? "-" : "+"}${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs()}' : '0${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs()}'}:${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}' : '0${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}'}',
  //   ]);

  //   locationCounter = prefs.getInt('numLocations') ?? 2;
  // }

  // Future<void> getLocationData() async {
  //   final prefs = await SharedPreferences.getInstance();

  //   if (widget.data != null) {
  //     locationCounter = prefs.getInt('numLocations');
  //     await prefs.setStringList('Location ${locationCounter! + 1}', [
  //       widget.data?['placeLocation'],
  //       widget.data?['placeName'],
  //       widget.data?['placeUtcOffset'],
  //     ]);
  //     await prefs.setInt('numLocations', locationCounter! + 1);
  //   }
  // }

  // Future<void> getAllCountryCardsFromPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   locationCounter = prefs.getInt('numLocations') ?? 2;

  //   for (var i = 1; i <= locationCounter!; i++) {
  //     List<String>? locationData = prefs.getStringList('Location $i');
  //     widget.countryCards.add(
  //       UpdateCountryCard(
  //         locationName: tz.getLocation(locationData![0]),
  //         locationString: locationData[1],
  //         locationOffset: locationData[2],
  //       ),
  //     );
  //   }
  // }

  Future<void> getCountryCards() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int numLocations;
    // Check if it is the user's first time opening the app
    bool? firstTime = prefs.getBool("firstTime");
    if (firstTime != null && !firstTime) {
      numLocations = prefs.getInt('numLocations')!;
      // Not first time
      if (widget.data != null) {
        // Check if the user has selected a location from ocation screen and add it to prefs
        // numLocations = prefs.getInt('numLocations')! + 1;
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
        'America/Chicago',
        'Chicago, America | ${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneName}',
        'UTC ${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.isNegative ? "-" : "+"}${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs()}' : '0${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inHours.abs()}'}:${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}' : '0${tz.TZDateTime.now(tz.getLocation("America/Chicago")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}'}',
      ]);

      await prefs.setStringList('Location 2', [
        'Australia/Sydney',
        "Sydney, Australia | ${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneName}",
        'UTC ${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.isNegative ? "-" : "+"}${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs()}' : '0${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inHours.abs()}'}:${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt() >= 10 ? '${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}' : '0${tz.TZDateTime.now(tz.getLocation("Australia/Sydney")).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}'}',
      ]);
    }

    for (var i = 1; i <= numLocations; i++) {
      List<String>? locationData = prefs.getStringList('Location $i');
      if (locationData != null) {
        countryCards.add(
          UpdateCountryCard(
              locationName: tz.getLocation(locationData[0]),
              locationString: locationData[1],
              locationOffset: locationData[2]),
        );
      }
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrLocation();
    getCountryCards();
    // if (isFirstTime() == true) {
    //   print("Is First Time");
    //   firstTimeStartup();
    //   print("Finished is first time locationCounter = $locationCounter");
    // } else {
    //   getLocationData();
    //   // widget.countryCards.add(UpdateCountryCard(
    //   //     locationName: widget.data?['placeLocation'],
    //   //     locationString: widget.data?['placeName'],
    //   //     locationOffset: widget.data?['placeUtcOffset']));
    // }
    // getAllCountryCardsFromPrefs();
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
              overflow: TextOverflow.ellipsis,
            ),
            const TimeInHourAndMinute(),
            const Spacer(),
            const Clock(),
            const Spacer(),
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

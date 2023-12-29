// ignore_for_file: avoid_print

import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone_to_country/timezone_to_country.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late final List<({String name, tz.Location location})> locations;
  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final Set<String> duplicates = {};
    locations = [];
    for (final location in tz.timeZoneDatabase.locations.entries) {
      final Set<String> allowedContinents = {
        "Africa",
        "America",
        "Antarctica",
        "Arctic",
        "Asia",
        "Atlantic",
        "Australia",
        "Brazil",
        "Canada",
        "Chile",
        "Cuba",
        "EST",
        "Egypt",
        "Eire",
        "Etc",
        "Europe",
        "Greenwich",
        "Hongkong",
        "Iceland",
        "Indian",
        "Iran",
        "Israel",
        "Jamaica",
        "Japan",
        "Kwajalein",
        "Libya",
        "Mexico",
        "Pacific",
        "Poland",
        "Portugal",
        "Singapore",
        "Turkey",
        "US",
        "UTC",
        "Zulu"
      };
      final List<String> parts = location.key.split('/');

      if (!allowedContinents.contains(parts.first)) {
        // Not allowed, skip
        print("Found a not allowed $location");
        continue;
      }
      final String name;
      if (parts.length > 1) {
        if (parts.first == 'Etc') {
          // Etc/x
          name = "Etc - ${parts.last}";
        } else {
          // Multiple parts
          for (var part in parts) {
            if (part.contains("_")) {
              parts[parts.indexOf(part)] = part.replaceAll("_", " ");
            }
          }
          name =
              '${parts.reversed.join(', ')} | ${tz.TZDateTime.now(location.value).timeZoneName}';
        }
      } else {
        // Only one part
        name = location.key;
      }
      if (duplicates.contains(name)) {
        // Duplicate, skip
        print('Found duplicate $name');
        continue;
      }
      locations.add((name: name, location: location.value));
      duplicates.add(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          "Location Choose Page",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/', arguments: {
                  'placeLocation': locations[index].location,
                  'placeName': locations[index].name,
                  'placeUtcOffset':
                      'UTC ${tz.TZDateTime.now(locations[index].location).timeZoneOffset.isNegative ? "-" : "+"}${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inHours.abs() >= 10 ? '${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inHours.abs()}' : '0${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inHours.abs()}'}:${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inMinutes.remainder(60).abs().toInt() >= 10 ? '${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}' : '0${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}'}',
                });
              },
              title: Text(
                locations[index].name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                'UTC ${tz.TZDateTime.now(locations[index].location).timeZoneOffset.isNegative ? "-" : "+"}${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inHours.abs() >= 10 ? '${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inHours.abs()}' : '0${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inHours.abs()}'}:${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inMinutes.remainder(60).abs().toInt() >= 10 ? '${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}' : '0${tz.TZDateTime.now(locations[index].location).timeZoneOffset.inMinutes.remainder(60).abs().toInt()}'}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              leading: locations[index].name == "UTC"
                  ? const CircleAvatar(
                      backgroundImage: AssetImage('assets/icons/UTCImage.png'),
                      radius: 17,
                    )
                  : Flag.fromString(
                      locations[index].location.countryCode,
                      height: 20,
                      width: 30,
                    ),
            ),
          );
        },
      ),
    );
  }
}

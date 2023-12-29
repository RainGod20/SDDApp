// ignore_for_file: camel_case_types

import 'dart:async';

import 'package:flag/flag.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone_to_country/timezone_to_country.dart';

class UpdateCountryCard extends StatefulWidget {
  const UpdateCountryCard({
    super.key,
    required this.locationName,
    required this.locationString,
    required this.locationOffset,
    required this.cardIndex,
  });

  final tz.Location locationName;
  final String locationString;
  final String locationOffset;
  final int cardIndex;

  @override
  State<UpdateCountryCard> createState() => Update_CountryCardState();
}

class Update_CountryCardState extends State<UpdateCountryCard> {
  late tz.Location locationName;
  late String locationString;
  late String locationOffset;
  late int cardIndex;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    locationName = widget.locationName;
    locationString = widget.locationString;
    locationOffset = widget.locationOffset;
    cardIndex = widget.cardIndex;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Timezone calculations
    tz.initializeTimeZones();
    var locationNow = tz.TZDateTime.now(locationName);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
          child: SizedBox(
            width: getProportionateScreenWidth(233),
            child: AspectRatio(
              aspectRatio: 1.32,
              child: Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).primaryIconTheme.color!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locationString,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: getProportionateScreenWidth(16)),
                    ),
                    const SizedBox(height: 5),
                    Text(locationOffset),
                    const Spacer(),
                    Row(
                      children: [
                        locationName.toString() == "UTC"
                            ? const CircleAvatar(
                                backgroundImage: AssetImage('assets/icons/UTCImage.png'),
                                radius: 17,
                              )
                            : Flag.fromString(
                                locationName.countryCode,
                                height: getProportionateScreenHeight(35),
                                width: getProportionateScreenWidth(40),
                              ),
                        const Spacer(),
                        Text(
                          DateFormat('hh:mm').format(locationNow),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        RotatedBox(
                          quarterTurns: 3,
                          child: Text(DateFormat('a').format(locationNow)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/',
                  arguments: {'removeCardIndex': cardIndex});
            },
            child: Container(
              width: getProportionateScreenWidth(32),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.do_disturb_on,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:clock_app_flutter/screens/home_screen/components/clock.dart';
import 'package:clock_app_flutter/screens/home_screen/components/country_card.dart';
import 'package:clock_app_flutter/screens/home_screen/components/time_in_hour_and_minute.dart';
import 'package:clock_app_flutter/screens/services/world_time.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  Body({super.key});
  List locations = ["America/New_York", "Australia/Sydney"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Text(
              "Newport Beach, USA | PST",
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

import 'dart:async';

import 'package:clock_app_flutter/screens/services/world_time.dart';
import 'package:flag/flag.dart';
import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class UpdateCountryCard extends StatefulWidget {
  const UpdateCountryCard({super.key, required this.flag, required this.url});
  final String flag, url;

  @override
  State<UpdateCountryCard> createState() => Update_CountryCardState();
}

class Update_CountryCardState extends State<UpdateCountryCard> {
  String location = "America/Detroit";

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Timezone calculations
    tz.initializeTimeZones();
    var detroitNow = tz.TZDateTime.now(tz.getLocation(location));

    // countryTime = setupCountryTime(countryTime) as List<String>;
    return Padding(
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
                  detroitNow.timeZoneName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: getProportionateScreenWidth(16)),
                ),
                SizedBox(height: 5),
                Text(detroitNow.timeZoneOffset.toString().split('.').first.padLeft(8, "0")),
                Spacer(),
                Row(
                  children: [
                    // SvgPicture.asset(
                    //   Flag.fromCode(FlagsCode.US),
                    //   width: getProportionateScreenWidth(40),
                    //   color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                    // ),
                    Flag.fromCode(
                      FlagsCode.US,
                      width: getProportionateScreenWidth(40),
                      height: getProportionateScreenHeight(35),
                    ),
                    Spacer(),
                    Text(
                      DateFormat('hh:mm').format(detroitNow),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Text(DateFormat('a').format(detroitNow)),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class CountryCard extends StatelessWidget {
//   CountryCard({
//     super.key,
//     required this.flag,
//     required this.url,
//   });

//   final String flag, url;

//   // Future<List<String>> setupCountryTime(List<String> countryTime) async {
//   //   print("Flag: $flag, URL: $url");
//   //   print("got to setupCountryTime");
//   //   WorldTime instance = WorldTime(flag: flag, url: url);
//   //   print("countryTime1: $instance");
//   //   await instance.getTime();
//   //   print("countryTime2: $instance");
//   //   return countryTime = [
//   //     instance.countryAndCity,
//   //     instance.offsetAndAbbrev,
//   //     instance.flag,
//   //     instance.time,
//   //     instance.period
//   //   ];
//   //   // countryTime[0] = instance.countryAndCity;
//   //   // countryTime[1] = instance.offsetAndAbbrev;
//   //   // countryTime[2] = instance.flag;
//   //   // countryTime[3] = instance.time;
//   //   // countryTime[4] = instance.period;
//   // }

//   // late List<String> countryTime = setupCountryTime(countryTime) as List<String>;

//   @override
//   Widget build(BuildContext context) {
//     tz.initializeTimeZones();
//     var detroit = tz.getLocation('America/Detroit');
//     var detroitNow = tz.TZDateTime.now(detroit);

//     // countryTime = setupCountryTime(countryTime) as List<String>;
//     return Padding(
//       padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
//       child: SizedBox(
//         width: getProportionateScreenWidth(233),
//         child: AspectRatio(
//           aspectRatio: 1.32,
//           child: Container(
//             padding: EdgeInsets.all(getProportionateScreenWidth(20)),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: Theme.of(context).primaryIconTheme.color!,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   detroitNow.timeZoneName,
//                   style: Theme.of(context)
//                       .textTheme
//                       .headlineMedium
//                       ?.copyWith(fontSize: getProportionateScreenWidth(16)),
//                 ),
//                 SizedBox(height: 5),
//                 Text(detroitNow.timeZoneOffset.toString()),
//                 Spacer(),
//                 Row(
//                   children: [
//                     // SvgPicture.asset(
//                     //   Flag.fromCode(FlagsCode.US),
//                     //   width: getProportionateScreenWidth(40),
//                     //   color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
//                     // ),
//                     Flag.fromCode(
//                       FlagsCode.US,
//                       width: getProportionateScreenWidth(40),
//                       height: 64,
//                     ),
//                     Spacer(),
//                     Text(
//                       DateFormat('hh:mm').format(detroitNow),
//                       style: Theme.of(context).textTheme.headlineMedium,
//                     ),
//                     RotatedBox(
//                       quarterTurns: 3,
//                       child: Text(DateFormat('a').format(detroitNow)),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

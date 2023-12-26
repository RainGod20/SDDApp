import 'package:clock_app_flutter/screens/services/world_time.dart';
import 'package:flutter/material.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Location Choose Page",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
    );
  }
}

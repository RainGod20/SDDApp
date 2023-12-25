import 'package:flutter/material.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Location Choose Page",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
      ),
    );
  }
}

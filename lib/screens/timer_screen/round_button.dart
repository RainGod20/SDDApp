import 'package:clock_app_flutter/size_config.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    super.key,
    required this.icon,
  });
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenHeight(8),
      ),
      child: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        radius: getProportionateScreenWidth(30),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.secondary,
          size: getProportionateScreenWidth(36),
        ),
      ),
    );
  }
}

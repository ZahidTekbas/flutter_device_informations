import 'package:flutter/material.dart';
import 'package:battery_indicator/battery_indicator.dart';

class Indicator extends StatefulWidget {
  @override
  _IndicatorState createState() => _IndicatorState();
}

class _IndicatorState extends State<Indicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: BatteryIndicator(
          ratio: 4.0,
          style: BatteryIndicatorStyle.skeumorphism,
          size: 20.0,
        ));
  }
}

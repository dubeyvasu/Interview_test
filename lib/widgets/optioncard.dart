import 'package:flutter/material.dart';
class OptionCard extends StatelessWidget {
  const OptionCard({
    Key? key,
    required this.option,
    required this.color,
    required this.optionLetter,
  }) : super(key: key);
  
  final String option;
  final Color color;
  final String optionLetter;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: ListTile(
        leading: Text(
          optionLetter,
          style: TextStyle(
            fontSize: 18.0,
            color: color.red != color.green ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          option,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 18.0,
            color: color.red != color.green ? Colors.white  : Colors.black,
          ),
        ),
      ),
    );
  }
}

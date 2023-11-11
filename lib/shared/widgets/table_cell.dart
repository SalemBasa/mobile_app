import 'package:flutter/material.dart';

class TableCellWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final Function()? onTap; // Add the onTap parameter

  TableCellWidget({
    required this.text,
    this.textColor = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Use the onTap parameter
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(
              color: Color(0xFFE0D8E0),
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}

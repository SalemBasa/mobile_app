import 'package:flutter/material.dart';

class TableCellWidget extends StatelessWidget {
  final String text;
  final Color textColor;

  TableCellWidget({
    required this.text,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
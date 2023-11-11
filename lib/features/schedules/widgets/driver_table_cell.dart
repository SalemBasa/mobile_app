import 'package:flutter/material.dart';
import 'dart:convert';

class DriverTableCellWidget extends StatelessWidget {
  final String jsonData;

  DriverTableCellWidget({required this.jsonData});

  Future<String> extractDriverIds() async {
    try {
      if (jsonData.isNotEmpty) {
        final List<dynamic> driverData = json.decode(jsonData);
        final List<int> driverIds = driverData
            .map((data) => data['driverId'] as int)
            .toList();
        final String driverIdsString = driverIds.join(', ');
        return driverIdsString;
      }
    } catch (e) {
      print('Error extracting driver IDs: $e');
    }
    return ''; // Return an empty string if there is an error or no data
  }

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: FutureBuilder<String>(
        future: extractDriverIds(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Display loading indicator while fetching driver IDs
          } else if (snapshot.hasError) {
            return Text('Error'); // Display an error message if something goes wrong
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(snapshot.data ?? ''),
            );
          }
        },
      ),
    );
  }
}

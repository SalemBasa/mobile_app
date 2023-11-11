import 'package:flutter/material.dart';
import 'package:trash_track_mobile/features/quiz/screens/quizzes_screen.dart';
import 'package:trash_track_mobile/features/report/screens/add_report.dart';
import 'package:trash_track_mobile/features/reservation/screens/add-reservation.dart';
import 'package:trash_track_mobile/features/schedules/screens/schedules_screen.dart';

class MainScreenDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationScreenDriver(),
    );
  }
}

class NavigationScreenDriver extends StatefulWidget {
  @override
  _NavigationScreenDriverState createState() => _NavigationScreenDriverState();
}

class _NavigationScreenDriverState extends State<NavigationScreenDriver> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      AddReportScreen(),
      SchedulesScreen()
    ];

    return Column(
      children: <Widget>[
        Expanded(
          child: _screens[_currentIndex],
        ),
        BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.report),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'Schedules',
            )
          ],
        ),
      ],
    );
  }
}
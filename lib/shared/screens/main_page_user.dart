import 'package:flutter/material.dart';
import 'package:trash_track_mobile/features/quiz/screens/quizzes_screen.dart';
import 'package:trash_track_mobile/features/report/screens/add_report.dart';
import 'package:trash_track_mobile/features/reservation/screens/add-reservation.dart';

class MainScreenUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NavigationScreenUser(),
    );
  }
}

class NavigationScreenUser extends StatefulWidget {
  @override
  _NavigationScreenUserState createState() => _NavigationScreenUserState();
}

class _NavigationScreenUserState extends State<NavigationScreenUser> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      AddReportScreen(),
      ReservationAddScreen(),
      QuizzesScreen(),
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
              icon: Icon(Icons.calendar_month),
              label: 'Reservation',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.quiz),
              label: 'Quiz',
            ),
          ],
        ),
      ],
    );
  }
}
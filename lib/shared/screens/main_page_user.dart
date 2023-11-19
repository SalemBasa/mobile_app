// import 'package:flutter/material.dart';
// import 'package:trash_track_mobile/features/order/screens/orders_screen.dart';
// import 'package:trash_track_mobile/features/products/screens/product_screen.dart';
// import 'package:trash_track_mobile/features/quiz/screens/quizzes_screen.dart';
// import 'package:trash_track_mobile/features/report/screens/add_report.dart';
// import 'package:trash_track_mobile/features/reservation/screens/add-reservation.dart';

// class MainScreenUser extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: NavigationScreenUser(),
//     );
//   }
// }

// class NavigationScreenUser extends StatefulWidget {
//   @override
//   _NavigationScreenUserState createState() => _NavigationScreenUserState();
// }

// class _NavigationScreenUserState extends State<NavigationScreenUser> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final List<Widget> _screens = [
//       AddReportScreen(),
//       ReservationAddScreen(),
//       // QuizzesScreen(),
//       ProductsScreen()
//       // OrdersScreen()
//     ];

//     return Column(
//       children: <Widget>[
//         Expanded(
//           child: _screens[_currentIndex],
//         ),
//         BottomNavigationBar(
//           currentIndex: _currentIndex,
//           onTap: (int index) {
//             setState(() {
//               _currentIndex = index;
//             });
//           },
//           items: [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.report),
//               label: 'Reports',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.calendar_month),
//               label: 'Reservation',
//             ),
//             // BottomNavigationBarItem(
//             //   icon: Icon(Icons.quiz),
//             //   label: 'Quiz',
//             // ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.production_quantity_limits),
//               label: 'Products',
//             ),
//             //  BottomNavigationBarItem(
//             //   icon: Icon(Icons.list),
//             //   label: 'Orders',
//             // ),
//           ],
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:trash_track_mobile/features/cart/screens/cart_screen.dart';
import 'package:trash_track_mobile/features/order/screens/orders_screen.dart';
import 'package:trash_track_mobile/features/products/screens/product_screen.dart';
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

  final List<Widget> _screens = [
    AddReportScreen(),
    ReservationAddScreen(),
    QuizzesScreen(),
    ProductsScreen(),
    OrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trash Track'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Trash Track Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.report),
              title: Text('Reports'),
              onTap: () {
                _changeScreen(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('Reservation'),
              onTap: () {
                _changeScreen(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.quiz),
              title: Text('Quiz'),
              onTap: () {
                _changeScreen(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.production_quantity_limits),
              title: Text('Products'),
              onTap: () {
                _changeScreen(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text('Orders'),
              onTap: () {
                _changeScreen(4);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
    );
  }

  void _changeScreen(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

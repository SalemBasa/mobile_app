import 'package:flutter/material.dart';
import 'package:trash_track_mobile/features/garbage/screens/add-garbage.dart';
import 'package:trash_track_mobile/features/report/screens/add_report.dart';
import 'package:trash_track_mobile/features/reservation/screens/add-reservation.dart';
import 'package:trash_track_mobile/features/user/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AuthService _authService; // Remove the initialization here

  @override
  void initState() {
    super.initState();
    _authService = AuthService(); // Initialize AuthService in initState
  }

  void _handleSignIn() async {
  final email = _emailController.text;
  final password = _passwordController.text;

  final token = await _authService.signIn(email, password);

  if (token != null) {
    // Login successful, navigate to the AddReportScreen and pass the selectedGarbageId if needed.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ReservationAddScreen(), // Pass the selectedGarbageId here
      ),
    );
  } else {
    // Login failed, show an error message to the user.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid email or password. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color set to white
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Login to Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400, // Adjust the width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white, // Input background color
                border: Border.all(
                  color: Color(0xFF49464E), // Border color when not focused
                ),
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email), // Email icon
                  border: InputBorder.none, // Remove default input border
                ),
                style: TextStyle(
                  color: Color(0xFF49464E), // Text color when focused
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 400, // Adjust the width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white, // Input background color
                border: Border.all(
                  color: Color(0xFF49464E), // Border color when not focused
                ),
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock), // Password icon
                  border: InputBorder.none, // Remove default input border
                ),
                style: TextStyle(
                  color: Color(0xFF49464E), // Text color when focused
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Color(0xFF49464E), 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSignIn,
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF49464E), // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Button border radius
                ),
                minimumSize: Size(400, 48), // Button size
              ),
            ),
          ],
        ),
      ),
    );
  }
}

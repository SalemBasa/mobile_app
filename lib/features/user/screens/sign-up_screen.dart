import 'package:flutter/material.dart';
import 'package:trash_track_mobile/features/user/services/auth_service.dart';
import 'package:trash_track_mobile/shared/services/enums_service.dart';
import 'package:trash_track_mobile/features/user/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late EnumsService _enumsService;
  late int _selectedRoleIndex;
  late Map<int, String> _roles;
  bool _isLoading = true;

  late AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _enumsService = EnumsService();
    _selectedRoleIndex = 0; // Set the default vehicle type
    _fetchRoles();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchRoles() async {
    try {
      final typesData = await _enumsService.getRoles();

      if (typesData is Map<int, String>) {
        setState(() {
          _roles = typesData;
          _isLoading = false;
        });
      } else {
        print('Received unexpected data format for roles: $typesData');
      }
    } catch (error) {
      print('Error fetching roles: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Create account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFF49464E),
                ),
              ),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  prefixIcon: Icon(Icons.person),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Color(0xFF49464E),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFF49464E),
                ),
              ),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  prefixIcon: Icon(Icons.person),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Color(0xFF49464E),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFF49464E),
                ),
              ),
              child: TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Color(0xFF49464E),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFF49464E),
                ),
              ),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Color(0xFF49464E),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFF49464E),
                ),
              ),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: Color(0xFF49464E),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : SizedBox(
                    width: 400,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: const Color(0xFF49464E),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButtonFormField<int>(
                            value: _selectedRoleIndex,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedRoleIndex = newValue ?? 0;
                              });
                            },
                            items: _roles.entries.map((entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Roles',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              color: const Color(0xFF49464E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: TextButton(
                onPressed:
                    null, // Set to null to make it disabled initially, as GestureDetector handles the tap
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Color(0xFF49464E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // final _selectedRole = Role.values[_selectedRoleIndex];

                final userObject = {
                  'firstName': _firstNameController.text,
                  'lastName': _lastNameController.text,
                  'phoneNumber': _phoneNumberController.text,
                  'email': _emailController.text,
                  'password': _passwordController.text,
                  'role': _selectedRoleIndex
                };

                try {
                  await _authService.signUp(userObject);

                  // Sign-up successful, navigate to a success screen or perform other actions.
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                } catch (error) {
                  // Sign-up failed, show an error message to the user.
                  showDialog(
                    context: context,
                    builder: (context) {
                      print(error);
                      return AlertDialog(
                        title: Text('Sign Up Failed'),
                        content: Text(
                          'An error occurred during sign-up. Please try again. Error: $error',
                        ),
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
              },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF49464E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(400, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

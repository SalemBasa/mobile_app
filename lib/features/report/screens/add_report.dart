import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_track_mobile/features/notifications/services/notification_provider.dart';
import 'package:trash_track_mobile/features/photo/models/photo.dart';
import 'package:trash_track_mobile/features/report/models/report.dart';
import 'package:trash_track_mobile/features/report/screens/garbage_map.dart';
import 'package:trash_track_mobile/features/report/services/reports_service.dart';
import 'package:trash_track_mobile/features/report/widgets/garbage_input.dart';
import 'package:trash_track_mobile/features/report/widgets/image_input.dart';
import 'package:trash_track_mobile/shared/services/enums_service.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AddReportScreen extends StatefulWidget {
  AddReportScreen({Key? key}) : super(key: key);

  @override
  State<AddReportScreen> createState() {
    return _AddReportScreenState();
  }
}

class _AddReportScreenState extends State<AddReportScreen> {
  late TextEditingController _noteController;
  File? _selectedImage;
  late EnumsService _enumsService;
  late NotificationProvider notificationProvider;
  late int _selectedReportTypeIndex;
  late Map<int, String> _reportTypes;
  bool _isLoading = true;
  final reportService = ReportService();
  int? userId;
  int? selectedGarbageId;
  String? _selectedImageBase64;

  @override
  void initState() {
    super.initState();
    _enumsService = EnumsService();
    notificationProvider = NotificationProvider();
    _noteController = TextEditingController();
    _selectedReportTypeIndex = 0;
    _fetchReportTypes();
    _fetchUserIdFromToken();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserIdFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      final userIdString = decodedToken['Id'];

      if (userIdString != null) {
        setState(() {
          userId = int.tryParse(userIdString);
        });
      }
    }
  }

  Future<void> _fetchReportTypes() async {
    try {
      final typesData = await _enumsService.getReportTypes();

      if (typesData is Map<int, String>) {
        setState(() {
          _reportTypes = typesData;
          _isLoading = false;
        });
      } else {
        print('Received unexpected data format for report types: $typesData');
      }
    } catch (error) {
      print('Error fetching report types: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const SizedBox(height: 50),
            Text(
              'Create Report',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Note',
                labelStyle: TextStyle(
                  color: const Color(0xFF49464E),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF49464E),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: const Color(0xFF49464E),
                  ),
                ),
              ),
              controller: _noteController,
              style: TextStyle(
                color: const Color(0xFF49464E),
              ),
            ),
            const SizedBox(height: 16),
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
                            value: _selectedReportTypeIndex,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedReportTypeIndex = newValue ?? 0;
                              });
                            },
                            items: _reportTypes.entries.map((entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Report Type',
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final _selectedGarbageId = await Navigator.push<int>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GarbageMapScreen(
                      onGarbageSelected: (garbageId) {},
                    ),
                  ),
                );
                setState(() {
                  selectedGarbageId = _selectedGarbageId;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_on, // Add the location icon
                    color: Colors.white, // Set the icon color
                  ),
                  SizedBox(width: 8), // Add some space between icon and text
                  Text('Select Garbage'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF49464E),
                minimumSize: Size(400, 48),
              ),
            ),
            const SizedBox(height: 16),
            ImageInput(
              onPickImage: (image, base64Image) {
                _selectedImage = image;
                _selectedImageBase64 = base64Image;
              },
            ),
            SizedBox(height: 26),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () async {
                  final newName = _noteController.text;
                  if (newName.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Note cannot be empty.'),
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
                    return;
                  }

                  final _selectedReportType =
                      ReportType.values[_selectedReportTypeIndex];

                  final newReport = Report(
                      note: newName,
                      reportType: _selectedReportType,
                      reporterUserId: userId,
                      garbageId: selectedGarbageId,
                      photo: _selectedImageBase64);

                  try {
                    await reportService.insert(newReport);
                    
                    await notificationProvider.sendRabbitNotification({
                      "title": "Created new report",
                      "content":
                          "Successfully submited new report, type : ${newReport.reportType}",
                      "isRead": false,
                      "userId": 1
                    });

                    showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Successfully created report!'),
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

                  } catch (error) {
                    print('Error adding report: $error');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    const Text('Add Report'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF49464E),
                  minimumSize: Size(400, 48),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

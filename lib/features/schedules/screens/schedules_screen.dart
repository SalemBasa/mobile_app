import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:trash_track_mobile/features/schedules/models/schedule.dart';
import 'package:trash_track_mobile/features/schedules/screens/garbage_display_screen.dart';
import 'package:trash_track_mobile/features/schedules/service/schedule_service.dart';
import 'package:trash_track_mobile/features/user/services/users_service.dart';
import 'package:trash_track_mobile/shared/widgets/paging_component.dart';
import 'package:trash_track_mobile/shared/widgets/table_cell.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({Key? key, this.schedule}) : super(key: key);

  final Schedule? schedule;

  @override
  _SchedulesScreenState createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  late ScheduleService _scheduleService;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Schedule> _schedules = [];
  int? userId;

  PickupStatus? _selectedPickupStatus;

  int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _scheduleService = context.read<ScheduleService>();
    _initialValue = {
      'id': widget.schedule?.id.toString(),
      'pickupDate': widget.schedule?.pickupDate,
      'status': widget.schedule?.status,
      'vehicleId': widget.schedule?.vehicleId,
      'vehicle': widget.schedule?.vehicle,
      'scheduleDrivers': widget.schedule?.scheduleDrivers,
      'scheduleGarbages': widget.schedule?.scheduleGarbages,
    };
    _fetchUserIdAndLoadSchedules();
  }

  Future<void> _fetchUserIdAndLoadSchedules() async {
    await _fetchUserIdFromToken(); // Wait for userId to be fetched
    _loadPagedSchedules(); // After userId is fetched, load schedules
  }

  Future<void> _fetchUserIdFromToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      Map<String, dynamic> decodedToken = Jwt.parseJwt(token);
      final userIdString = decodedToken['Id']; // Extract the ID as a string

      if (userIdString != null) {
        // Convert the string to an integer
        setState(() {
          userId = int.tryParse(
              userIdString); // Use tryParse to handle invalid inputs
        });
      }
    }
  }

  Future<void> _loadPagedSchedules() async {
    try {
      final models = await _scheduleService.getPaged(
        filter: {
          'driverId': userId,
          'pickupStatus': mapPickupStatusToString(_selectedPickupStatus),
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _schedules = models.items;
        _totalRecords = models.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  String mapPickupStatusToString(PickupStatus? pickupStatus) {
    switch (pickupStatus) {
      case PickupStatus.completed:
        return 'Completed';
      case PickupStatus.pending:
        return 'Pending';
      case PickupStatus.cancelled:
        return 'Cancelled';
      default:
        return pickupStatus.toString(); // Default to enum value if not found
    }
  }

  void _onDisplayGarbages(List<int> garbageIds) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScheduleGarbageScreen(garbageIds: garbageIds),
      ),
    );
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedSchedules();
  }

  Future<List<int>> _fetchDriverIdsForSchedule(int? scheduleId) async {
    final url = Uri.parse(
        'http://localhost:5057/api/ScheduleDrivers/BySchedule?scheduleId=$scheduleId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<int>();
    } else {
      throw Exception('Failed to load driver IDs');
    }
  }

  Future<Widget> _buildDriverIdsForScheduleAsync(int? scheduleId) async {
    final driverIds = await _fetchDriverIdsForSchedule(scheduleId);
    return Text(driverIds.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      'Schedule',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Schedule.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 1,
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
                      child: Container(
                        alignment: Alignment.center,
                        child: DropdownButtonFormField<PickupStatus>(
                          value: _selectedPickupStatus,
                          onChanged: (newValue) {
                            print(newValue);
                            setState(() {
                              _selectedPickupStatus = newValue;
                            });
                            _loadPagedSchedules();
                          },
                          items: [
                            DropdownMenuItem<PickupStatus>(
                              value: null,
                              child: Text('Choose the pickup status'),
                            ),
                            ...PickupStatus.values.map((type) {
                              return DropdownMenuItem<PickupStatus>(
                                value: type,
                                child: Text(mapPickupStatusToString(type)),
                              );
                            }).toList(),
                          ],
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Color(0xFF49464E),
                          ),
                          icon: Container(
                            alignment: Alignment.center,
                            child: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xFFE0D8E0),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Table(
                border: TableBorder.all(
                  color: Colors.transparent,
                ),
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Color(0xFFF7F1FB),
                    ),
                    children: [
                      TableCellWidget(text: 'Pickup date'),
                      TableCellWidget(text: 'Pickup status'),
                      TableCellWidget(text: 'Drivers'),
                      TableCellWidget(text: 'Vehicle'),
                      TableCellWidget(text: 'Locations'),
                    ],
                  ),
                  if (_isLoading)
                    TableRow(
                      children: [
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                      ],
                    )
                  else
                    ..._schedules.asMap().entries.map((entry) {
                      final index = entry.key;
                      final schedule = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(
                              text: DateFormat('dd/MM/yyyy').format(
                                  schedule.pickupDate ?? DateTime.now())),
                          TableCellWidget(
                              text: mapPickupStatusToString(schedule.status!)),
                          TableCellWidget(
                              text: schedule.scheduleDrivers!
                                  .map((e) => e.driverId)
                                  .join(', ')),
                          TableCellWidget(
                              text: schedule.vehicle?.licensePlateNumber ?? ''),
                          TableCell(
                            child: IconButton(
                              onPressed: () {
                                final garbageIds = schedule.scheduleGarbages!
                                    .map((e) => e.garbageId)
                                    .where((id) => id != null)
                                    .map((id) => id!)
                                    .toList();
                                _onDisplayGarbages(garbageIds);
                              },
                              icon: Icon(
                                Icons.location_on,
                                color: Color(0xFF49464E),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PagingComponent(
        currentPage: _currentPage,
        itemsPerPage: _itemsPerPage,
        totalRecords: _totalRecords,
        onPageChange: _handlePageChange,
      ),
    );
  }
}

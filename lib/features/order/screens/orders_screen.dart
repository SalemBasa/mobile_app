import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_track_mobile/features/order/models/order.dart';
import 'package:trash_track_mobile/features/order/services/order_service.dart';
import 'dart:convert';

import 'package:trash_track_mobile/features/schedules/models/schedule.dart';
import 'package:trash_track_mobile/features/schedules/screens/garbage_display_screen.dart';
import 'package:trash_track_mobile/features/schedules/service/schedule_service.dart';
import 'package:trash_track_mobile/features/user/services/users_service.dart';
import 'package:trash_track_mobile/shared/widgets/paging_component.dart';
import 'package:trash_track_mobile/shared/widgets/table_cell.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key, this.order}) : super(key: key);

  final Order? order;

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late OrderService _orderService;
  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;
  List<Order> _orders = [];
  int? userId;

  int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _orderService = context.read<OrderService>();
    _initialValue = {
      'id': widget.order?.id.toString(),
      'orderDate': widget.order?.orderDate,
      'total': widget.order?.total,
      'isCanceled': widget.order?.isCanceled,
      'userId': widget.order?.userId,
      'user': widget.order?.user,
      'orderDetails': widget.order?.orderDetails,
    };
    _fetchUserIdAndLoadOrders();
  }

  Future<void> _fetchUserIdAndLoadOrders() async {
    await _fetchUserIdFromToken(); // Wait for userId to be fetched
    _loadPagedSOrders(); // After userId is fetched, load schedules
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

  Future<void> _loadPagedSOrders() async {
    try {
      final models = await _orderService.getPaged(
        filter: {
          'userId': userId,
          'pageNumber': _currentPage,
          'pageSize': _itemsPerPage,
        },
      );

      setState(() {
        _orders = models.items;
        _totalRecords = models.totalCount;
        _isLoading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void _handlePageChange(int newPage) {
    setState(() {
      _currentPage = newPage;
    });

    _loadPagedSOrders();
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
                      'Orders',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D1C1E),
                      ),
                    ),
                    Text(
                      'A summary of the Order.',
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
                      TableCellWidget(text: 'Order Number'),
                      TableCellWidget(text: 'Order Date'),
                      TableCellWidget(text: 'OrderDetails'),
                      TableCellWidget(text: 'Total'),
                    ],
                  ),
                  if (_isLoading)
                    TableRow(
                      children: [
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                        TableCellWidget(text: 'Loading...'),
                      ],
                    )
                  else
                    ..._orders.asMap().entries.map((entry) {
                      final index = entry.key;
                      final order = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        children: [
                          TableCellWidget(text: order.orderNumber!),
                          TableCellWidget(
                              text: DateFormat('dd/MM/yyyy')
                                  .format(order.orderDate ?? DateTime.now())),
                          TableCellWidget(
                              text: order.orderDetails!
                                  .map((e) => e.product?.name)
                                  .join(', ')),
                          TableCellWidget(text: order.total.toString() ?? ''),
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

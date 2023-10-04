import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_track_mobile/features/reservation/models/reservation.dart';
import 'package:trash_track_mobile/features/reservation/services/reservation_service.dart';
import 'package:trash_track_mobile/features/reservation/widgets/location_input.dart';
import 'package:trash_track_mobile/features/services/models/service.dart';
import 'package:trash_track_mobile/features/services/services/services_service.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:trash_track_mobile/shared/services/enums_service.dart';

class ReservationAddScreen extends StatefulWidget {
  ReservationAddScreen({Key? key}) : super(key: key);

  @override
  State<ReservationAddScreen> createState() => _ReservationAddScreenState();
}

class _ReservationAddScreenState extends State<ReservationAddScreen> {
  late ReservationService _reservationService;
  List<Service> _services = [];
  late int _selectedServiceId = 0;
  late ServicesService _servicesService;
  bool _isLoading = true;
  Reservation? _selectedLocation;
  int? userId;
  late EnumsService _enumsService;
  late int _selectedReservationStatusIndex;
  late Map<int, String> _reservationStatus;
  late double _selectedServicePrice;

  @override
  void initState() {
    super.initState();
    _reservationService = ReservationService();
    _servicesService = ServicesService();
    _enumsService = EnumsService();
    _selectedServiceId = 0;
    _loadServices();
    _fetchUserIdFromToken();
    _selectedReservationStatusIndex = 0;
    _fetchReservationStatus();
    _selectedServicePrice = 0.0; // Initialize with default value
  }

  @override
  void dispose() {
    super.dispose();
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

  Future<void> _fetchReservationStatus() async {
    try {
      final typesData = await _enumsService.getReservationStatus();

      if (typesData is Map<int, String>) {
        setState(() {
          _reservationStatus = typesData;
          _isLoading = false;
        });
      } else {
        print(
            'Received unexpected data format for reservation status: $typesData');
      }
    } catch (error) {
      print('Error fetching reservation status: $error');
    }
  }

  Future<void> _loadServices() async {
    try {
      final services = await _servicesService.getPaged();
      setState(() {
        _services = [Service(id: 0, name: 'Choose a Service')] + services.items;
        _isLoading = false; // Mark loading as complete
      });

      // Set the initial selected service price
      if (_services.isNotEmpty) {
        _selectedServicePrice = _services[0].price ?? 0.0;
      }
    } catch (error) {
      print('Error loading services: $error');
      setState(() {
        _isLoading = false; // Mark loading as complete even on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Text(
              'Create Reservation',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
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
                            value: _selectedReservationStatusIndex,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedReservationStatusIndex = newValue ?? 0;
                              });
                            },
                            items: _reservationStatus.entries.map((entry) {
                              return DropdownMenuItem<int>(
                                value: entry.key,
                                child: Text(entry.value),
                              );
                            }).toList(),
                            decoration: InputDecoration(
                              labelText: 'Reservation Status',
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
            const SizedBox(height: 10),
            SizedBox(
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
                      value: _selectedServiceId,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedServiceId = newValue ?? 0;
                          // Update the selected service's price
                          final selectedService = _services.firstWhere(
                              (service) => service.id == _selectedServiceId,
                              orElse: () => Service(price: 0.0));
                          _selectedServicePrice = selectedService.price ?? 0.0;

                          print(_selectedServicePrice);
                        });
                      },
                      items: _services.map((model) {
                        return DropdownMenuItem<int>(
                          value: model.id,
                          child: Text((model.name ?? '') +
                              ' ' +
                              (_selectedServicePrice.toString() ?? '')),
                        );
                      }).toList(),
                      decoration: InputDecoration(
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
            const SizedBox(height: 10),
            CurrentLocation(
              onSelectLocation: (location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 400,
              child: ElevatedButton(
                onPressed: () async {
                  final _selectedReportState =
                      ReservationStatus.values[_selectedReservationStatusIndex];

                  final newReservation = Reservation(
                    serviceId: _selectedServiceId,
                    userId: userId,
                    latitude: _selectedLocation!.latitude,
                    longitude: _selectedLocation!.longitude,
                    reservationStatus: _selectedReportState,
                    price:
                        _selectedServicePrice, // Set the price from the selected service
                  );

                  try {
                    await _reservationService.insert(newReservation);
                  } catch (error) {
                    print('Error adding reservation: $error');
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    const Text('Create Reservation'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFF49464E),
                  minimumSize: Size(400, 48),
                ),
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.paypal),
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(0, 48, 135, 1)),
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => UsePaypal(
                        sandboxMode: true,
                        clientId:
                            'AVFknc5oxUGa8x5r0iSzn0Ca3he6GoxEdVs0Zp0JMgI-m_eEt2Fwvi55CtbSV86U2BJM2lecOgvaAb2Y',
                        secretKey:
                            'EFYEQd6AALi7DZUENJSVRoog3ZNrSpn0n3vyPQDRlE0TDJ3G1xReLSYAFtSZnr9_OqYOmk_A4ATEqSRL',
                        returnURL: "https://samplesite.com/return",
                        cancelURL: "https://samplesite.com/cancel",
                        transactions: const [
                          {
                            "amount": {
                              "total": '10.12',
                              "currency": "USD",
                              "details": {
                                "subtotal": '10.12',
                                "shipping": '0',
                                "shipping_discount": 0
                              }
                            },
                            "description":
                                "The payment transaction description.",
                            "item_list": {
                              "items": [
                                {
                                  "name": "Reservation payment",
                                  "quantity": 1,
                                  "price": '10.12',
                                  "currency": "USD"
                                }
                              ],
                            }
                          }
                        ],
                        note: "Contact us for any questions on your order.",
                        onSuccess: (Map params) async {
                          try {
                            _userProvider.payMembership(
                                int.parse(Autentification.tokenDecoded!['Id']));

                            if (mounted) {
                              setState(() {
                                isPayed = true;
                              });
                            }
                          } on Exception catch (e) {
                            // TODO
                          }
                          Autentification.token = null;
                          Autentification.tokenDecoded = null;
                        },
                        onError: (error) {},
                        onCancel: (params) {
                          alertBox(context, AppLocalizations.of(context).error,
                              AppLocalizations.of(context).cancel_payment);
                        }),
                  ),
                )
              },
            ),
          ],
        ),
      ),
    );
  }
}

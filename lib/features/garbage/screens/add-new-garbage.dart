// import 'package:flutter/material.dart';
// import 'package:trash_track_mobile/features/garbage/models/garbage.dart';
// import 'package:trash_track_mobile/features/garbage/services/garbages_service.dart';
// import 'package:trash_track_mobile/shared/services/enums_service.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class GarbageAddScreen extends StatefulWidget {
//   @override
//   _GarbageAddScreenState createState() => _GarbageAddScreenState();
// }

// class _GarbageAddScreenState extends State<GarbageAddScreen> {
//   late EnumsService _enumsService;
//   late TextEditingController _descriptionController;
//   late int _selectedGarbageTypeIndex;
//   late Map<int, String> _garbageTypes;
//   bool _isLoading = true;
//   final garabageService = GarbageService();

//   @override
//   void initState() {
//     super.initState();
//     _enumsService = EnumsService();
//     _descriptionController = TextEditingController();
//     _selectedGarbageTypeIndex = 0; // Set the default vehicle type
//     _fetchGarbageTypes();
//   }

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchGarbageTypes() async {
//     try {
//       final typesData = await _enumsService.getGarbageTypes();

//       if (typesData is Map<int, String>) {
//         setState(() {
//           _garbageTypes = typesData;
//           _isLoading = false;
//         });
//       } else {
//         print('Received unexpected data format for garbage types: $typesData');
//       }
//     } catch (error) {
//       print('Error fetching garbage types: $error');
//     }
//   }

//   GoogleMapController? _mapController;
//   LatLng? _pickedLocation;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // ... Ostatak vašeg ekrana

//               const SizedBox(height: 16),

//               Container(
//                 height: 300, // Prilagodite visinu mape prema vašim potrebama
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.white,
//                   border: Border.all(
//                     color: const Color(0xFF49464E),
//                   ),
//                 ),
//                 child: GoogleMap(
//                   onMapCreated: (controller) {
//                     _mapController = controller;
//                   },
//                   initialCameraPosition: CameraPosition(
//                     target: LatLng(0, 0), // Početne koordinate mape
//                     zoom: 14, // Početni zoom nivo
//                   ),
//                   onTap: (location) {
//                     setState(() {
//                       _pickedLocation = location;
//                     });
//                   },
//                   markers: _pickedLocation != null
//                       ? {
//                           Marker(
//                             markerId: MarkerId('picked-location'),
//                             position: _pickedLocation!,
//                           ),
//                         }
//                       : {},
//                 ),
//               ),

//               const SizedBox(height: 16),

//               ElevatedButton(
//                 onPressed: () async {
//                   if (_pickedLocation != null) {
//                     final selectedGarbageType =
//                         GarbageType.values[_selectedGarbageTypeIndex];

//                     final newDescription = _descriptionController.text;

//                     final newGarbage = Garbage(
//                       description: newDescription,
//                       garbageType: selectedGarbageType,
//                       latitude: _pickedLocation!.latitude,
//                       longitude: _pickedLocation!.longitude,
//                     );

//                     try {
//                       await garabageService.insert(newGarbage);

//                       Navigator.pop(context, 'reload');
//                     } catch (error) {
//                       print('Error adding garbage: $error');
//                     }
//                   } else {
//                     // Obavestite korisnika da postavi pin na mapu
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('Please select a location on the map.'),
//                       ),
//                     );
//                   }
//                 },
//                 child: Text(
//                   'Add',
//                   style: TextStyle(
//                     fontSize: 16,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   primary: Color(0xFF49464E),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   minimumSize: Size(400, 48),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

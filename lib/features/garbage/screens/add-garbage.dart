// import 'dart:io';

// import 'package:flutter/material.dart';

// import 'package:trash_track_mobile/features/garbage/models/garbage.dart';
// import 'package:trash_track_mobile/features/garbage/services/garbages_service.dart';
// import 'package:trash_track_mobile/features/garbage/widgets/location_input.dart';
// import 'package:trash_track_mobile/shared/services/enums_service.dart';

// class AddPlaceScreen extends StatefulWidget {
//   const AddPlaceScreen({super.key});

//   @override
//   State<AddPlaceScreen> createState() {
//     return _AddPlaceScreenState();
//   }
// }

// class _AddPlaceScreenState extends State<AddPlaceScreen> {
//   late EnumsService _enumsService;
//   late TextEditingController _descriptionController;
//   late int _selectedGarbageTypeIndex;
//   late Map<int, String> _garbageTypes;
//   bool _isLoading = true;
//   final garbageService = GarbageService();
//   Garbage? _garbageLocation;

//  @override
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add new Garbage'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             TextField(
//               decoration: const InputDecoration(labelText: 'Description'),
//               controller: _descriptionController,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.onBackground,
//               ),
//             ),
//             const SizedBox(height: 10),
//             _isLoading
//                 ? CircularProgressIndicator()
//                 : Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Container(
//                       width: 400,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Colors.white,
//                         border: Border.all(
//                           color: Color(0xFF49464E),
//                         ),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: DropdownButtonFormField<int>(
//                           value: _selectedGarbageTypeIndex,
//                           onChanged: (newValue) {
//                             setState(() {
//                               _selectedGarbageTypeIndex = newValue ?? 0;
//                             });
//                           },
//                           items: _garbageTypes.entries.map((entry) {
//                             return DropdownMenuItem<int>(
//                               value: entry.key,
//                               child: Text(entry.value),
//                             );
//                           }).toList(),
//                           decoration: InputDecoration(
//                             labelText: 'Garbage Type',
//                             border: InputBorder.none,
//                           ),
//                           style: TextStyle(
//                             color: Color(0xFF49464E),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//             const SizedBox(height: 10),
      
//             ElevatedButton.icon(
//               onPressed: () async {
//                   final selectedGarbageType =
//                       GarbageType.values[_selectedGarbageTypeIndex];

//                   final newName = _descriptionController.text;

//                   final newGarbage = Garbage(
//                     description: newName,
//                     garbageType: selectedGarbageType,
//                     latitude: _garbageLocation!.latitude,
//                     longitude: _garbageLocation!.longitude
//                   );

//                   try {
//                     await garbageService.insert(newGarbage);

//                     Navigator.pop(context, 'reload');
//                   } catch (error) {
//                     print('Error adding garbage: $error');
//                   }
//                 },
//               icon: const Icon(Icons.add),
//               label: const Text('Add Garbage'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:trash_track_mobile/features/garbage/models/garbage.dart';
import 'package:trash_track_mobile/features/garbage/screens/map.dart';
import 'package:trash_track_mobile/features/garbage/services/garbages_service.dart';
import 'package:trash_track_mobile/features/garbage/widgets/location_input.dart';
import 'package:trash_track_mobile/shared/services/enums_service.dart';
import 'package:latlong2/latlong.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({Key? key});

  @override
  State<AddPlaceScreen> createState() {
    return _AddPlaceScreenState();
  }
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  late EnumsService _enumsService;
  late TextEditingController _descriptionController;
  late int _selectedGarbageTypeIndex;
  late Map<int, String> _garbageTypes;
  bool _isLoading = true;
  final garbageService = GarbageService();
  Garbage? _garbageLocation;

  @override
  void initState() {
    super.initState();
    _enumsService = EnumsService();
    _descriptionController = TextEditingController();
    _selectedGarbageTypeIndex = 0; // Set the default vehicle type
    _fetchGarbageTypes();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _fetchGarbageTypes() async {
    try {
      final typesData = await _enumsService.getGarbageTypes();

      if (typesData is Map<int, String>) {
        setState(() {
          _garbageTypes = typesData;
          _isLoading = false;
        });
      } else {
        print('Received unexpected data format for garbage types: $typesData');
      }
    } catch (error) {
      print('Error fetching garbage types: $error');
    }
  }

  Future<void> _selectLocation() async {
    final selectedLocation = await Navigator.of(context).push<LatLng?>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(
          isSelecting: true,
          garbageLocation: _garbageLocation,
        ),
      ),
    );

    if (selectedLocation != null) {
      setState(() {
        _garbageLocation = Garbage(
          latitude: selectedLocation.latitude,
          longitude: selectedLocation.longitude,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Garbage'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              controller: _descriptionController,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      width: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xFF49464E),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButtonFormField<int>(
                          value: _selectedGarbageTypeIndex,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGarbageTypeIndex = newValue ?? 0;
                            });
                          },
                          items: _garbageTypes.entries.map((entry) {
                            return DropdownMenuItem<int>(
                              value: entry.key,
                              child: Text(entry.value),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            labelText: 'Garbage Type',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Color(0xFF49464E),
                          ),
                        ),
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _selectLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Select Location'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () async {
                if (_garbageLocation == null) {
                  // Handle the case where location is not selected
                  // Display an error message or show a snackbar
                  return;
                }

                final selectedGarbageType =
                    GarbageType.values[_selectedGarbageTypeIndex];

                final newName = _descriptionController.text;

                final newGarbage = Garbage(
                  description: newName,
                  garbageType: selectedGarbageType,
                  latitude: _garbageLocation!.latitude,
                  longitude: _garbageLocation!.longitude,
                );

                try {
                  await garbageService.insert(newGarbage);

                  Navigator.pop(context, 'reload');
                } catch (error) {
                  print('Error adding garbage: $error');
                }
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Garbage'),
            ),
          ],
        ),
      ),
    );
  }
}

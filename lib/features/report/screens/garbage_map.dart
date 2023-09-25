import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:trash_track_mobile/features/garbage/models/garbage.dart';
import 'package:trash_track_mobile/features/garbage/services/garbages_service.dart';
import 'package:trash_track_mobile/shared/models/search_result.dart';

class GarbageMapScreen extends StatefulWidget {
  final Function(int) onGarbageSelected;

  GarbageMapScreen({
    Key? key,
    required this.onGarbageSelected,
  });

  @override
  State<GarbageMapScreen> createState() {
    return _GarbageMapScreenState();
  }
}

class _GarbageMapScreenState extends State<GarbageMapScreen> {
  final MapController mapController = MapController();
  List<Marker> _garbageMarkers = [];
  int? _selectedGarbageId; // Store the selected garbage ID here
  Set<Marker> _selectedMarkers = Set(); // Store selected markers here

  final GarbageService _garbageService = GarbageService();

  @override
  void initState() {
    super.initState();
    _fetchGarbageLocations();
  }

  Future<void> _fetchGarbageLocations() async {
    try {
      final SearchResult<Garbage> result = await _garbageService.getPaged();

      final List<Marker> markers = result.items.map((garbage) {
        bool isSelected = garbage.id == _selectedGarbageId;

        return Marker(
          width: 45.0,
          height: 45.0,
          point: LatLng(garbage.latitude!, garbage.longitude!),
          builder: (ctx) => GestureDetector(
            onTap: () {
              setState(() {
                _selectedGarbageId =
                    garbage.id; // Store the selected garbage ID
                if (isSelected) {
                  _selectedMarkers.removeWhere((marker) =>
                      marker.point ==
                      LatLng(garbage.latitude!, garbage.longitude!));
                } else {
                  _selectedMarkers.add(Marker(
                    width: 45.0,
                    height: 45.0,
                    point: LatLng(garbage.latitude!, garbage.longitude!),
                    builder: (ctx) => Container(
                      child: Icon(
                        Icons.location_on,
                        size: 45.0,
                        color: Colors.red, // Change the pin color when selected
                      ),
                    ),
                  ));
                }
              });
            },
            child: Container(
              child: Icon(
                Icons.location_on,
                size: 45.0,
                color: isSelected
                    ? Colors.red
                    : Colors.blue, // Change the pin color when selected
              ),
            ),
          ),
        );
      }).toList();

      // Set the state to rebuild the widget with the markers
      setState(() {
        _garbageMarkers = markers;
      });
    } catch (error) {
      print('Error fetching garbage locations: $error');
    }
  }

  void _onGarbageSelected(int garbageId) {
    widget.onGarbageSelected(garbageId);
    print(garbageId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(43.34, 17.81),
          zoom: 10.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: _garbageMarkers.toList(), // Convert Set to List
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Return the selected garbage ID to the previous screen
          Navigator.pop(context, _selectedGarbageId);
          print(_selectedGarbageId);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

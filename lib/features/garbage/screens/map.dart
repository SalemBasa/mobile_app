// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart'; // Import the latlong package

// import 'package:trash_track_mobile/features/garbage/models/garbage.dart';

// class MapScreen extends StatefulWidget {
//   MapScreen({
//     super.key,
//     Garbage? garbageLocation,
//     this.isSelecting = true,
//   }) : garbageLocation = garbageLocation ??
//             Garbage(
//               latitude: 43.343033,
//               longitude: 17.807894,
//             );

//   final Garbage garbageLocation;
//   final bool isSelecting;

//   @override
//   State<MapScreen> createState() {
//     return _MapScreenState();
//   }
// }

// class _MapScreenState extends State<MapScreen> {
//   LatLng? _pickedLocation;
//   MapController mapController = MapController();

//   void _handleTap(LatLng tappedPoint) {
//     if (widget.isSelecting) {
//       setState(() {
//         _pickedLocation = tappedPoint;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'),
//         actions: [
//           if (widget.isSelecting)
//             IconButton(
//               icon: const Icon(Icons.save),
//               onPressed: () {
//                 Navigator.of(context).pop(_pickedLocation);
//               },
//             ),
//         ],
//       ),
//       body: FlutterMap(
//         mapController: mapController,
//         options: MapOptions(
//           center: LatLng(
//             widget.garbageLocation.latitude ?? 0.0,
//             widget.garbageLocation.longitude ?? 0.0,
//           ),
//           zoom: 16,
//           onTap: (tapPosition, latlng) {
//             _handleTap(latlng);
//           },
//         ),
//         layers: [
//           TileLayerOptions(
//             urlTemplate:
//                 'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1Ijoic2FsZW1oYW16YSIsImEiOiJjbG1ueDV2ZmwxMTF2MmtsOGsxaHF4Z3NnIn0.fWZbM5YRJe18jxymfT8bWQ',
//             additionalOptions: {
//               'accessToken': 'pk.eyJ1Ijoic2FsZW1oYW16YSIsImEiOiJjbG1ueDV2ZmwxMTF2MmtsOGsxaHF4Z3NnIn0.fWZbM5YRJe18jxymfT8bWQ',
//               'id': 'mapbox/streets-v11',
//             },
//           ),
//           MarkerLayerOptions(
//             markers: (_pickedLocation == null && widget.isSelecting)
//                 ? []
//                 : [
//                     Marker(
//                       width: 45.0,
//                       height: 45.0,
//                       point: _pickedLocation ??
//                           LatLng(
//                             widget.garbageLocation.latitude ?? 0.0,
//                             widget.garbageLocation.longitude ?? 0.0,
//                           ),
//                       builder: (ctx) => Container(
//                         child: Icon(
//                           Icons.location_on,
//                           size: 45.0,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ),
//                   ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:trash_track_mobile/features/garbage/models/garbage.dart';

class MapScreen extends StatefulWidget {
  MapScreen({
    Key? key,
    Garbage? garbageLocation,
    required this.isSelecting,
  }) : garbageLocation = garbageLocation ??
            Garbage(
              latitude: 43.343033,
              longitude: 17.807894,
            );

  final Garbage garbageLocation;
  final bool isSelecting;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  MapController mapController = MapController();

  void _handleTap(LatLng tappedPoint) {
    if (widget.isSelecting) {
      setState(() {
        _pickedLocation = tappedPoint;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick your Location' : 'Your Location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ],
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(
            widget.garbageLocation.latitude ?? 0.0,
            widget.garbageLocation.longitude ?? 0.0,
          ),
          zoom: 16,
          onTap: (tapPosition, latlng) {
            _handleTap(latlng);
          },
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1Ijoic2FsZW1oYW16YSIsImEiOiJjbG1ueDV2ZmwxMTF2MmtsOGsxaHF4Z3NnIn0.fWZbM5YRJe18jxymfT8bWQ',
            additionalOptions: {
              'accessToken': 'pk.eyJ1Ijoic2FsZW1oYW16YSIsImEiOiJjbG1ueDV2ZmwxMTF2MmtsOGsxaHF4Z3NnIn0.fWZbM5YRJe18jxymfT8bWQ',
              'id': 'mapbox/streets-v11',
            },
          ),
          MarkerLayerOptions(
            markers: (_pickedLocation == null && widget.isSelecting)
                ? []
                : [
                    Marker(
                      width: 45.0,
                      height: 45.0,
                      point: _pickedLocation ??
                          LatLng(
                            widget.garbageLocation.latitude ?? 0.0,
                            widget.garbageLocation.longitude ?? 0.0,
                          ),
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_on,
                          size: 45.0,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
          ),
        ],
      ),
    );
  }
}

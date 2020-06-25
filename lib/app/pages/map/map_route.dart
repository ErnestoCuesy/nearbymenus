import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nearbymenus/app/utilities/map_utils.dart';

class MapRoute extends StatefulWidget {
  final Position currentLocation;
  final Position destination;

  MapRoute({this.currentLocation, this.destination});

  @override
  _MapRouteState createState() => _MapRouteState();
}

class _MapRouteState extends State<MapRoute> {
  MapUtils mapUtils;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  void _callBack() {
    setState(() {
      markers = mapUtils.markers;
    });
  }

  @override
  Widget build(BuildContext context) {
    mapUtils = MapUtils(
      mediaSize: MediaQuery.of(context).size,
      currentLocation: widget.currentLocation,
      destination: widget.destination,
      callBack: _callBack,
    );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: GoogleMap(
        onMapCreated: mapUtils.onMapCreated,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        cameraTargetBounds: CameraTargetBounds(mapUtils.createTargetBounds()),
        initialCameraPosition: CameraPosition(
            target:
            LatLng(
                (widget.currentLocation.latitude + widget.destination.latitude) / 2,
                (widget.currentLocation.longitude + widget.destination.longitude) / 2),
            zoom: 18.0),
            markers: Set<Marker>.of(markers.values),
      ),
    );
  }

}
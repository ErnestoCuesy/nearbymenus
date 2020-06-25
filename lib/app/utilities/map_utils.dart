import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  final Position currentLocation;
  final Position destination;
  final Size mediaSize;
  final Function callBack;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  MapUtils({this.currentLocation, this.destination, this.mediaSize, this.callBack});

  // Return appropriate destination chequered flag based on platform
  Future<BitmapDescriptor> get deliveryIcon async {
    if (Platform.isIOS) {
      return BitmapDescriptor.fromAssetImage(
          ImageConfiguration(),
          'assets/chequered-flagiOS.png');
    } else {
      return BitmapDescriptor.fromAssetImage(
          ImageConfiguration(),
          'assets/chequered-flag.png');
    }
  }

  onMapCreated(GoogleMapController controller) async {

    final double padding = 150.0;
    final double width = mediaSize.width - padding;
    final double height = mediaSize.height - padding;

    // Create map bounds
    final bounds = createTargetBounds();

    // Build markers title and snippet information for both current location and destination
    final NumberFormat fmt = new NumberFormat('0', 'en_ZA');

    final startMarkerId = MarkerId('start');
    final startMarker = Marker(
      markerId: startMarkerId,
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      infoWindow: InfoWindow(title: 'You are here')
    );

    // Determine distance to destination
    double distance = await Geolocator().distanceBetween(
        bounds.southwest.latitude,
        bounds.southwest.longitude,
        bounds.northeast.latitude,
        bounds.northeast.longitude);
    final finishSnippetInfo = 'Approx ${fmt.format(distance)} meters away from you.';

    final finishMarkerId = MarkerId('finish');
    final finishMarker = Marker(
      markerId: finishMarkerId,
      position: LatLng(
          destination.latitude,
          destination.longitude
      ),
      infoWindow: InfoWindow(title: 'Delivery point', snippet: finishSnippetInfo),
      icon: await deliveryIcon
    );

    // Clear and add markers to map
    markers.clear();
    markers[startMarkerId] = startMarker;
    markers[finishMarkerId] = finishMarker;

    // Determine correct level of zoom
    double zoom =
        _getBoundsZoomLevel(bounds.northeast, bounds.southwest, width, height);
    controller.moveCamera(CameraUpdate.zoomTo(zoom));

    callBack();
  }

  LatLngBounds createTargetBounds() {
    // Assume sw (curr) lat and long are less than ne (dest)
    LatLng curr = LatLng(
        currentLocation.latitude, currentLocation.longitude);
    LatLng dest = LatLng(
        destination.latitude, destination.longitude);

    // Calculate SW latitude bounds
    LatLng sw = LatLng(
        min(curr.latitude, dest.latitude), min(curr.longitude, dest.longitude));

    // Calculate NE latitude bounds
    LatLng ne = LatLng(
        max(curr.latitude, dest.latitude), max(curr.longitude, dest.longitude));

    return LatLngBounds(southwest: sw, northeast: ne);
  }

  double _getBoundsZoomLevel(LatLng northeast, LatLng southwest, double width,
      double height) {
    const int GLOBE_WIDTH = 256; // a constant in Google's map projection
    const double ZOOM_MAX = 21;
    double latFraction = (_latRad(northeast.latitude) -
        _latRad(southwest.latitude)) / pi;
    double lngDiff = northeast.longitude - southwest.longitude;
    double lngFraction = ((lngDiff < 0) ? (lngDiff + 360) : lngDiff) / 360;
    double latZoom = _zoom(height, GLOBE_WIDTH, latFraction);
    double lngZoom = _zoom(width, GLOBE_WIDTH, lngFraction);
    double zoom = min(min(latZoom, lngZoom), ZOOM_MAX);
    return zoom;
  }

  double _latRad(double lat) {
    double sinx = sin(lat * pi / 180);
    double radX2 = log((1 + sinx) / (1 - sinx)) / 2;
    return max(min(radX2, pi), -pi) / 2;
  }

  double _zoom(double mapPx, int worldPx, double fraction) {
    return (log(mapPx / worldPx / fraction) / ln2);
  }

}
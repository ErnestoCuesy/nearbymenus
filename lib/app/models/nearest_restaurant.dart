import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:nearbymenus/app/models/restaurant.dart';

class NearestRestaurant {
  final String id;
  final Restaurant restaurant;
  final double distance;

  NearestRestaurant({this.id, this.restaurant, this.distance});

}

class NearRestaurantBloc {
  final Future<List<Restaurant>> source;
  final Position userCoordinates;
  final bool useStaffFilter;
  final _stream = StreamController<List<Restaurant>>();

  NearRestaurantBloc({this.source, this.userCoordinates, this.useStaffFilter}) {
    List<Restaurant> resList = List<Restaurant>();
    source.then((rest) {
      rest.forEach((res) async {
        if (useStaffFilter) {
          if (res.acceptingStaffRequests) {
            await Geolocator().distanceBetween(userCoordinates.latitude, userCoordinates.longitude, res.coordinates.latitude, res.coordinates.longitude).then((distance) {
              if (res.active && distance < res.deliveryRadius) {
                resList.add(res);
              }
            });
          }
        } else {
          await Geolocator().distanceBetween(userCoordinates.latitude, userCoordinates.longitude, res.coordinates.latitude, res.coordinates.longitude).then((distance) {
            if (res.active && distance < res.deliveryRadius) {
              resList.add(res);
            }
          });
        }
        _stream.add(resList);
      });
    });
  }

  Stream<List<Restaurant>> get stream => _stream.stream;

  void dispose() {
    _stream.close();
  }

}
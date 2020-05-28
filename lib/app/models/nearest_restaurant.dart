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
  final Stream<List<Restaurant>> source;
  final Position userCoordinates;
  final _stream = StreamController<List<Restaurant>>();

  NearRestaurantBloc({
    this.source,
    this.userCoordinates,
  }) {
    List<Restaurant> resList = List<Restaurant>();
    source.forEach((rest) {
      resList.clear();
      rest.forEach((res) async {
        await Geolocator().distanceBetween(
          userCoordinates.latitude,
          userCoordinates.longitude,
          res.coordinates.latitude,
          res.coordinates.longitude,
        ).then((distance) {
          if (res.active && distance < res.deliveryRadius) {
            resList.add(res);
          }
        });
        _stream.add(resList);
      });
    });
  }

  Stream<List<Restaurant>> get stream => _stream.stream;

}

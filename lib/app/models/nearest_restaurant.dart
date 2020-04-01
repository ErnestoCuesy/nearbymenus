import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:nearbymenus/app/models/restaurant.dart';

class NearestRestaurant {
  final String name;
  final String complexName;
  final Restaurant restaurant;
  final double distance;

  NearestRestaurant({this.name, this.complexName, this.restaurant, this.distance});

}

class NearRestaurantBloc {
  final Future<List<Restaurant>> source;
  final Position userCoordinates;
  final _stream = StreamController<List<NearestRestaurant>>();

  NearRestaurantBloc({this.source, this.userCoordinates}) {
    List<NearestRestaurant> resList = List<NearestRestaurant>();
    source.then((rest) {
      rest.forEach((res) async {
        await Geolocator().distanceBetween(userCoordinates.latitude, userCoordinates.longitude, res.coordinates.latitude, res.coordinates.longitude).then((distance) {
          if (res.active && distance < res.deliveryRadius) {
            resList.add(NearestRestaurant(name: res.name, complexName: res.restaurantLocation, restaurant: res, distance: distance));
          }
        });
        _stream.add(resList);
      });
    });
  }

  Stream<List<NearestRestaurant>> get stream => _stream.stream;

  void dispose() {
    _stream.close();
  }

}
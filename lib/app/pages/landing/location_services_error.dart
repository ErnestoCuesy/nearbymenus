import 'package:flutter/material.dart';
import 'package:nearbymenus/app/common_widgets/empty_content.dart';

class LocationServicesError extends StatelessWidget {
  final String message;

  const LocationServicesError({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //backgroundColor: Theme.of(context).splashColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nearby Menus',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
              padding: EdgeInsets.all(32.0),
              child: EmptyContent(
                title: 'Could not determine your location',
                message: message,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

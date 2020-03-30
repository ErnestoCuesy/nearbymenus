import 'package:flutter/material.dart';

class LoadingProgressIndicator extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
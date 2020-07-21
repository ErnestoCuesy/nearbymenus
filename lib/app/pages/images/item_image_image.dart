import 'package:flutter/material.dart';

class ItemImageImage extends StatelessWidget {
  final String url;

  const ItemImageImage({Key key, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (url != '') {
      widget = Image.network(url, fit: BoxFit.fill,);
    } else {
      widget = Icon(Icons.image,size: 36.0,);
    }
    return Expanded(child: widget,);
  }
}

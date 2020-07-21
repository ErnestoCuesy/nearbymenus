import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/item_image.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/images/item_image_details_page.dart';
import 'package:provider/provider.dart';

class ItemImagePage extends StatefulWidget {
  @override
  _ItemImagePageState createState() => _ItemImagePageState();
}

class _ItemImagePageState extends State<ItemImagePage> {
  Session session;
  Map<dynamic, dynamic> _itemImageList;

  void _loadItemImages(){
    if (session.currentRestaurant.itemImages == null ||
        session.currentRestaurant.itemImages.isEmpty) {
      final initItems = List<ItemImage>.generate(5, (index) =>
          ItemImage(
              id: index.toString(),
              description: 'Tap to change',
              url: '')
      );
      initItems.forEach((item) {
        session.currentRestaurant.itemImages.putIfAbsent(item.id, () => item.toMap());
      });
    }
    _itemImageList = session.currentRestaurant.itemImages;
  }

  void _createItemImageDetailsPage(BuildContext context, ItemImage itemImage) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => ItemImageDetailsPage(
          itemImage: itemImage,
        ),
      ),
    );
  }

  Widget _buildContents() {
    return ListView.builder(
      itemCount: _itemImageList.length,
      itemBuilder: (context, index) {
        final ItemImage itemImage = ItemImage.fromMap(_itemImageList[index.toString()], null) ;
        return Card(
          child: ListTile(
            leading: Container(
              width: 50.0,
              child: Icon(Icons.image),
            ),
            title: Text(
                itemImage.description
            ),
            onTap: () => _createItemImageDetailsPage(context, itemImage),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    session = Provider.of<Session>(context);
    _loadItemImages();
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Upload images'
        ),
      ),
      body: _buildContents(),
    );
  }

}

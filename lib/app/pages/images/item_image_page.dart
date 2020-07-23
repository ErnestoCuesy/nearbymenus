import 'package:flutter/material.dart';
import 'package:nearbymenus/app/models/item_image.dart';
import 'package:nearbymenus/app/models/session.dart';
import 'package:nearbymenus/app/pages/images/item_image_details_page.dart';
import 'package:provider/provider.dart';

class ItemImagePage extends StatefulWidget {
  final bool viewOnly;

  const ItemImagePage({Key key, this.viewOnly}) : super(key: key);

  @override
  _ItemImagePageState createState() => _ItemImagePageState();
}

class _ItemImagePageState extends State<ItemImagePage> {
  Session session;
  Map<dynamic, dynamic> _itemImageList;
  List<Widget> _itemImages = List<Widget>.generate(5, (index) => null);

  void _loadItemImages() {
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
    _itemImageList.forEach((key, value) {
      if (value['url'] != '') {
        _itemImages[int.parse(key)] = Image.network(value['url']);
      }
    });
  }

  void _createItemImageDetailsPage(BuildContext context, ItemImage itemImage, Widget image) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: false,
        builder: (context) => ItemImageDetailsPage(
          itemImage: itemImage,
          image: image,
        ),
      ),
    );
  }

  Widget _buildContentsForEdit() {
    return ListView.builder(
      itemCount: _itemImageList.length,
      itemBuilder: (context, index) {
        final ItemImage itemImage = ItemImage.fromMap(_itemImageList[index.toString()], null) ;
        final image = _itemImages[index] ?? Icon(Icons.image);
        return Card(
          child: ListTile(
            leading: Container(
              width: 50.0,
              child: image,
            ),
            title: Text(
                itemImage.description
            ),
            onTap: () => _createItemImageDetailsPage(context, itemImage, image),
          ),
        );
      },
    );
  }

  Widget _buildContentsForView() {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _itemImageList.length,
      itemBuilder: (context, index) {
        final ItemImage itemImage = ItemImage.fromMap(_itemImageList[index.toString()], null) ;
        final image = _itemImages[index] ?? Icon(Icons.image);
        return Container(
          width: width,
          height: height,
          child: Column(
            children: [
              Expanded(child: image),
              Text(
                  _itemImages[index] != null ? itemImage.description : '',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
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
            widget.viewOnly ? 'Our specialities' : 'Upload images'
        ),
      ),
      body: widget.viewOnly ? _buildContentsForView() : _buildContentsForEdit(),
    );
  }

}

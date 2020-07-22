import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nearbymenus/app/models/item_image.dart';
import 'package:nearbymenus/app/models/restaurant.dart';
import 'package:nearbymenus/app/utilities/validators.dart';
import 'package:nearbymenus/app/services/database.dart';

class ItemImageDetailsModel with ItemImageValidators, ChangeNotifier {
  final Database database;
  final Restaurant restaurant;
  String id;
  String description;
  String url;
  Widget image;
  File imageFile;
  bool imageChanged = false;
  bool isLoading;
  bool submitted;

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://nearby-menus-be6e3.appspot.com');

  Map<dynamic, dynamic> itemImages;
  ImagePicker _imagePicker = ImagePicker();

  ItemImageDetailsModel(
      {@required this.database,
        @required this.restaurant,
        this.id,
        this.description,
        this.url,
        this.image,
        this.isLoading = false,
        this.submitted = false,
      });

  Future<void> save() async {
    updateWith(isLoading: true, submitted: true);
    if (imageChanged) {
      await uploadPic();
    }
    final itemImage = ItemImage(
      id: id,
      description: description,
      url: url,
    );
    try {
      final Map<dynamic, dynamic> itemImages = restaurant.itemImages;
      if (itemImages.containsKey(id)) {
        restaurant.itemImages.update(id, (_) => itemImage.toMap());
      } else {
        restaurant.itemImages.putIfAbsent(id, () => itemImage.toMap());
      }
      await Restaurant.setRestaurant(database, restaurant);
    } catch (e) {
      print(e);
      updateWith(isLoading: false);
      rethrow;
    }
  }

  Future getImage() async {
    PickedFile pickedImage = await _imagePicker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      imageFile = File(pickedImage.path);
      image = Image.file(imageFile);
      updateWith(image: image, imageChanged: true);
    }
  }

  Future uploadPic() async {
    String fileName = 'images/${restaurant.id}/Image_$id';
    StorageReference storageReference = _storage.ref().child(fileName);
    StorageUploadTask uploadTask = storageReference.putFile(imageFile);
    try {
      final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
      url = await downloadUrl.ref.getDownloadURL();
      print('Image file uploaded, url is $url');
    } catch (e) {
      print(e);
    }
  }

  String get primaryButtonText => 'Save';

  bool get canSave => itemImageDescriptionValidator.isValid(description);

  String get itemImageDescriptionErrorText {
    bool showErrorText = !itemImageDescriptionValidator.isValid(description);
    return showErrorText ? invalidItemImageDescriptionText : null;
  }

  void updateItemImageDescription(String description) => updateWith(description: description);

  void updateWith({
    String description,
    Widget image,
    bool imageChanged,
    bool isLoading,
    bool submitted,
  }) {
    this.description = description ?? this.description;
    this.image = image ?? this.image;
    this.imageChanged = imageChanged ?? this.imageChanged;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = this.submitted;
    notifyListeners();
  }
}

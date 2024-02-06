import 'package:e_commerce_app_with_firebase/models/viewed_product.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ViewedListProvider with ChangeNotifier {
  final Map<String, ViewedListModel> _viewedListItem = {}; //1
  Map<String, ViewedListModel> get getViewedistItems => _viewedListItem; //2

  void addProductToHistory({required String productId}) {
    //4

    _viewedListItem.putIfAbsent(
        productId,
        () => ViewedListModel(
              viewedlId: const Uuid().v4(),
              productId: productId,
            ));

    notifyListeners();
  }

  void clear() {
    //5
    _viewedListItem.clear();
    notifyListeners();
  }
}

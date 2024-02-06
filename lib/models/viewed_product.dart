import 'package:flutter/material.dart';

class ViewedListModel  with ChangeNotifier{
  final String viewedlId, productId;


  ViewedListModel(
      {required this.viewedlId, required this.productId,  });
}

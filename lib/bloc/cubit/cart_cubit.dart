
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  int _drawerValue = 0;
  int _wishListCountValue = 0;

  int get count => _count;
  int get drawerValue => _drawerValue;
  int get wishListCountValue => _wishListCountValue;

  void increment(int value) {
    _count=value;
    notifyListeners();
  }
  void updateWishList(int value) {
    _wishListCountValue=value;
    notifyListeners();
  }
  void setDrawerValue(int value) {
    _drawerValue=value;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
    properties.add(IntProperty('drawerValue', drawerValue));
    properties.add(IntProperty('wishListCountValue', wishListCountValue));
  }
}
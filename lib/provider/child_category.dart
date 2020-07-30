import 'package:flutter/material.dart';
import '../model/category_model.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> _list = []; //商品小类列表
  int _childIndex = 0;

  // List<BxMallSubDto> get childCategoryList => _list;
  void setChildCategory(List<BxMallSubDto> list) {
    // 每次切换大类，子类索引置为0
    _childIndex = 0;
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '00';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';
    _list = [all];
    _list.addAll(list);
    notifyListeners();
  }

  void setChildIndex(int index) {
    _childIndex = index;
  }

  List<BxMallSubDto> get childCategoryList => _list;
  int get childCategoryIndex => _childIndex;
}

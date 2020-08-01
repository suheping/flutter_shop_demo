import 'package:flutter/material.dart';
import '../model/category_goods_model.dart';

class CategoryGoodsListPorvider with ChangeNotifier {
  List<CategoryGoodData> _goodsDataList = [];

  void setGoodsDataList(List<CategoryGoodData> list) {
    _goodsDataList = list;
    notifyListeners();
  }

  void setMoreGoods(List<CategoryGoodData> list) {
    _goodsDataList.addAll(list);
    notifyListeners();
  }

  List<CategoryGoodData> get goodsDataList => _goodsDataList;
}

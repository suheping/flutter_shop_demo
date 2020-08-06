import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/shop_cart_goods_model.dart';

class ShopCartProvider with ChangeNotifier {
  List<ShopCartGoodModel> _cartGoodsList = [];

  // 加入购物车
  void addToCart(
      String goodId, String goodName, double price, String image) async {
    SharedPreferences sdfs = await SharedPreferences.getInstance();
    String tmpString = sdfs.getString('cart_goods');
    print('tmpString===============: $tmpString');
    List<Map> tmpList;
    tmpString == null
        ? tmpList = []
        : tmpList = (json.decode(tmpString) as List).cast();
    Map<String, dynamic> newGood = {
      'goodId': goodId,
      'goodName': goodName,
      'price': price,
      'image': image,
      'count': 1,
      'selected': true
    };
    if (tmpList.length == 0) {
      tmpList.add(newGood);
      _cartGoodsList = [];
      _cartGoodsList.add(ShopCartGoodModel.fromJson(newGood));
    } else {
      int index = 0;
      bool isExist = false;
      tmpList.forEach((item) {
        if (goodId == item['goodId']) {
          tmpList[index]['count']++;
          _cartGoodsList[index].count++;
          isExist = true;
        }
        index++;
      });
      if (!isExist) {
        tmpList.add(newGood);
        _cartGoodsList.add(ShopCartGoodModel.fromJson(newGood));
      }
    }

    sdfs.setString('cart_goods', json.encode(tmpList).toString());
    print(sdfs.getString('cart_goods'));
    print(_cartGoodsList);
    notifyListeners();
  }

  // 清空购物车
  void clearCart() async {
    SharedPreferences sdfs = await SharedPreferences.getInstance();
    sdfs.remove('cart_goods');
    _cartGoodsList = [];
    notifyListeners();
  }

  // 获取购物车数据
  getShopCartGoods() async {
    // 从SharedPreferences读取数据
    // print('从SharedPreferences读取数据');
    SharedPreferences sdfs = await SharedPreferences.getInstance();
    String tmpString = sdfs.getString('cart_goods');
    _cartGoodsList = [];
    if (tmpString == null) {
      _cartGoodsList = [];
    } else {
      List<Map> tmpListMap = (json.decode(tmpString) as List).cast();
      tmpListMap.forEach((item) {
        _cartGoodsList.add(ShopCartGoodModel.fromJson(item));
      });
    }
    notifyListeners();
  }

  // 删除购物车中的一个商品
  void removeShopCartGood(String goodId) async {
    SharedPreferences sdfs = await SharedPreferences.getInstance();
    String tmpString = sdfs.getString('cart_goods');
    List<Map> tmpListMap = (json.decode(tmpString) as List).cast();
    int index = 0;
    int removeIndex = 0;
    tmpListMap.forEach((item) {
      if (goodId == item['goodId']) {
        removeIndex = index;
      }
      index++;
    });
    tmpListMap.removeAt(removeIndex);
    sdfs.setString('cart_goods', json.encode(tmpListMap).toString());
    await getShopCartGoods();
  }

  List<ShopCartGoodModel> get cartGoodsList => _cartGoodsList;
}

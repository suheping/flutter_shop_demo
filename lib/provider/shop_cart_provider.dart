import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/shop_cart_goods_model.dart';

class ShopCartProvider with ChangeNotifier {
  List<ShopCartGoodModel> _cartGoodsList = [];
  double _totalPrice = 0; //商品总数量
  int _totalCount = 0; //商品总价格
  bool _allSelected = true; //购物车商品是否全部选中

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
      _totalCount = 0;
      _totalPrice = 0;
    } else {
      List<Map> tmpListMap = (json.decode(tmpString) as List).cast();
      _totalCount = 0;
      _totalPrice = 0;
      _allSelected = true;
      tmpListMap.forEach((item) {
        if (item['selected']) {
          _totalCount += item['count'];
          _totalPrice += (item['price'] * item['count']);
        } else {
          _allSelected = false;
        }
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

  // 点击购物车某个商品的checkbox时调用
  setSelected(ShopCartGoodModel good) async {
    SharedPreferences sdfs = await SharedPreferences.getInstance();
    String tmpString = sdfs.getString('cart_goods');
    List<Map> tmpListMap = (json.decode(tmpString) as List).cast();
    int index = 0;
    int setIndex = 0;
    tmpListMap.forEach((item) {
      if (item['goodId'] == good.goodId) {
        setIndex = index;
      }
      index++;
    });
    tmpListMap[setIndex] = good.toJson();
    sdfs.setString('cart_goods', json.encode(tmpListMap).toString());
    await getShopCartGoods();
  }

  // 点击购物车全选按钮时调用
  setAllSelected(bool allSelected) async {
    SharedPreferences sdfs = await SharedPreferences.getInstance();
    String tmpString = sdfs.getString('cart_goods');
    List<Map> tmpListMap = (json.decode(tmpString) as List).cast();
    List<Map> newList = [];
    tmpListMap.forEach((item) {
      var newItem = item;
      newItem['selected'] = allSelected;
      newList.add(newItem);
    });
    sdfs.setString('cart_goods', json.encode(newList).toString());
    await getShopCartGoods();
  }

  List<ShopCartGoodModel> get cartGoodsList => _cartGoodsList;
  double get totalPrice => _totalPrice;
  int get totalCount => _totalCount;
  bool get allSelected => _allSelected;
}

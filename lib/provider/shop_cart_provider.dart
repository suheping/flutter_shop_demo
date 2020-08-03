import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ShopCartProvider with ChangeNotifier {
  String _cartGoods = '[]';

  void addToCart(
      String goodId, String goodName, double price, String image) async {
    SharedPreferences sdfs = await SharedPreferences.getInstance();
    String tmpString = sdfs.getString('cart_goods');
    print('tmpString===============: $tmpString');
    if (tmpString == null) {
      //购物车为空
      List<Map> tmpList = [
        {
          'goodId': goodId,
          'goodName': goodName,
          'price': price,
          'image': image,
          'count': 1
        }
      ];
      sdfs.setString('cart_goods', json.encode(tmpList));
    } else {
      //购物车中有数据
      int index = 0;
      bool isExist = false;
      List<Map> tmpListMap = (json.decode(tmpString) as List).cast();
      print('tmpListMap.length====>${tmpListMap.length}');
      tmpListMap.forEach((item) {
        if (item['goodId'] == goodId) {
          tmpListMap[index]['count']++;
          isExist = true;
        }
        index++;
      });
      if (!isExist) {
        tmpListMap.add({
          'goodId': goodId,
          'goodName': goodName,
          'price': price,
          'image': image,
          'count': 1
        });
      }
      sdfs.setString('cart_goods', json.encode(tmpListMap));
    }
    print(sdfs.getString('cart_goods'));
  }

  void clearCart() async {
    SharedPreferences sdfs = await SharedPreferences.getInstance();
    sdfs.remove('cart_goods');
  }
}

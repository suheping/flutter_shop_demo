import 'package:flutter/material.dart';
import 'package:flutter_shop/model/good_detail_model.dart';
import 'package:flutter_shop/service/service_methods.dart';
import 'dart:convert';

class GoodDetailPorvider with ChangeNotifier {
  GoodDetailModel _goodDetail;

  // 调接口获取商品信息
  getGoodDetailById(String goodId) async {
    var formData = {'goodId': goodId};
    await customRequest('getGoodDetailById', formData: formData).then((value) {
      var responseData = json.decode(value.toString());

      _goodDetail = GoodDetailModel.fromJson(responseData);
      print(_goodDetail.data.goodInfo.goodsName);
    });
  }

  GoodDetailModel get goodDetail => _goodDetail;
}

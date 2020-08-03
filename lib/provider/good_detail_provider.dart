import 'package:flutter/material.dart';
import 'package:flutter_shop/model/good_detail_model.dart';
import 'package:flutter_shop/service/service_methods.dart';
import 'dart:convert';

class GoodDetailPorvider with ChangeNotifier {
  GoodDetailModel _goodDetail; //商品信息

  bool _isDesc = true; //是否点击了详情，默认为true

  // 调接口获取商品信息
  getGoodDetailById(String goodId) async {
    var formData = {'goodId': goodId};
    await customRequest('getGoodDetailById', formData: formData).then((value) {
      var responseData = json.decode(value.toString());

      _goodDetail = GoodDetailModel.fromJson(responseData);
      print(_goodDetail.data.goodInfo.goodsName);
    });
    // // 重新获取商品信息，代表重新选择了商品，那么tab切换到详情
    // _isDesc = true;
  }

  // 点击详情或者评论，修改_isDesc的值
  setIsDesc(String descOrappraisal) {
    if (descOrappraisal == 'desc') {
      _isDesc = true;
    } else {
      _isDesc = false;
    }
    notifyListeners();
  }

  GoodDetailModel get goodDetail => _goodDetail;
  bool get isDesc => _isDesc;
}

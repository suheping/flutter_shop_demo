import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_shop/pages/shop_cart_page.dart';
import '../pages/good_detail_page.dart';

Handler goodDetailHandler = Handler(
  handlerFunc: (context, parameters) {
    return GoodDetailPage(parameters['goodId'][0]);
  },
);

Handler shopCartHandler = Handler(
  handlerFunc: (context, parameters) {
    return ShopCartPage();
  },
);

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import '../pages/good_detail_page.dart';

Handler goodDetailHandler = Handler(
  handlerFunc: (context, parameters) {
    return GoodDetailPage(parameters['goodId'][0]);
  },
);

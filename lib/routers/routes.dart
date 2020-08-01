import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'handler.dart';

class Routes {
  static String root = '/';
  static String goodDetailPage = '/goodDetail';
  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
      handlerFunc: (context, parameters) {
        print('route was not found!');
      },
    );
    router.define(goodDetailPage, handler: goodDetailHandler);
  }
}

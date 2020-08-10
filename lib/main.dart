import 'package:flutter/material.dart';
import 'pages/index_page.dart';
import 'package:provider/provider.dart';
import 'provider/counter.dart';
import 'provider/child_category_provider.dart';
import 'provider/good_detail_provider.dart';
import 'provider/category_goods_list_provider.dart';
import 'provider/shop_cart_provider.dart';
import 'provider/index_provider.dart';
import 'package:fluro/fluro.dart';
import 'routers/application.dart';
import 'routers/routes.dart';

void main() {
  // runApp(MyApp());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ChildCategory>(
        create: (_) => ChildCategory(),
      ),
      ChangeNotifierProvider<CategoryGoodsListPorvider>(
        create: (_) => CategoryGoodsListPorvider(),
      ),
      ChangeNotifierProvider<GoodDetailPorvider>(
        create: (_) => GoodDetailPorvider(),
      ),
      ChangeNotifierProvider<ShopCartProvider>(
        create: (_) => ShopCartProvider(),
      ),
      ChangeNotifierProvider<IndexProvider>(
        create: (_) => IndexProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: '生活+',
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Application.router.generator,
      ),
    );
  }
}

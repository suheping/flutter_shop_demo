import 'package:flutter/material.dart';
import 'pages/index_page.dart';
import 'package:provider/provider.dart';
import 'provider/counter.dart';
import 'provider/child_category.dart';
import 'provider/category_goods_list.dart';

void main() {
  // runApp(MyApp());
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Counter>(
        create: (_) => Counter(),
      ),
      ChangeNotifierProvider<ChildCategory>(
        create: (_) => ChildCategory(),
      ),
      ChangeNotifierProvider<CategoryGoodsListPorvider>(
        create: (_) => CategoryGoodsListPorvider(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: '生活+',
        theme: ThemeData(
          primaryColor: Colors.pink,
        ),
        home: IndexPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

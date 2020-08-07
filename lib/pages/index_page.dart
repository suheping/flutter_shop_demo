import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/provider/index_provider.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'shop_cart_page.dart';
import 'member_page.dart';

class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> _bottomNavigationBarItemList = [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text('首页')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search), title: Text('分类')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.shopping_cart), title: Text('购物车')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.person), title: Text('个人中心')),
  ];

  final List<Widget> _tabPages = [
    HomePage(),
    CategoryPage(),
    ShopCartPage(),
    MemberPage()
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: true);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavigationBarItemList,
        type: BottomNavigationBarType.fixed,
        currentIndex: context.watch<IndexProvider>().currentIndex,
        onTap: (value) {
          context.read<IndexProvider>().setCurrentIndex(value);
        },
      ),
      body: IndexedStack(
        index: context.watch<IndexProvider>().currentIndex,
        children: _tabPages,
      ),
    );
  }
}

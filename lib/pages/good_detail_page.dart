import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/good_detail_widget/good_detail_middle_widget.dart';
import 'package:flutter_shop/provider/good_detail_provider.dart';
import 'package:provider/provider.dart';

import 'good_detail_widget/good_detail_bottom_bar.dart';
import 'good_detail_widget/good_detail_top_widget.dart';

class GoodDetailPage extends StatelessWidget {
  final String goodId;

  GoodDetailPage(this.goodId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品详情页'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                Container(
                  child: ListView(
                    children: <Widget>[
                      GoodDetailTopWidge(),
                      GoodDetailMiddleWidget()
                    ],
                  ),
                ),
                Positioned(
                  child: GoodDetailBottomBar(),
                  left: 0,
                  bottom: 0,
                )
              ],
            );
          } else {
            return Text('加载中');
          }
        },
      ),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await context.watch<GoodDetailPorvider>().getGoodDetailById(this.goodId);
    return '加载完成';
  }
}

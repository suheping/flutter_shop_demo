import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/good_detail_model.dart';
import 'package:provider/provider.dart';
import '../../provider/good_detail_provider.dart';
// import '../../model/good_detail_model.dart';
import 'package:flutter_html/flutter_html.dart';

// 还存在一个bug，重新进入商品详情页，没有切换回 详情tab
class GoodDetailMiddleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodInfo = context.watch<GoodDetailPorvider>().goodDetail.data.goodInfo;
    var goodComments =
        context.watch<GoodDetailPorvider>().goodDetail.data.goodComments;
    return Container(
        width: ScreenUtil().setWidth(750),
        color: Colors.white,
        padding: EdgeInsets.only(top: 5, bottom: 5),
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                _descWidget(context),
                _commentsWidget(context)
              ],
            ),
            _descContentWidget(context.watch<GoodDetailPorvider>().isDesc,
                goodInfo.goodsDetail),
            _commentsContentWidget(
                context.watch<GoodDetailPorvider>().isDesc, goodComments),
            Image.network(context
                .watch<GoodDetailPorvider>()
                .goodDetail
                .data
                .advertesPicture
                .pICTUREADDRESS)
          ],
        ));
  }

  // 商品详细信息tab
  Widget _descWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<GoodDetailPorvider>().setIsDesc('desc');
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: context.watch<GoodDetailPorvider>().isDesc
                        ? Colors.pink
                        : Colors.black26,
                    width: 1))),
        child: Text(
          '详情',
          style: TextStyle(
              color: context.watch<GoodDetailPorvider>().isDesc
                  ? Colors.pink
                  : Colors.black,
              fontSize: ScreenUtil().setSp(24)),
        ),
      ),
    );
  }

  // 商品评价tab
  Widget _commentsWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        // 切换tab的时候，重新调了后端接口，这个bug得搞下
        context.read<GoodDetailPorvider>().setIsDesc('comments');
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: context.watch<GoodDetailPorvider>().isDesc
                        ? Colors.black26
                        : Colors.pink,
                    width: 1))),
        child: Text(
          '评价',
          style: TextStyle(
              color: context.watch<GoodDetailPorvider>().isDesc
                  ? Colors.black
                  : Colors.pink,
              fontSize: ScreenUtil().setSp(24)),
        ),
      ),
    );
  }

  // 商品详细tab内容
  Widget _descContentWidget(bool isDesc, String goodDetail) {
    if (isDesc) {
      return Html(
        data: goodDetail,
      );
    } else {
      return Container();
    }
  }

  // 商品评价tab内容
  Widget _commentsContentWidget(bool isDesc, List<GoodComments> goodComments) {
    if (isDesc) {
      return Container();
    } else {
      if (goodComments.length == 0) {
        return Container(
          child: Text('暂无评价'),
        );
      } else {
        return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true, //高度随子元素的个数变化：个数*单个高度
            itemCount: goodComments.length,
            itemBuilder: (context, index) {
              return _commentsItemWidget(goodComments, index);
            });
      }
    }
  }

  // 商品评价单条
  Widget _commentsItemWidget(List<GoodComments> goodComments, int index) {
    return Container(
      height: ScreenUtil().setHeight(130),
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              goodComments[index].userName,
              style: TextStyle(
                  color: Colors.black54, fontSize: ScreenUtil().setSp(24)),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              goodComments[index].comments,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                  color: Colors.black87, fontSize: ScreenUtil().setSp(28)),
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              '${goodComments[index].discussTime}',
              style: TextStyle(
                  color: Colors.black54, fontSize: ScreenUtil().setSp(20)),
            ),
          ),
        ],
      ),
    );
  }
}

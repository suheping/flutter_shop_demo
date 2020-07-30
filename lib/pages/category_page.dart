import 'package:flutter/material.dart';
import 'package:flutter_shop/provider/child_category.dart';
import 'package:flutter_shop/service/service_methods.dart';
import 'dart:convert';
import '../model/category_model.dart';
import '../model/category_goods_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../provider/category_goods_list.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    // _getCategory();
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Row(
        children: <Widget>[
          // _leftCategoryWidget(),
          LeftCategoryWidget(),
          Column(
            children: <Widget>[
              // _rightCategoryBar()
              RightChildCategoryWidget(),
              CategoryGoodsWidget()
            ],
          )
        ],
      ),
    );
  }
}

// 左侧导航
class LeftCategoryWidget extends StatefulWidget {
  @override
  _LeftCategoryWidgetState createState() => _LeftCategoryWidgetState();
}

class _LeftCategoryWidgetState extends State<LeftCategoryWidget> {
  List categoryList = [];

  // 当前选中第几个分类
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _getCategory();
    _getCategoryGoods();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(140),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.black26, width: 1))),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _categoryItemWidget(index);
        },
        itemCount: categoryList.length,
      ),
    );
  }

  // 左侧分类单个部件
  _categoryItemWidget(int index) {
    bool isClick = false;
    isClick = (index == _currentIndex) ? true : false;
    return InkWell(
      onTap: () {
        // 修改值
        context
            .read<ChildCategory>()
            .setChildCategory(categoryList[index].bxMallSubDto);
        setState(() {
          _currentIndex = index;
        });
        // 点击了某个分类后，查询该分类下的商品，传入该分类的id
        _getCategoryGoods(categoryId: categoryList[index].mallCategoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(80),
        padding: EdgeInsets.only(left: 16, top: 20),
        decoration: BoxDecoration(
            color: isClick ? Colors.black12 : Colors.white,
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 1))),
        child: Text(
          categoryList[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(24)),
        ),
      ),
    );
  }

  // 获取分类信息
  _getCategory() async {
    await customRequest('getCategory').then((value) {
      var data = json.decode(value.toString());
      CategoryModel categoryModel = CategoryModel.fromJson(data);
      setState(() {
        categoryList = categoryModel.data;
      });
      // 获取到分类信息后，直接修改值，解决进入分类页面第一个分类的子类不展示的问题
      context
          .read<ChildCategory>()
          .setChildCategory(categoryList[0].bxMallSubDto);
    });
  }

  // 调接口获取分类下的商品
  _getCategoryGoods({String categoryId}) async {
    var data = {
      'categoryId':
          categoryId == null ? '2c9f6c946cd22d7b016cd74220b70040' : categoryId,
      'categorySubId': '',
      'page': 1
    };
    await customRequest('getMallGoods', formData: data).then((value) {
      var responseData = json.decode(value.toString());
      CategoryGoodsModel goodsModel = CategoryGoodsModel.fromJson(responseData);
      // 修改值
      context
          .read<CategoryGoodsListPorvider>()
          .setGoodsDataList(goodsModel.data);
    });
  }
}

// 右侧顶部二级分类
class RightChildCategoryWidget extends StatefulWidget {
  @override
  _RightChildCategoryWidgetState createState() =>
      _RightChildCategoryWidgetState();
}

class _RightChildCategoryWidgetState extends State<RightChildCategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      height: ScreenUtil().setHeight(60),
      width: ScreenUtil().setWidth(610),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // 监听值变化
          itemCount: context.watch<ChildCategory>().childCategoryList.length,
          itemBuilder: (context, index) {
            return _rightCategoryItem(
                index,
                // 监听值变化
                context.watch<ChildCategory>().childCategoryList[index]);
          }),
    );
  }

  // 右侧顶部分类栏每个子项
  _rightCategoryItem(int index, BxMallSubDto item) {
    bool isClick = false;
    // 赋值：如果点了其他的子类，isClick置为false
    index ==
            Provider.of<ChildCategory>(context, listen: false)
                .childCategoryIndex
        ? isClick = true
        : isClick = false;
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          // 当点击子类时，改变子类索引
          context.read<ChildCategory>().setChildIndex(index);
          setState(() {
            // 修改isClick的值
            index ==
                    Provider.of<ChildCategory>(context, listen: false)
                        .childCategoryIndex
                ? isClick = true
                : isClick = false;
          });
        },
        child: Text(
          item.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(22),
              color: isClick ? Colors.pink : Colors.black),
        ),
      ),
    );
  }
}

// 分类商品列表
class CategoryGoodsWidget extends StatefulWidget {
  @override
  _CategoryGoodsWidgetState createState() => _CategoryGoodsWidgetState();
}

class _CategoryGoodsWidgetState extends State<CategoryGoodsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(610),
      height: ScreenUtil().setHeight(1080),
      child: ListView.builder(
          itemCount:
              context.watch<CategoryGoodsListPorvider>().goodsDataList.length,
          itemBuilder: (context, index) {
            return _goodsItemWidget(
                context.watch<CategoryGoodsListPorvider>().goodsDataList,
                index);
          }),
    );
  }

  // 每个商品部件
  Widget _goodsItemWidget(List list, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(color: Colors.black12, width: 1))),
        child: Row(
          children: <Widget>[
            _goodsItemImageWidget(list, index),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _goodsItemNameWidget(list, index),
                _goodsItemPriceWidget(list, index)
              ],
            )
          ],
        ),
      ),
    );
  }

  // 商品图片部件
  Widget _goodsItemImageWidget(List list, int index) {
    return Container(
      width: ScreenUtil().setWidth(260),
      child: Image.network(list[index].image),
    );
  }

  // 商品名称部件
  Widget _goodsItemNameWidget(List list, int index) {
    return Container(
      width: ScreenUtil().setWidth(320),
      padding: EdgeInsets.only(left: 10, bottom: 20),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(24)),
      ),
    );
  }

  // 商品价格部件
  Widget _goodsItemPriceWidget(List list, int index) {
    return Container(
      padding: EdgeInsets.only(left: 10, top: 20),
      child: Row(
        children: <Widget>[
          Text(
            '价格￥${list[index].presentPrice}',
            style:
                TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(24)),
          ),
          Text(
            '￥${list[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_shop/provider/child_category_provider.dart';
import 'package:flutter_shop/service/service_methods.dart';
import 'dart:convert';
import '../model/category_model.dart';
import '../model/category_goods_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../provider/category_goods_list_provider.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../routers/application.dart';

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
        context.read<ChildCategory>().setChildCategory(
            categoryList[index].bxMallSubDto,
            categoryList[index].mallCategoryId);
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
      context.read<ChildCategory>().setChildCategory(
          categoryList[0].bxMallSubDto, categoryList[0].mallCategoryId);
    });
  }

  // 调接口获取分类下的商品
  _getCategoryGoods({String categoryId, String categorySubId}) async {
    var data = {
      'categoryId':
          categoryId == null ? '2c9f6c946cd22d7b016cd74220b70040' : categoryId,
      'categorySubId': categorySubId,
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
                // 监听值变化，传值给每个子项
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
          context.read<ChildCategory>().setChildIndex(index, item.mallSubId);
          setState(() {
            // 修改isClick的值
            index ==
                    Provider.of<ChildCategory>(context, listen: false)
                        .childCategoryIndex
                ? isClick = true
                : isClick = false;
          });
          // 查询每个子类下的商品
          _getCategoryGoods(
              categoryId:
                  Provider.of<ChildCategory>(context, listen: false).categoryId,
              // categoryId: context.watch<ChildCategory>().categoryId,
              categorySubId: item.mallSubId);
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

  // 调接口获取分类下的商品
  _getCategoryGoods({String categoryId, String categorySubId}) async {
    var data = {
      'categoryId':
          categoryId == null ? '2c9f6c946cd22d7b016cd74220b70040' : categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    await customRequest('getMallGoods', formData: data).then((value) {
      var responseData = json.decode(value.toString());
      CategoryGoodsModel goodsModel = CategoryGoodsModel.fromJson(responseData);
      if (goodsModel.data == null) {
        // 传空list
        context.read<CategoryGoodsListPorvider>().setGoodsDataList([]);
      } else {
        // 修改值
        context
            .read<CategoryGoodsListPorvider>()
            .setGoodsDataList(goodsModel.data);
      }
    });
  }
}

// 分类商品列表
class CategoryGoodsWidget extends StatefulWidget {
  @override
  _CategoryGoodsWidgetState createState() => _CategoryGoodsWidgetState();
}

class _CategoryGoodsWidgetState extends State<CategoryGoodsWidget> {
  ScrollController scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    // 重新build的时候，即切换小类或大类时，需要自动回到顶部
    try {
      if (context.watch<ChildCategory>().pageNo == 1) {
        scrollController.jumpTo(0.0);
      }
    } catch (e) {
      print('第一次进入页面： $e');
    }

    // 如果有数据，加载商品
    if (context.watch<CategoryGoodsListPorvider>().goodsDataList.length > 0) {
      return Expanded(
        child: Container(
          width: ScreenUtil().setWidth(610),
          height: ScreenUtil().setHeight(1080),
          //上拉刷新部件
          child: EasyRefresh(
            onLoad: () async {
              print('上拉刷新');
              // 先pageNo+1
              context.read<ChildCategory>().addPageNo();
              _getMoreGoods();
            },
            footer: ClassicalFooter(
              bgColor: Colors.white,
              textColor: Colors.pink,
              noMoreText: context.watch<ChildCategory>().noMoreText,
              showInfo: false,
              loadReadyText: '上拉加载',
              loadedText: '加载完成',
              enableInfiniteLoad: false, //上拉一下才会加载，不会自动加载，默认为true
            ),
            child: ListView.builder(
                controller: scrollController,
                itemCount: context
                    .watch<CategoryGoodsListPorvider>()
                    .goodsDataList
                    .length,
                itemBuilder: (context, index) {
                  return _goodsItemWidget(
                      context.watch<CategoryGoodsListPorvider>().goodsDataList,
                      index);
                }),
          ),
        ),
      );
    } else {
      // 如果没有数据，显示暂无商品
      return Text('暂无商品');
    }
  }

  // 调接口获取分类下的更多商品
  _getMoreGoods() async {
    var data = {
      'categoryId':
          Provider.of<ChildCategory>(context, listen: false).categoryId,
      'categorySubId':
          Provider.of<ChildCategory>(context, listen: false).categorySubId,
      'page': Provider.of<ChildCategory>(context, listen: false).pageNo
    };
    await customRequest('getMallGoods', formData: data).then((value) {
      var responseData = json.decode(value.toString());
      CategoryGoodsModel goodsModel = CategoryGoodsModel.fromJson(responseData);
      // 判断是否还有更多数据
      if (goodsModel.data == null) {
        // 传空list
        // context.read<CategoryGoodsListPorvider>().setMoreGoods([]);
        context.read<ChildCategory>().setNoMoreText('没有更多商品了');
        Fluttertoast.showToast(
            msg: '没有更多了',
            backgroundColor: Colors.pink,
            toastLength: Toast.LENGTH_LONG,
            fontSize: ScreenUtil().setSp(24),
            gravity: ToastGravity.CENTER);
      } else {
        // 修改值，加到原列表后边
        context.read<CategoryGoodsListPorvider>().setMoreGoods(goodsModel.data);
      }
    });
  }

  // 每个商品部件
  Widget _goodsItemWidget(List<CategoryGoodData> list, int index) {
    return InkWell(
      onTap: () {
        Application.router
            .navigateTo(context, '/goodDetail?goodId=${list[index].goodsId}');
      },
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
  Widget _goodsItemImageWidget(List<CategoryGoodData> list, int index) {
    return Container(
      width: ScreenUtil().setWidth(260),
      child: Image.network(list[index].image),
    );
  }

  // 商品名称部件
  Widget _goodsItemNameWidget(List<CategoryGoodData> list, int index) {
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
  Widget _goodsItemPriceWidget(List<CategoryGoodData> list, int index) {
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

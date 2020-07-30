import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../service/service_methods.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
// import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int pageNo = 1;
  List<Map> hotGoodsList = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getHotGoods();
  }

  // 获取火爆专区商品数据
  void _getHotGoods() {
    customRequest('homePageBelowConten', formData: {'page': pageNo})
        .then((value) {
      var data = json.decode(value.toString());
      if (data['data'] != null) {
        List<Map> newList = (data['data'] as List).cast();
        setState(() {
          hotGoodsList.addAll(newList);
          pageNo++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('生活+'),
      ),
      body: FutureBuilder(
        // future: getHomePageContent(),
        future: customRequest('homePageContent',
            formData: {'lon': '117.146728515625', 'lat': '36.659217834472656'}),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperDataList = (data['data']['slides'] as List).cast();
            List<Map> navigatorDataList =
                (data['data']['category'] as List).cast();
            String adPictureUrl =
                data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            List<Map> recommendList =
                (data['data']['recommend'] as List).cast();
            String floor1Pic = data['data']['floor1Pic']['PICTURE_ADDRESS'];
            List<Map> floor1Info = (data['data']['floor1'] as List).cast();
            String floor2Pic = data['data']['floor2Pic']['PICTURE_ADDRESS'];
            List<Map> floor2Info = (data['data']['floor2'] as List).cast();
            String floor3Pic = data['data']['floor3Pic']['PICTURE_ADDRESS'];
            List<Map> floor3Info = (data['data']['floor3'] as List).cast();

            return EasyRefresh(
                onLoad: () async {
                  // 上拉时执行的东西
                  print('开始加载更多火爆专区商品');
                  _getHotGoods();
                },
                footer: ClassicalFooter(
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  noMoreText: '', //目前没有判断是否还有更多，先设置为空
                  showInfo: false,
                  loadReadyText: '上拉加载',
                  loadedText: '加载完成',
                  enableInfiniteLoad: false, //上拉一下才会加载，不会自动加载，默认为true
                ),
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(
                      swiperDataList: swiperDataList,
                    ),
                    TopNavigator(
                      navigatorDataList: navigatorDataList,
                    ),
                    AdBanner(
                      adPictureUrl: adPictureUrl,
                    ),
                    ShopInfo(
                      leaderImage: leaderImage,
                      leaderPhone: leaderPhone,
                    ),
                    Recommend(
                      recommendList: recommendList,
                    ),
                    Floor(
                      floorPic: floor1Pic,
                      floorInfo: floor1Info,
                    ),
                    Floor(
                      floorPic: floor2Pic,
                      floorInfo: floor2Info,
                    ),
                    Floor(
                      floorPic: floor3Pic,
                      floorInfo: floor3Info,
                    ),
                    HotGoods(
                      hotGoodsList: this.hotGoodsList,
                    )
                  ],
                ));
          } else {
            return Center(
              child: Text('加载中。。。。'),
            );
          }
        },
      ),
    );
  }
}

// 轮播图
class SwiperDiy extends StatelessWidget {
  final List<Map> swiperDataList;
  const SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemCount: swiperDataList.length,
        itemBuilder: (context, index) {
          return Image.network(
            swiperDataList[index]['image'],
            fit: BoxFit.fill,
          );
        },
        autoplay: true,
        pagination: SwiperPagination(),
      ),
    );
  }
}

// 头部导航
class TopNavigator extends StatelessWidget {
  final List navigatorDataList;
  const TopNavigator({Key key, this.navigatorDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (this.navigatorDataList.length > 4) {
      this.navigatorDataList.removeRange(4, this.navigatorDataList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(130),
      padding: EdgeInsets.all(3),
      child: GridView.count(
        crossAxisCount: 4,
        // 禁止GridView滚动
        physics: NeverScrollableScrollPhysics(),
        // padding: EdgeInsets.all(5),
        children: navigatorDataList.map((item) {
          return InkWell(
            onTap: () {
              print('点击了导航 ${item['mallCategoryName']}');
            },
            child: Column(
              children: <Widget>[
                Image.network(
                  item['image'],
                  width: ScreenUtil().setWidth(95),
                ),
                Text(item['mallCategoryName'])
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 广告banner
class AdBanner extends StatelessWidget {
  final String adPictureUrl;
  const AdBanner({Key key, this.adPictureUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(this.adPictureUrl),
    );
  }
}

// 店铺信息
class ShopInfo extends StatelessWidget {
  final String leaderPhone;
  final String leaderImage;
  const ShopInfo({Key key, this.leaderImage, this.leaderPhone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _callLeader,
        child: Image.network(this.leaderImage),
      ),
    );
  }

  void _callLeader() async {
    String url = 'tel:' + leaderPhone;
    // String url = 'http://www.baidu.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw '$url is not valid';
    }
  }
}

// 商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key, this.recommendList}) : super(key: key);

  // 标题
  Widget _title() {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  // 推荐商品
  Widget _product(index) {
    return Container(
        child: InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(300),
        width: ScreenUtil().setWidth(250),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 0.5)),
        // margin: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Image.network(
              this.recommendList[index]['image'],
              fit: BoxFit.cover,
            ),
            Text('￥${this.recommendList[index]['mallPrice']}'),
            Text(
              '￥${this.recommendList[index]['price']}',
              style: TextStyle(
                  color: Colors.grey, decoration: TextDecoration.lineThrough),
            ),
          ],
        ),
      ),
    ));
  }

  // 推荐商品列表
  Widget _productList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        itemCount: this.recommendList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _product(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[SizedBox(height: 10), _title(), _productList()],
      ),
    );
  }
}

// 楼层
class Floor extends StatelessWidget {
  final String floorPic;
  final List floorInfo;
  const Floor({Key key, this.floorPic, this.floorInfo}) : super(key: key);

  // 楼层标题图片
  Widget floorTitle() {
    return Container(
      height: ScreenUtil().setHeight(200),
      padding: EdgeInsets.all(8),
      child: Image.network(this.floorPic),
      decoration: BoxDecoration(color: Colors.grey[200]),
    );
  }

  // 第一层楼
  Widget floor1Content() {
    return Container(
      child: Row(
        children: <Widget>[
          floorContentItem(0),
          Container(
            child: Column(
              children: <Widget>[
                floorContentItem(1),
                floorContentItem(2),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 第二层楼
  Widget floor2Content() {
    return Container(
      child: Row(
        children: <Widget>[floorContentItem(3), floorContentItem(4)],
      ),
    );
  }

  // 楼层中单个商品
  Widget floorContentItem(int index) {
    return Container(
      width: ScreenUtil().setWidth(374),
      child: InkWell(
        onTap: () {},
        child: Image.network(floorInfo[index]['image']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (floorInfo.length > 6) {
      floorInfo.removeRange(6, floorInfo.length);
    }
    return Container(
      decoration: BoxDecoration(color: Colors.grey[200]),
      height: ScreenUtil().setHeight(800),
      child: Column(
        children: <Widget>[floorTitle(), floor1Content(), floor2Content()],
      ),
    );
  }
}

// 火爆专区商品
class HotGoods extends StatefulWidget {
  final List<Map> hotGoodsList;
  HotGoods({Key key, this.hotGoodsList}) : super(key: key);

  @override
  _HotGoodsState createState() =>
      _HotGoodsState(hotGoodsList: this.hotGoodsList);
}

class _HotGoodsState extends State<HotGoods> {
  List<Map> hotGoodsList;
  _HotGoodsState({this.hotGoodsList});

  // 商品列表
  List<Widget> hotGoodsWidgetList() {
    List<Widget> hotGoodsWidgetList;
    if (hotGoodsList != null) {
      hotGoodsWidgetList = this.hotGoodsList.map((item) {
        // 返回每个商品widget
        return InkWell(
          onTap: () {},
          child: Container(
            width: ScreenUtil().setWidth(372),
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.network(item['image']),
                ),
                Container(
                  child: Text(
                    item['name'],
                    style: TextStyle(color: Colors.pink, fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      '￥${item['mallPrice']}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      '￥${item['price']}',
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();
      return hotGoodsWidgetList;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    child: Text(
                      '火',
                      style: TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(color: Colors.grey, width: 1)
                    ),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Text(
                    '火爆专区',
                  ),
                ],
              )),
          Wrap(
            children: hotGoodsWidgetList(),
          )
        ],
      ),
    );
  }
}

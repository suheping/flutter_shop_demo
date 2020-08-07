import 'package:flutter/material.dart';
import '../model/category_model.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> _list = []; //商品小类列表
  int _childIndex = 0; //当前第几个小类
  String _categoryId = '2c9f6c946cd22d7b016cd74220b70040'; //商品大类id
  String _categorySubId = ''; //默认小类id为空
  int _pageNo = 1; //默认加载第一页数据
  String _noMoreText = ''; //没有更多数据时的提示

  // 切换大类时的状态操作：变更该大类的小类列表
  void setChildCategory(List<BxMallSubDto> list, String categoryId) {
    _childIndex = 0; // 每次切换大类，子类索引置为0
    _pageNo = 1; // 每次切换大类，默认加载第一页数据
    _categorySubId = ''; //每次切换大类，小类id置为空
    _categoryId = categoryId;
    // 定义小类：全部
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '';
    all.mallSubName = '全部';
    all.comments = 'null';
    _list = [all];
    // 将获取到的小类添加到_list中
    _list.addAll(list);
    notifyListeners();
  }

  // 切换小类时的状态操作：变更该小类的索引、小类id、页码
  void setChildIndex(int index, String categorySubId) {
    _childIndex = index;
    _categorySubId = categorySubId;
    _pageNo = 1;
    notifyListeners();
  }

  void addPageNo() {
    _pageNo++;
  }

  void setNoMoreText(String noMoreText) {
    _noMoreText = noMoreText;
  }

  List<BxMallSubDto> get childCategoryList => _list;
  int get childCategoryIndex => _childIndex;
  String get categoryId => _categoryId;
  String get categorySubId => _categorySubId;
  int get pageNo => _pageNo;
  String get noMoreText => _noMoreText;
}

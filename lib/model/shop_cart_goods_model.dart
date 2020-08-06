class ShopCartGoodModel {
  String goodId;
  String goodName;
  double price;
  String image;
  int count;
  bool selected;

  ShopCartGoodModel(
      {this.goodId,
      this.goodName,
      this.price,
      this.image,
      this.count,
      this.selected});

  ShopCartGoodModel.fromJson(Map<String, dynamic> json) {
    goodId = json['goodId'];
    goodName = json['goodName'];
    price = json['price'];
    image = json['image'];
    count = json['count'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['goodId'] = this.goodId;
    data['goodName'] = this.goodName;
    data['price'] = this.price;
    data['image'] = this.image;
    data['count'] = this.count;
    data['selected'] = this.selected;
    return data;
  }
}

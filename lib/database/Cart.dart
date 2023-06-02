import 'package:hive/hive.dart';
part 'Cart.g.dart';

@HiveType(typeId: 11)
class Cart{
  @HiveField(0)
  List<String> productsId = new List();

  @HiveField(1)
  List<ProductCartItem> productCartItem = new List();

  @HiveField(2)
  double totalPrice = 0;

  @HiveField(3)
  int totalQuantity = 0;
}

@HiveType(typeId: 12)
class ProductCartItem {
  @HiveField(0)
  String _productId;

  @HiveField(1)
  String _productName;

  @HiveField(2)
  String _unitPrice;

  @HiveField(3)
  int _productQuantity;

  @HiveField(4)
  double _price;

  @HiveField(5)
  int _is18Plus;

  ProductCartItem();

  int get is18Plus => _is18Plus;

  set is18Plus(int value) {
    _is18Plus = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  int get productQuantity => _productQuantity;

  set productQuantity(int value) {
    _productQuantity = value;
  }

  String get unitPrice => _unitPrice;

  set unitPrice(String value) {
    _unitPrice = value;
  }

  String get productName => _productName;

  set productName(String value) {
    _productName = value;
  }

  String get productId => _productId;

  set productId(String value) {
    _productId = value;
  }
}


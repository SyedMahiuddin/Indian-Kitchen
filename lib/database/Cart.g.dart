// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Cart.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartAdapter extends TypeAdapter<Cart> {
  @override
  final int typeId = 11;

  @override
  Cart read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cart()
      ..productsId = (fields[0] as List)?.cast<String>()
      ..productCartItem = (fields[1] as List)?.cast<ProductCartItem>()
      ..totalPrice = fields[2] as double
      ..totalQuantity = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, Cart obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.productsId)
      ..writeByte(1)
      ..write(obj.productCartItem)
      ..writeByte(2)
      ..write(obj.totalPrice)
      ..writeByte(3)
      ..write(obj.totalQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductCartItemAdapter extends TypeAdapter<ProductCartItem> {
  @override
  final int typeId = 12;

  @override
  ProductCartItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductCartItem()
      .._productId = fields[0] as String
      .._productName = fields[1] as String
      .._unitPrice = fields[2] as String
      .._productQuantity = fields[3] as int
      .._price = fields[4] as double
      .._is18Plus = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, ProductCartItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._productId)
      ..writeByte(1)
      ..write(obj._productName)
      ..writeByte(2)
      ..write(obj._unitPrice)
      ..writeByte(3)
      ..write(obj._productQuantity)
      ..writeByte(4)
      ..write(obj._price)
      ..writeByte(5)
      ..write(obj._is18Plus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCartItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

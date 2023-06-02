// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LoginResponse.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LoginResponseAdapter extends TypeAdapter<LoginResponse> {
  @override
  final int typeId = 0;

  @override
  LoginResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LoginResponse(
      message: fields[0] as String,
      data: fields[1] as Data,
      token: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LoginResponse obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.message)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.token);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoginResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataAdapter extends TypeAdapter<Data> {
  @override
  final int typeId = 1;

  @override
  Data read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Data(
      appname: fields[0] as String,
      domain: fields[1] as String,
      galaryPath: fields[2] as String,
      contactPath: fields[3] as String,
      categories: (fields[4] as List)?.cast<Categories>(),
      orders: (fields[5] as List)?.cast<Orders>(),
      discounts: (fields[6] as List)?.cast<Discounts>(),
      config: (fields[7] as List)?.cast<Config>(),
      favourites: (fields[8] as List)?.cast<Products>(),
      user: fields[10] as User,
      version: fields[11] as int,
      contact: fields[12] as Contact,
      productList: (fields[9] as List)?.cast<Products>(),
      galleryList: (fields[13] as List)?.cast<Gallery>(),
      payment_link: fields[14] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.appname)
      ..writeByte(1)
      ..write(obj.domain)
      ..writeByte(2)
      ..write(obj.galaryPath)
      ..writeByte(3)
      ..write(obj.contactPath)
      ..writeByte(4)
      ..write(obj.categories)
      ..writeByte(5)
      ..write(obj.orders)
      ..writeByte(6)
      ..write(obj.discounts)
      ..writeByte(7)
      ..write(obj.config)
      ..writeByte(8)
      ..write(obj.favourites)
      ..writeByte(9)
      ..write(obj.productList)
      ..writeByte(10)
      ..write(obj.user)
      ..writeByte(11)
      ..write(obj.version)
      ..writeByte(12)
      ..write(obj.contact)
      ..writeByte(13)
      ..write(obj.galleryList)
      ..writeByte(14)
      ..write(obj.payment_link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrdersAdapter extends TypeAdapter<Orders> {
  @override
  final int typeId = 2;

  @override
  Orders read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Orders(
      id: fields[0] as int,
      date: fields[1] as String,
      time: fields[2] as String,
      diningTime: fields[3] as String,
      orderCode: fields[4] as String,
      customerId: fields[5] as int,
      customerName: fields[6] as String,
      customerMobile: fields[7] as String,
      customerEmail: fields[8] as String,
      customerAddress: fields[9] as String,
      customerPostcode: fields[10] as String,
      type: fields[11] as String,
      deliveryStatus: fields[12] as String,
      paymentStatus: fields[13] as String,
      paymentMethod: fields[14] as String,
      qty: fields[15] as int,
      subTotal: fields[16] as String,
      deliveryCharge: fields[17] as String,
      discountId: fields[18] as int,
      discountName: fields[19] as String,
      discountPercentage: fields[20] as String,
      discountAmount: fields[21] as String,
      grandTotal: fields[22] as String,
      paymentAmount: fields[23] as String,
      createdAt: fields[24] as String,
      updatedAt: fields[25] as String,
      detail: (fields[26] as List)?.cast<OrderDetail>(),
      delivery_time: fields[27] as String,
      payment_token: fields[28] as String,
      delivery_time_text: fields[29] as String,
      order_for: fields[30] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Orders obj) {
    writer
      ..writeByte(31)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.diningTime)
      ..writeByte(4)
      ..write(obj.orderCode)
      ..writeByte(5)
      ..write(obj.customerId)
      ..writeByte(6)
      ..write(obj.customerName)
      ..writeByte(7)
      ..write(obj.customerMobile)
      ..writeByte(8)
      ..write(obj.customerEmail)
      ..writeByte(9)
      ..write(obj.customerAddress)
      ..writeByte(10)
      ..write(obj.customerPostcode)
      ..writeByte(11)
      ..write(obj.type)
      ..writeByte(12)
      ..write(obj.deliveryStatus)
      ..writeByte(13)
      ..write(obj.paymentStatus)
      ..writeByte(14)
      ..write(obj.paymentMethod)
      ..writeByte(15)
      ..write(obj.qty)
      ..writeByte(16)
      ..write(obj.subTotal)
      ..writeByte(17)
      ..write(obj.deliveryCharge)
      ..writeByte(18)
      ..write(obj.discountId)
      ..writeByte(19)
      ..write(obj.discountName)
      ..writeByte(20)
      ..write(obj.discountPercentage)
      ..writeByte(21)
      ..write(obj.discountAmount)
      ..writeByte(22)
      ..write(obj.grandTotal)
      ..writeByte(23)
      ..write(obj.paymentAmount)
      ..writeByte(24)
      ..write(obj.createdAt)
      ..writeByte(25)
      ..write(obj.updatedAt)
      ..writeByte(26)
      ..write(obj.detail)
      ..writeByte(27)
      ..write(obj.delivery_time)
      ..writeByte(28)
      ..write(obj.payment_token)
      ..writeByte(29)
      ..write(obj.delivery_time_text)
      ..writeByte(30)
      ..write(obj.order_for);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrderDetailAdapter extends TypeAdapter<OrderDetail> {
  @override
  final int typeId = 3;

  @override
  OrderDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderDetail(
      orderId: fields[0] as int,
      productId: fields[1] as int,
      date: fields[2] as String,
      time: fields[3] as String,
      diningTime: fields[4] as String,
      productName: fields[5] as String,
      unitPrice: fields[6] as String,
      qty: fields[7] as int,
      price: fields[8] as String,
      isActive: fields[9] as int,
      createdAt: fields[10] as String,
      updatedAt: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrderDetail obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.diningTime)
      ..writeByte(5)
      ..write(obj.productName)
      ..writeByte(6)
      ..write(obj.unitPrice)
      ..writeByte(7)
      ..write(obj.qty)
      ..writeByte(8)
      ..write(obj.price)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoriesAdapter extends TypeAdapter<Categories> {
  @override
  final int typeId = 4;

  @override
  Categories read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Categories(
      id: fields[0] as int,
      parentId: fields[1] as int,
      name: fields[2] as String,
      isActive: fields[3] as int,
      categories: (fields[4] as List)?.cast<Categories>(),
      products: (fields[5] as List)?.cast<Products>(),
      details: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Categories obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.parentId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.isActive)
      ..writeByte(4)
      ..write(obj.categories)
      ..writeByte(5)
      ..write(obj.products)
      ..writeByte(6)
      ..write(obj.details);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoriesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductsAdapter extends TypeAdapter<Products> {
  @override
  final int typeId = 5;

  @override
  Products read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Products(
      id: fields[0] as int,
      categoryId: fields[1] as int,
      name: fields[2] as String,
      rateOnline: fields[3] as String,
      details: fields[4] as String,
      isNew: fields[5] as int,
      is18plus: fields[6] as int,
      displayorder: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Products obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.categoryId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.rateOnline)
      ..writeByte(4)
      ..write(obj.details)
      ..writeByte(5)
      ..write(obj.isNew)
      ..writeByte(6)
      ..write(obj.is18plus)
      ..writeByte(7)
      ..write(obj.displayorder);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DiscountsAdapter extends TypeAdapter<Discounts> {
  @override
  final int typeId = 6;

  @override
  Discounts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Discounts(
      id: fields[0] as int,
      name: fields[1] as String,
      isOnline: fields[2] as int,
      isOffline: fields[3] as int,
      onCollection: fields[4] as int,
      onDelivery: fields[5] as int,
      onSeated: fields[6] as int,
      onFirstOrder: fields[7] as int,
      applyBy: fields[8] as String,
      discountAmount: fields[9] as String,
      minumumOrderAmount: fields[10] as String,
      startDate: fields[11] as String,
      endDate: fields[12] as String,
      day01: fields[13] as int,
      day02: fields[14] as int,
      day03: fields[15] as int,
      day04: fields[16] as int,
      day05: fields[17] as int,
      day06: fields[18] as int,
      day07: fields[19] as int,
      startTime: fields[20] as String,
      endTime: fields[21] as String,
      imgSrc: fields[22] as String,
      imgAlt: fields[23] as String,
      isActive: fields[24] as int,
      createdAt: fields[25] as String,
      updatedAt: fields[26] as String,
      displayOrder: fields[27] as int,
      on_cash: fields[28] as int,
      short_name: fields[29] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Discounts obj) {
    writer
      ..writeByte(30)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isOnline)
      ..writeByte(3)
      ..write(obj.isOffline)
      ..writeByte(4)
      ..write(obj.onCollection)
      ..writeByte(5)
      ..write(obj.onDelivery)
      ..writeByte(6)
      ..write(obj.onSeated)
      ..writeByte(7)
      ..write(obj.onFirstOrder)
      ..writeByte(8)
      ..write(obj.applyBy)
      ..writeByte(9)
      ..write(obj.discountAmount)
      ..writeByte(10)
      ..write(obj.minumumOrderAmount)
      ..writeByte(11)
      ..write(obj.startDate)
      ..writeByte(12)
      ..write(obj.endDate)
      ..writeByte(13)
      ..write(obj.day01)
      ..writeByte(14)
      ..write(obj.day02)
      ..writeByte(15)
      ..write(obj.day03)
      ..writeByte(16)
      ..write(obj.day04)
      ..writeByte(17)
      ..write(obj.day05)
      ..writeByte(18)
      ..write(obj.day06)
      ..writeByte(19)
      ..write(obj.day07)
      ..writeByte(20)
      ..write(obj.startTime)
      ..writeByte(21)
      ..write(obj.endTime)
      ..writeByte(22)
      ..write(obj.imgSrc)
      ..writeByte(23)
      ..write(obj.imgAlt)
      ..writeByte(24)
      ..write(obj.isActive)
      ..writeByte(25)
      ..write(obj.createdAt)
      ..writeByte(26)
      ..write(obj.updatedAt)
      ..writeByte(27)
      ..write(obj.displayOrder)
      ..writeByte(28)
      ..write(obj.on_cash)
      ..writeByte(29)
      ..write(obj.short_name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscountsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConfigAdapter extends TypeAdapter<Config> {
  @override
  final int typeId = 7;

  @override
  Config read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Config(
      id: fields[0] as int,
      alias: fields[1] as String,
      value: fields[2] as String,
      unit: fields[3] as String,
      createdAt: fields[4] as String,
      updatedAt: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Config obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.alias)
      ..writeByte(2)
      ..write(obj.value)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 8;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      name: fields[1] as String,
      mobile: fields[2] as String,
      email: fields[3] as String,
      emailVerifiedAt: fields[4] as String,
      twoFactorSecret: fields[5] as String,
      twoFactorRecoveryCodes: fields[6] as String,
      apiToken: fields[7] as String,
      role: fields[8] as String,
      status: fields[9] as String,
      address: fields[10] as String,
      postcode: fields[11] as String,
      isMobileVerified: fields[12] as int,
      isEmailVerified: fields[13] as int,
      createdAt: fields[14] as String,
      updatedAt: fields[15] as String,
      phone_code: fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.mobile)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.emailVerifiedAt)
      ..writeByte(5)
      ..write(obj.twoFactorSecret)
      ..writeByte(6)
      ..write(obj.twoFactorRecoveryCodes)
      ..writeByte(7)
      ..write(obj.apiToken)
      ..writeByte(8)
      ..write(obj.role)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.postcode)
      ..writeByte(12)
      ..write(obj.isMobileVerified)
      ..writeByte(13)
      ..write(obj.isEmailVerified)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.phone_code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContactAdapter extends TypeAdapter<Contact> {
  @override
  final int typeId = 9;

  @override
  Contact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Contact(
      id: fields[0] as int,
      phone: fields[1] as String,
      email: fields[2] as String,
      website: fields[3] as String,
      address: fields[4] as String,
      image: fields[5] as String,
      createdAt: fields[6] as String,
      updatedAt: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Contact obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phone)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.website)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GalleryAdapter extends TypeAdapter<Gallery> {
  @override
  final int typeId = 10;

  @override
  Gallery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Gallery(
      id: fields[0] as int,
      name: fields[1] as String,
      image: fields[2] as String,
      displayorder: fields[3] as int,
      createdAt: fields[4] as String,
      updatedAt: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Gallery obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.displayorder)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GalleryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

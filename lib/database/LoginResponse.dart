import 'package:hive/hive.dart';

part 'LoginResponse.g.dart';

@HiveType(typeId: 0)
class LoginResponse {
  @HiveField(0)
  String message;

  @HiveField(1)
  Data data;

  @HiveField(2)
  String token;

  LoginResponse({this.message, this.data, this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

@HiveType(typeId: 1)
class Data {
  @HiveField(0)
  String appname;

  @HiveField(1)
  String domain;

  @HiveField(2)
  String galaryPath;

  @HiveField(3)
  String contactPath;

  @HiveField(4)
  List<Categories> categories;

  @HiveField(5)
  List<Orders> orders;

  @HiveField(6)
  List<Discounts> discounts;

  @HiveField(7)
  List<Config> config;

  @HiveField(8)
  List<Products> favourites;

  @HiveField(9)
  List<Products> productList;

  @HiveField(10)
  User user;

  @HiveField(11)
  int version;

  @HiveField(12)
  Contact contact;

  @HiveField(13)
  List<Gallery> galleryList;

  @HiveField(14)
  String payment_link;

  Data(
      {this.appname,
      this.domain,
      this.galaryPath,
      this.contactPath,
      this.categories,
      this.orders,
      this.discounts,
      this.config,
      this.favourites,
      this.user,
      this.version,
      this.contact,
        this.productList,
      this.galleryList, this.payment_link});

  Data.fromJson(Map<String, dynamic> json) {
    appname = json['appname'];
    domain = json['domain'];
    galaryPath = json['gallery_path'];
    contactPath = json['contact_path'];
    payment_link = json['payment_link'];
    version = json['version'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['favourites'] != null) {
      favourites = new List<Products>();
      json['favourites'].forEach((v) {
        favourites.add(new Products.fromJson(v));
      });
    }
    if (json['orders'] != null) {
      orders = new List<Orders>();
      json['orders'].forEach((v) {
        orders.add(new Orders.fromJson(v));
      });
    }
    if (json['discounts'] != null) {
      discounts = new List<Discounts>();
      json['discounts'].forEach((v) {
        discounts.add(new Discounts.fromJson(v));
      });
    }
    if (json['config'] != null) {
      config = new List<Config>();
      json['config'].forEach((v) {
        config.add(new Config.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    contact =
        json['contact'] != null ? new Contact.fromJson(json['contact']) : null;

    if (json['products'] != null) {
      productList = new List<Products>();
      json['products'].forEach((v) {
        productList.add(new Products.fromJson(v));
      });
    }
    if (json['gallery'] != null) {
      galleryList = new List<Gallery>();
      json['gallery'].forEach((v) {
        galleryList.add(new Gallery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appname'] = this.appname;
    data['domain'] = this.domain;
    data['gallery_path'] = this.galaryPath;
    data['contact_path'] = this.contactPath;
    data['payment_link'] = this.payment_link;
    data['version'] = this.version;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    if (this.discounts != null) {
      data['discounts'] = this.discounts.map((v) => v.toJson()).toList();
    }
    if (this.config != null) {
      data['config'] = this.config.map((v) => v.toJson()).toList();
    }
    if (this.favourites != null) {
      data['favourites'] = this.favourites.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.contact != null) {
      data['contact'] = this.contact.toJson();
    }
    if (this.productList != null) {
      data['products'] = this.productList.map((v) => v.toJson()).toList();
    }
    if (this.galleryList != null) {
      data['gallery'] = this.galleryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 2)
class Orders {
  @HiveField(0)
  int id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String time;

  @HiveField(3)
  String diningTime;

  @HiveField(4)
  String orderCode;

  @HiveField(5)
  int customerId;

  @HiveField(6)
  String customerName;

  @HiveField(7)
  String customerMobile;

  @HiveField(8)
  String customerEmail;

  @HiveField(9)
  String customerAddress;

  @HiveField(10)
  String customerPostcode;

  @HiveField(11)
  String type;

  @HiveField(12)
  String deliveryStatus;

  @HiveField(13)
  String paymentStatus;

  @HiveField(14)
  String paymentMethod;

  @HiveField(15)
  int qty;

  @HiveField(16)
  String subTotal;

  @HiveField(17)
  String deliveryCharge;

  @HiveField(18)
  int discountId;

  @HiveField(19)
  String discountName;

  @HiveField(20)
  String discountPercentage;

  @HiveField(21)
  String discountAmount;

  @HiveField(22)
  String grandTotal;

  @HiveField(23)
  String paymentAmount;

  @HiveField(24)
  String createdAt;

  @HiveField(25)
  String updatedAt;

  @HiveField(26)
  List<OrderDetail> detail;

  @HiveField(27)
  String delivery_time;

  @HiveField(28)
  String payment_token;

  @HiveField(29)
  String delivery_time_text;

  @HiveField(30)
  String order_for;

  Orders(
      {this.id,
      this.date,
      this.time,
      this.diningTime,
      this.orderCode,
      this.customerId,
      this.customerName,
      this.customerMobile,
      this.customerEmail,
      this.customerAddress,
      this.customerPostcode,
      this.type,
      this.deliveryStatus,
      this.paymentStatus,
      this.paymentMethod,
      this.qty,
      this.subTotal,
      this.deliveryCharge,
      this.discountId,
      this.discountName,
      this.discountPercentage,
      this.discountAmount,
      this.grandTotal,
      this.paymentAmount,
      this.createdAt,
      this.updatedAt,
      this.detail, this.delivery_time, this.payment_token, this.delivery_time_text, this.order_for});

  Orders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    diningTime = json['dining_time'];
    orderCode = json['order_code'];
    customerId = json['customer_id'];
    customerName = json['customer_name'];
    customerMobile = json['customer_mobile'];
    customerEmail = json['customer_email'];
    customerAddress = json['customer_address'];
    customerPostcode = json['customer_postcode'];
    type = json['type'];
    deliveryStatus = json['delivery_status'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
    qty = json['qty'];
    subTotal = json['sub_total'];
    deliveryCharge = json['delivery_charge'];
    discountId = json['discount_id'];
    discountName = json['discount_name'];
    discountPercentage = json['discount_percentage'];
    discountAmount = json['discount_amount'];
    grandTotal = json['grand_total'];
    paymentAmount = json['payment_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    delivery_time = json['delivery_time'];
    payment_token = json['payment_token'];
    delivery_time_text = json['delivery_time_text'];
    order_for = json['order_for'];
    if (json['detail'] != null) {
      detail = new List<OrderDetail>();
      json['detail'].forEach((v) {
        detail.add(new OrderDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['dining_time'] = this.diningTime;
    data['order_code'] = this.orderCode;
    data['customer_id'] = this.customerId;
    data['customer_name'] = this.customerName;
    data['customer_mobile'] = this.customerMobile;
    data['customer_email'] = this.customerEmail;
    data['customer_address'] = this.customerAddress;
    data['customer_postcode'] = this.customerPostcode;
    data['type'] = this.type;
    data['delivery_status'] = this.deliveryStatus;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    data['qty'] = this.qty;
    data['sub_total'] = this.subTotal;
    data['delivery_charge'] = this.deliveryCharge;
    data['discount_id'] = this.discountId;
    data['discount_name'] = this.discountName;
    data['discount_percentage'] = this.discountPercentage;
    data['discount_amount'] = this.discountAmount;
    data['grand_total'] = this.grandTotal;
    data['payment_amount'] = this.paymentAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['delivery_time'] = this.delivery_time;
    data['payment_token'] = this.payment_token;
    data['delivery_time_text'] = this.delivery_time_text;
    data['order_for'] = this.order_for;
    if (this.detail != null) {
      data['detail'] = this.detail.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 3)
class OrderDetail {
  @HiveField(0)
  int orderId;

  @HiveField(1)
  int productId;

  @HiveField(2)
  String date;

  @HiveField(3)
  String time;

  @HiveField(4)
  String diningTime;

  @HiveField(5)
  String productName;

  @HiveField(6)
  String unitPrice;

  @HiveField(7)
  int qty;

  @HiveField(8)
  String price;

  @HiveField(9)
  int isActive;

  @HiveField(10)
  String createdAt;

  @HiveField(11)
  String updatedAt;

  OrderDetail(
      {this.orderId,
      this.productId,
      this.date,
      this.time,
      this.diningTime,
      this.productName,
      this.unitPrice,
      this.qty,
      this.price,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  OrderDetail.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    productId = json['product_id'];
    date = json['date'];
    time = json['time'];
    diningTime = json['dining_time'];
    productName = json['product_name'];
    unitPrice = json['unit_price'];
    qty = json['qty'];
    price = json['price'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['dining_time'] = this.diningTime;
    data['product_name'] = this.productName;
    data['unit_price'] = this.unitPrice;
    data['qty'] = this.qty;
    data['price'] = this.price;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

@HiveType(typeId: 4)
class Categories {
  @HiveField(0)
  int id;

  @HiveField(1)
  int parentId;

  @HiveField(2)
  String name;

  @HiveField(3)
  int isActive;

  @HiveField(4)
  List<Categories> categories;

  @HiveField(5)
  List<Products> products;

  @HiveField(6)
  String details;

  Categories(
      {this.id,
      this.parentId,
      this.name,
      this.isActive,
      this.categories,
      this.products, this.details});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    name = json['name'];
    isActive = json['is_active'];
    details = json['details'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['name'] = this.name;
    data['is_active'] = this.isActive;
    data['details'] = this.details;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 5)
class Products {

  @HiveField(0)
  int id;

  @HiveField(1)
  int categoryId;

  @HiveField(2)
  String name;

  @HiveField(3)
  String rateOnline;

  @HiveField(4)
  String details;

  @HiveField(5)
  int isNew;

  @HiveField(6)
  int is18plus;

  @HiveField(7)
  int displayorder;

  Products(
      {this.id,
        this.categoryId,
        this.name,
        this.rateOnline,
        this.details,
        this.isNew,
        this.is18plus,
        this.displayorder});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    rateOnline = json['rate_online'];
    details = json['details'];
    isNew = json['is_new'];
    is18plus = json['is_18plus'];
    displayorder = json['displayorder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['rate_online'] = this.rateOnline;
    data['details'] = this.details;
    data['is_new'] = this.isNew;
    data['is_18plus'] = this.is18plus;
    data['displayorder'] = this.displayorder;
    return data;
  }
}

@HiveType(typeId: 6)
class Discounts {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int isOnline;

  @HiveField(3)
  int isOffline;

  @HiveField(4)
  int onCollection;

  @HiveField(5)
  int onDelivery;

  @HiveField(6)
  int onSeated;

  @HiveField(7)
  int onFirstOrder;

  @HiveField(8)
  String applyBy;

  @HiveField(9)
  String discountAmount;

  @HiveField(10)
  String minumumOrderAmount;

  @HiveField(11)
  String startDate;

  @HiveField(12)
  String endDate;

  @HiveField(13)
  int day01;

  @HiveField(14)
  int day02;

  @HiveField(15)
  int day03;

  @HiveField(16)
  int day04;

  @HiveField(17)
  int day05;

  @HiveField(18)
  int day06;

  @HiveField(19)
  int day07;

  @HiveField(20)
  String startTime;

  @HiveField(21)
  String endTime;

  @HiveField(22)
  String imgSrc;

  @HiveField(23)
  String imgAlt;

  @HiveField(24)
  int isActive;

  @HiveField(25)
  String createdAt;

  @HiveField(26)
  String updatedAt;

  @HiveField(27)
  int displayOrder;

  @HiveField(28)
  int on_cash;

  @HiveField(29)
  String short_name;

  Discounts(
      {this.id,
      this.name,
      this.isOnline,
      this.isOffline,
      this.onCollection,
      this.onDelivery,
      this.onSeated,
      this.onFirstOrder,
      this.applyBy,
      this.discountAmount,
      this.minumumOrderAmount,
      this.startDate,
      this.endDate,
      this.day01,
      this.day02,
      this.day03,
      this.day04,
      this.day05,
      this.day06,
      this.day07,
      this.startTime,
      this.endTime,
      this.imgSrc,
      this.imgAlt,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.displayOrder, this.on_cash, this.short_name});

  Discounts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isOnline = json['is_online'];
    isOffline = json['is_offline'];
    onCollection = json['on_collection'];
    onDelivery = json['on_delivery'];
    onSeated = json['on_seated'];
    onFirstOrder = json['on_first_order'];
    applyBy = json['apply_by'];
    discountAmount = json['discount_amount'];
    minumumOrderAmount = json['minumum_order_amount'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    day01 = json['day_01'];
    day02 = json['day_02'];
    day03 = json['day_03'];
    day04 = json['day_04'];
    day05 = json['day_05'];
    day06 = json['day_06'];
    day07 = json['day_07'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    imgSrc = json['img_src'];
    imgAlt = json['img_alt'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    displayOrder = json['display_order'];
    on_cash = json['on_cash'];
    short_name = json['short_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['is_online'] = this.isOnline;
    data['is_offline'] = this.isOffline;
    data['on_collection'] = this.onCollection;
    data['on_delivery'] = this.onDelivery;
    data['on_seated'] = this.onSeated;
    data['on_first_order'] = this.onFirstOrder;
    data['apply_by'] = this.applyBy;
    data['discount_amount'] = this.discountAmount;
    data['minumum_order_amount'] = this.minumumOrderAmount;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['day_01'] = this.day01;
    data['day_02'] = this.day02;
    data['day_03'] = this.day03;
    data['day_04'] = this.day04;
    data['day_05'] = this.day05;
    data['day_06'] = this.day06;
    data['day_07'] = this.day07;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['img_src'] = this.imgSrc;
    data['img_alt'] = this.imgAlt;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['display_order'] = this.displayOrder;
    data['on_cash'] = this.on_cash;
    data['short_name'] = this.short_name;
    return data;
  }
}

@HiveType(typeId: 7)
class Config {
  @HiveField(0)
  int id;

  @HiveField(1)
  String alias;

  @HiveField(2)
  String value;

  @HiveField(3)
  String unit;

  @HiveField(4)
  String createdAt;

  @HiveField(5)
  String updatedAt;

  Config(
      {this.id,
      this.alias,
      this.value,
      this.unit,
      this.createdAt,
      this.updatedAt});

  Config.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    alias = json['alias'];
    value = json['value'];
    unit = json['unit'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alias'] = this.alias;
    data['value'] = this.value;
    data['unit'] = this.unit;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

@HiveType(typeId: 8)
class User {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String mobile;

  @HiveField(3)
  String email;

  @HiveField(4)
  String emailVerifiedAt;

  @HiveField(5)
  String twoFactorSecret;

  @HiveField(6)
  String twoFactorRecoveryCodes;

  @HiveField(7)
  String apiToken;

  @HiveField(8)
  String role;

  @HiveField(9)
  String status;

  @HiveField(10)
  String address;

  @HiveField(11)
  String postcode;

  @HiveField(12)
  int isMobileVerified;

  @HiveField(13)
  int isEmailVerified;

  @HiveField(14)
  String createdAt;

  @HiveField(15)
  String updatedAt;

  @HiveField(16)
  String phone_code;

  User(
      {this.id,
      this.name,
      this.mobile,
      this.email,
      this.emailVerifiedAt,
      this.twoFactorSecret,
      this.twoFactorRecoveryCodes,
      this.apiToken,
      this.role,
      this.status,
      this.address,
      this.postcode,
      this.isMobileVerified,
      this.isEmailVerified,
      this.createdAt,
      this.updatedAt,
      this.phone_code});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    twoFactorSecret = json['two_factor_secret'];
    twoFactorRecoveryCodes = json['two_factor_recovery_codes'];
    apiToken = json['api_token'];
    role = json['role'];
    status = json['status'];
    address = json['address'];
    postcode = json['postcode'];
    isMobileVerified = json['is_mobile_verified'];
    isEmailVerified = json['is_email_verified'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    phone_code = json['phone_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['two_factor_secret'] = this.twoFactorSecret;
    data['two_factor_recovery_codes'] = this.twoFactorRecoveryCodes;
    data['api_token'] = this.apiToken;
    data['role'] = this.role;
    data['status'] = this.status;
    data['address'] = this.address;
    data['postcode'] = this.postcode;
    data['is_mobile_verified'] = this.isMobileVerified;
    data['is_email_verified'] = this.isEmailVerified;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['phone_code'] = this.phone_code;
    return data;
  }
}

@HiveType(typeId: 9)
class Contact {
  @HiveField(0)
  int id;

  @HiveField(1)
  String phone;

  @HiveField(2)
  String email;

  @HiveField(3)
  String website;

  @HiveField(4)
  String address;

  @HiveField(5)
  String image;

  @HiveField(6)
  String createdAt;

  @HiveField(7)
  String updatedAt;

  Contact(
      {this.id,
      this.phone,
      this.email,
      this.website,
      this.address,
        this.image,
      this.createdAt,
      this.updatedAt});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phone = json['phone'];
    email = json['email'];
    website = json['website'];
    address = json['address'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['website'] = this.website;
    data['address'] = this.address;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

@HiveType(typeId: 10)
class Gallery {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String image;

  @HiveField(3)
  int displayorder;

  @HiveField(4)
  String createdAt;

  @HiveField(5)
  String updatedAt;

  Gallery(
      {this.id,
        this.name,
        this.image,
        this.displayorder,
        this.createdAt,
        this.updatedAt});

  Gallery.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    displayorder = json['displayorder'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['displayorder'] = this.displayorder;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class PhoneCode {
  String phoneCode;
  String countryCode;

  PhoneCode({this.phoneCode, this.countryCode});

  PhoneCode.fromJson(Map<String, dynamic> json) {
    phoneCode = json['phone_code'];
    countryCode = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone_code'] = this.phoneCode;
    data['country_code'] = this.countryCode;
    return data;
  }

}

class CoverageArea {
  String latitude;
  String longitude;
  String deliveryDistance;

  CoverageArea({this.latitude, this.longitude, this.deliveryDistance});

  CoverageArea.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    deliveryDistance = json['delivery_distance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['delivery_distance'] = this.deliveryDistance;
    return data;
  }
}

class Updated {
  int updated;

  Updated({this.updated});

  Updated.fromJson(Map<String, dynamic> json) {
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updated'] = this.updated;
    return data;
  }
}
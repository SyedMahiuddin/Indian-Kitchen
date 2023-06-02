class ReservationPlaceOrder {
  String orderType;
  String name;
  String mobile;
  String email;
  String address;
  String postcode;
  String discountId;
  String date;
  String time;
  String diningTime;
  String fingerprint;
  String payment_method;
  String special_requirement;
  String order_for;
  String is_subscribed;
  String guest_qty;
  String delivery_charge;
  //List<Detail> detail;

  ReservationPlaceOrder(
      {this.orderType,
        this.name,
        this.mobile,
        this.email,
        this.address,
        this.postcode,
        this.discountId,
        this.date,
        this.time,
        this.diningTime,
        this.fingerprint,  this.payment_method, this.special_requirement,
        this.order_for, this.is_subscribed, guest_qty, this.delivery_charge});

  ReservationPlaceOrder.fromJson(Map<String, dynamic> json) {
    payment_method = json['payment_method'];
    orderType = json['order_type'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    postcode = json['postcode'];
    discountId = json['discount_id'];
    date = json['date'];
    time = json['time'];
    diningTime = json['dining_time'];
    fingerprint = json['finger_print'];
    special_requirement = json['special_requirement'];
    order_for = json['order_for'];
    is_subscribed = json['is_subscribed'];
    guest_qty = json['guest_qty'];
    delivery_charge = json['delivery_charge'];
    // if (json['detail'] != null) {
    //   detail = new List<Detail>();
    //   json['detail'].forEach((v) {
    //     detail.add(new Detail.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_type'] = this.orderType;
    data['payment_method'] = this.payment_method;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['address'] = this.address;
    data['postcode'] = this.postcode;
    data['discount_id'] = this.discountId;
    data['date'] = this.date;
    data['time'] = this.time;
    data['dining_time'] = this.diningTime;
    data['finger_print'] = this.fingerprint;
    data['special_requirement'] = this.special_requirement;
    data['order_for'] = this.order_for;
    data['is_subscribed'] = this.is_subscribed;
    data['guest_qty'] = this.guest_qty;
    data['delivery_charge'] = this.delivery_charge;
    // if (this.detail != null) {
    //   data['detail'] = this.detail.map((v) => v.toJson()).toString();
    // }
    return data;
  }
}
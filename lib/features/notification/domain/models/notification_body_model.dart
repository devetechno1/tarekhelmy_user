enum NotificationType{
  message,
  order,
  general,
  // ignore: constant_identifier_names
  referral_code,
  otp,
  // ignore: constant_identifier_names
  add_fund,
  block,
  unblock,
  //ignore: constant_identifier_names
  referral_earn,
  //ignore: constant_identifier_names
  cashback,
  //ignore: constant_identifier_names
  loyalty_point
}

class NotificationBodyModel {
  NotificationType? notificationType;
  int? orderId;
  int? adminId;
  int? deliverymanId;
  int? restaurantId;
  String? type;
  int? conversationId;
  int? index;
  String? image;
  String? name;
  String? receiverType;


  NotificationBodyModel({
    this.notificationType,
    this.orderId,
    this.adminId,
    this.deliverymanId,
    this.restaurantId,
    this.type,
    this.conversationId,
    this.index,
    this.image,
    this.name,
    this.receiverType,
  });

  NotificationBodyModel.fromJson(Map<String, dynamic> json) {
    notificationType = convertToEnum(json['order_notification']);
    orderId = json['order_id'];
    adminId = json['admin_id'];
    deliverymanId = json['deliveryman_id'];
    restaurantId = json['restaurant_id'];
    type = json['type'];
    conversationId = json['conversation_id'];
    index = json['index'];
    image = json['image'];
    name = json['name'];
    receiverType = json['receiver_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_notification'] = notificationType.toString();
    data['order_id'] = orderId;
    data['admin_id'] = adminId;
    data['deliveryman_id'] = deliverymanId;
    data['restaurant_id'] = restaurantId;
    data['type'] = type;
    data['conversation_id'] = conversationId;
    data['index'] = index;
    data['image'] = image;
    data['name'] = name;
    data['receiver_type'] = receiverType;
    return data;
  }

  NotificationType convertToEnum(String? enumString) {
    final Map<String, NotificationType> enumMap = {
      NotificationType.general.toString(): NotificationType.general,
      NotificationType.order.toString(): NotificationType.order,
      NotificationType.message.toString(): NotificationType.message,
      NotificationType.referral_code.toString(): NotificationType.referral_code,
      NotificationType.otp.toString(): NotificationType.otp,
      NotificationType.add_fund.toString(): NotificationType.add_fund,
      NotificationType.block.toString(): NotificationType.block,
      NotificationType.unblock.toString(): NotificationType.unblock,
      NotificationType.referral_earn.toString(): NotificationType.referral_earn,
      NotificationType.cashback.toString(): NotificationType.cashback,
      NotificationType.loyalty_point.toString(): NotificationType.loyalty_point,
    };

    return enumMap[enumString] ?? NotificationType.general;
  }

}

import 'package:sixam_mart/features/chat/domain/models/conversation_model.dart';

class ChatModel {
  int? totalSize;
  int? limit;
  int? offset;
  bool? status;
  Conversation? conversation;
  List<Message>? messages;

  ChatModel({this.totalSize, this.limit, this.offset, this.status, this.conversation, this.messages});

  ChatModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'];
    offset = json['offset'];
    status = json['status'];
    conversation = json['conversation'] != null ? Conversation.fromJson(json['conversation']) : null;
    if (json['messages'] != null) {
      messages = <Message>[];
      json['messages'].forEach((v) {
        messages!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['offset'] = offset;
    data['status'] = status;
    if (conversation != null) {
      data['conversation'] = conversation!.toJson();
    }
    if (messages != null) {
      data['messages'] = messages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  int? id;
  int? conversationId;
  int? senderId;
  String? message;
  List<String>? fileFullUrl;
  int? isSeen;
  int? orderId;
  Order? order;
  String? createdAt;
  String? updatedAt;

  Message({
    this.id,
    this.conversationId,
    this.senderId,
    this.message,
    this.fileFullUrl,
    this.isSeen,
    this.orderId,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    conversationId = json['conversation_id'];
    senderId = json['sender_id'];
    message = json['message'];
    if(json['file_full_url'] != null) {
      fileFullUrl = [];
      json['file_full_url'].forEach((v) {
        if(v != null) {
          fileFullUrl!.add(v.toString());
        }
      });
    }
    isSeen = json['is_seen'];
    orderId = json['order_id'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['conversation_id'] = conversationId;
    data['sender_id'] = senderId;
    data['message'] = message;
    data['file_full_url'] = fileFullUrl;
    data['is_seen'] = isSeen;
    data['order_id'] = orderId;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Order {
  int? id;
  double? orderAmount;
  String? orderStatus;
  String? createdAt;
  int? detailsCount;
  Address? deliveryAddress;

  Order({this.id,
        this.orderAmount,
        this.orderStatus,
        this.createdAt,
        this.detailsCount,
        this.deliveryAddress});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderAmount = json['order_amount']?.toDouble();
    orderStatus = json['order_status'];
    createdAt = json['created_at'];
    detailsCount = json['details_count'];
    deliveryAddress = json['delivery_address'] != null ? Address.fromJson(json['delivery_address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_amount'] = orderAmount;
    data['order_status'] = orderStatus;
    data['created_at'] = createdAt;
    data['details_count'] = detailsCount;
    if (deliveryAddress != null) {
      data['delivery_address'] = deliveryAddress!.toJson();
    }
    return data;
  }
}

class Address {
  String? contactPersonName;
  String? contactPersonNumber;
  String? contactPersonEmail;
  String? addressType;
  String? address;
  String? floor;
  String? road;
  String? house;
  String? longitude;
  String? latitude;

  Address(
      {this.contactPersonName,
        this.contactPersonNumber,
        this.contactPersonEmail,
        this.addressType,
        this.address,
        this.floor,
        this.road,
        this.house,
        this.longitude,
        this.latitude});

  Address.fromJson(Map<String, dynamic> json) {
    contactPersonName = json['contact_person_name'];
    contactPersonNumber = json['contact_person_number'];
    contactPersonEmail = json['contact_person_email'];
    addressType = json['address_type'];
    address = json['address'];
    floor = json['floor'];
    road = json['road'];
    house = json['house'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contact_person_name'] = contactPersonName;
    data['contact_person_number'] = contactPersonNumber;
    data['contact_person_email'] = contactPersonEmail;
    data['address_type'] = addressType;
    data['address'] = address;
    data['floor'] = floor;
    data['road'] = road;
    data['house'] = house;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}

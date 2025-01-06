class BusinessPlanBody {
  String? businessPlan;
  String? storeId;
  String? packageId;
  String? payment;
  String? paymentGateway;
  String? callBack;
  String? paymentPlatform;
  String? type;

  BusinessPlanBody({
    this.businessPlan,
    this.storeId,
    this.packageId,
    this.payment,
    this.paymentGateway,
    this.callBack,
    this.paymentPlatform,
    this.type,
  });

  BusinessPlanBody.fromJson(Map<String, dynamic> json) {
    businessPlan = json['business_plan'];
    storeId = json['store_id'];
    packageId = json['package_id'];
    payment = json['payment'];
    paymentGateway = json['payment_gateway'];
    callBack = json['callback'];
    paymentPlatform = json['payment_platform'];
    type = json['type'];
  }

  Map<String, String?> toJson() {
    final Map<String, String?> data = <String, String?>{};
    data['business_plan'] = businessPlan;
    data['store_id'] = storeId;
    data['package_id'] = packageId;
    data['payment'] = payment;
    data['payment_gateway'] = paymentGateway;
    data['callback'] = callBack;
    data['payment_platform'] = paymentPlatform;
    data['type'] = type;
    return data;
  }
}

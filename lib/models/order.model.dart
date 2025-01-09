class Orders {
  final String productName;
  final String productDescription;
  final String productImage;
  final int quantity;
  final String price;
  final double total;
  final String shipmentAddress;
  final String paymentMethod;
  final String userName;
  final int orderNo;
  final String orderStatus;

  Orders({
    required this.productName,
    required this.productDescription,
    required this.productImage,
    required this.quantity,
    required this.price,
    required this.total,
    required this.shipmentAddress,
    required this.paymentMethod,
    required this.userName,
    required this.orderNo,
    required this.orderStatus,
  });

  factory Orders.fromMap(Map<String, dynamic> map) {
    return Orders(
      productName: map['productName'] as String,
      productDescription: map['productDescription'] as String,
      productImage: map['productImage'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as String,
      total: map['total'] as double,
      shipmentAddress: map['shipmentAddress'] as String,
      paymentMethod: map['paymentMethod'] as String,
      userName: map['userName'] as String,
      orderNo: map['orderNo'] as int,
      orderStatus: map['orderStatus'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'productDescription': productDescription,
      'productImage': productImage,
      'quantity': quantity,
      'price': price,
      'total': total,
      'shipmentAddress': shipmentAddress,
      'paymentMethod': paymentMethod,
      'userName': userName,
      'orderNo': orderNo,
      'orderStatus': orderStatus,
    };
  }
}

class CartItem {
  final int flowerId;
  final int quantity;

  CartItem({
    required this.flowerId,
    this.quantity = 1,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      flowerId: json['flower_id'],
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flower_id': flowerId,
      'quantity': quantity,
    };
  }
}

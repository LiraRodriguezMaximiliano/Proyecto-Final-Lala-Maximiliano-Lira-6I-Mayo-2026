class OrderItem {
  final String productName;
  final int quantity;
  final double price;

  OrderItem({required this.productName, required this.quantity, required this.price});

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 1,
      price: (map['price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}

class OrderModel {
  final String id;
  final String status; // 'procesando', 'en camino', 'entregado'
  final String date;
  final double total;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.status,
    required this.date,
    required this.total,
    required this.items,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String docId) {
    var list = map['items'] as List? ?? [];
    List<OrderItem> parsedItems = list.map((i) => OrderItem.fromMap(i)).toList();

    return OrderModel(
      id: docId,
      status: map['status'] ?? 'procesando',
      date: map['date'] ?? '',
      total: (map['total'] ?? 0.0).toDouble(),
      items: parsedItems,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'date': date,
      'total': total,
      'items': items.map((i) => i.toMap()).toList(),
    };
  }
}
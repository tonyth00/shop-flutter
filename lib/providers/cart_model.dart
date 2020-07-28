import 'package:flutter/foundation.dart';

class CartEntry {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartEntry({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });

  CartEntry.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        quantity = map['quantity'],
        price = map['price'];

  CartEntry copyWith({
    String id,
    String title,
    int quantity,
    double price,
  }) {
    return CartEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'quantity': quantity,
      'price': price,
    };
  }
}

class CartModel with ChangeNotifier {
  Map<String, CartEntry> _items = {};

  Map<String, CartEntry> get items {
    return {..._items};
  }

  int get itemCount {
    int count = 0;
    _items.forEach((key, item) {
      count += item.quantity;
    });
    return count;
  }

  double get totalPrice {
    double total = 0.0;
    _items.values.forEach((entry) {
      total += entry.price * entry.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingEntry) => existingEntry.copyWith(quantity: existingEntry.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartEntry(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingEntry) => CartEntry(
            id: existingEntry.id,
            title: existingEntry.title,
            price: existingEntry.price,
            quantity: existingEntry.quantity - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

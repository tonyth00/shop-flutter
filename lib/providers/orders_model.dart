import 'package:flutter/foundation.dart';
import './cart_model.dart';

class Order {
  final String id;
  final double amount;
  final List<CartEntry> entries;
  final DateTime dateTime;

  Order({
    @required this.id,
    @required this.amount,
    @required this.entries,
    @required this.dateTime,
  });
}

class OrdersModel with ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartEntry> entries, double total) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        entries: entries,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}

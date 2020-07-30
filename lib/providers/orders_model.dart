import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart_model.dart';
import '../environment.dart';

class Order {
  final String id;
  final List<CartEntry> entries;
  final DateTime dateTime;

  Order({
    @required this.id,
    @required this.entries,
    @required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime.toIso8601String(),
      'entries': entries.map((e) => e.toMap()).toList(),
    };
  }

  Order.fromMap(String id, Map<String, dynamic> map)
      : id = id,
        dateTime = DateTime.parse(map['dateTime']),
        entries =
            (map['entries'] as List<dynamic>).map((entry) => CartEntry.fromMap(entry)).toList();

  Order copyWith({String id, List<CartEntry> entries, DateTime dateTime}) {
    return Order(
      id: id ?? this.id,
      entries: entries ?? this.entries,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  double get totalPrice {
    double total = 0.0;
    entries.forEach((entry) {
      total += entry.price * entry.quantity;
    });
    return total;
  }
}

class OrdersModel with ChangeNotifier {
  List<Order> _orders;
  final String authToken;
  
  OrdersModel(this.authToken, this._orders);


  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartEntry> entries) async {
    final order = Order(
      id: null,
      entries: entries,
      dateTime: DateTime.now(),
    );

    final res = await http.post('$firebaseEndpoint/orders.json?auth=$authToken', body: json.encode(order.toMap()));
    final id = json.decode(res.body)['name'];
    _orders.insert(0, order.copyWith(id: id));
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final res = await http.get('$firebaseEndpoint/orders.json?auth=$authToken');
    final data = json.decode(res.body) as Map<String, dynamic>;

    final loadedOrders = <Order>[];
    if (data != null) {
      data.forEach((orderId, orderData) {
        loadedOrders.add(Order.fromMap(orderId, orderData));
      });
    }
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}

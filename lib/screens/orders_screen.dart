import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders_model.dart';
import '../widgets/order_list_tile.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<OrdersModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.orders.length,
        itemBuilder: (ctx, index) => OrderListTile(orders.orders[index]),
      ),
      drawer: AppDrawer(),
    );
  }
}

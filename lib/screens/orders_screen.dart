import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders_model.dart';
import '../widgets/order_list_tile.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    // final orders = Provider.of<OrdersModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(
        future: Provider.of<OrdersModel>(context, listen: false).fetchOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return Center(child: Text('An error occurred!'));
            }
            return Consumer<OrdersModel>(
              builder: (ctx, orders, child) => ListView.builder(
                itemCount: orders.orders.length,
                itemBuilder: (ctx, index) => OrderListTile(orders.orders[index]),
              ),
            );
          }
        },
      ),
      drawer: AppDrawer(),
    );
  }
}

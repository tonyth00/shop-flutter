import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_model.dart' show CartModel;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);
    final items = cart.items.values.toList();
    final productIds = cart.items.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalPrice}',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: Text('Order Now'),
                    onPressed: () {},
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.all(15),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) =>
                  CartItem(items[i].id, productIds[i], items[i].price, items[i].quantity, items[i].title),
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}

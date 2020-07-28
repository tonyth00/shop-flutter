import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_model.dart';
import '../widgets/cart_list_tile.dart';
import '../providers/orders_model.dart';

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
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).primaryTextTheme.headline6.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart, items: items),
                ],
              ),
            ),
            margin: EdgeInsets.all(15),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartListTile(
                  items[i].id, productIds[i], items[i].price, items[i].quantity, items[i].title),
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
    @required this.items,
  }) : super(key: key);

  final CartModel cart;
  final List<CartEntry> items;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('Order Now'),
      onPressed: widget.items.length == 0 || _isLoading
          ? null
          : () async {
              setState(() => _isLoading = true);
              await Provider.of<OrdersModel>(context, listen: false).addOrder(widget.items);
              setState(() => _isLoading = false);
              widget.cart.clear();
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}

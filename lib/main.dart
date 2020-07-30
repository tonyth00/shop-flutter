import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/products_overview_screen.dart';

import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/products_model.dart';
import './providers/cart_model.dart';
import './providers/orders_model.dart';
import './providers/auth_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthModel()),
        ChangeNotifierProxyProvider<AuthModel, ProductsModel>(
          create: (_) => ProductsModel(null, []),
          update: (ctx, auth, prevProductsModel) => ProductsModel(
            auth.token,
            prevProductsModel.items,
          ),
        ),
        ChangeNotifierProxyProvider<AuthModel, OrdersModel>(
          create: (_) => OrdersModel(null, []),
          update: (ctx, auth, prevOrdersModel) => OrdersModel(
            auth.token,
            prevOrdersModel.orders,
          ),
        ),
        ChangeNotifierProvider(create: (_) => CartModel()),
      ],
      child: Consumer<AuthModel>(
        builder: (ctx, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}

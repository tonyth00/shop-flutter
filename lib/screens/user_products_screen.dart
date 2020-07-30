import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_list_tile.dart';
import '../providers/products_model.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(context) {
    return Provider.of<ProductsModel>(context, listen: false).fetchProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Consumer<ProductsModel>(
                    builder: (ctx, model, child) => ListView.builder(
                      itemBuilder: (_, i) {
                        final product = model.items[i];
                        return UserProductListTile(product.id, product.title, product.imageUrl);
                      },
                      itemCount: model.items.length,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

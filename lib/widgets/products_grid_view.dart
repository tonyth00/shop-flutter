import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_model.dart';
import 'product_tile.dart';

class ProductsGridView extends StatelessWidget {
  final bool showFavs;

  ProductsGridView(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsModel>(context);
    final products = showFavs ? productsProvider.favoriteItems : productsProvider.items;

    return products.isEmpty
        ? Center(child: Text('No products available'))
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductTile(),
            ),
          );
  }
}

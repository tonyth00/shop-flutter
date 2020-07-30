import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';
import './product_model.dart';
import '../environment.dart';

class ProductsModel with ChangeNotifier {
  final String authToken;
  final String userId;

  ProductsModel(this.authToken, this.userId, this._items);

  List<ProductModel> _items = [];

  List<ProductModel> get items {
    return [..._items];
  }

  List<ProductModel> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  ProductModel findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }

  Future<void> fetchProducts({filterByUser = false}) async {
    final filterString = filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    var res = await http.get('$firebaseEndpoint/products.json?auth=$authToken$filterString');
    final data = json.decode(res.body) as Map<String, dynamic>;
    final loadedProducts = <ProductModel>[];

    if (data == null) {
      notifyListeners();
      return;
    }

    res = await http.get('$firebaseEndpoint/userFavorites/$userId.json?auth=$authToken');
    final favoriteData = json.decode(res.body);

    data.forEach((id, value) {
      loadedProducts.add(
        ProductModel.fromMap(
          id,
          {
            ...value,
            'isFavorite': favoriteData == null ? false : (favoriteData[id] ?? false),
          },
        ),
      );
    });

    _items = loadedProducts;
    notifyListeners();
  }

  Future<void> addProduct(ProductModel product) async {
    final url = '$firebaseEndpoint/products.json?auth=$authToken';
    final response = await http.post(
      url,
      body: json.encode({
        ...product.toMap(),
        'creatorId': userId,
      }),
    );
    final id = json.decode(response.body)['name'];
    _items.add(product.copyWith(id: id));
    notifyListeners();
  }

  Future<void> updateProduct(String id, ProductModel newProduct) async {
    final prodIndex = _items.indexWhere((product) => product.id == id);
    if (prodIndex >= 0) {
      await http.patch(
        '$firebaseEndpoint/products/$id.json?auth=$authToken',
        body: json.encode(newProduct.toMap()),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('Cannot find product');
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((product) => product.id == id);
    final removedProduct = _items.removeAt(index);
    notifyListeners();
    try {
      final res = await http.delete('$firebaseEndpoint/products/$id.json?auth=$authToken');
      if (res.statusCode >= 400) {
        throw HttpException('Could not delete product.');
      }
    } catch (err) {
      _items.insert(index, removedProduct);
      notifyListeners();
      throw HttpException(err);
    }
  }
}

// ProductModel(
//   id: 'p1',
//   title: 'Red Shirt',
//   description: 'A red shirt - it is pretty red!',
//   price: 29.99,
//   imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
// ),
// ProductModel(
//   id: 'p2',
//   title: 'Trousers',
//   description: 'A nice pair of trousers.',
//   price: 59.99,
//   imageUrl:
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
// ),
// ProductModel(
//   id: 'p3',
//   title: 'Yellow Scarf',
//   description: 'Warm and cozy - exactly what you need for the winter.',
//   price: 19.99,
//   imageUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
// ),
// ProductModel(
//   id: 'p4',
//   title: 'A Pan',
//   description: 'Prepare any meal you want.',
//   price: 49.99,
//   imageUrl:
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
// ),

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class ProductModel with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductModel({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  ProductModel copyWith(
      {String id,
      String title,
      String description,
      double price,
      String imageUrl,
      bool isFavorite}) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  ProductModel.fromMap(String id, Map<String, dynamic> map)
      : id = id,
        title = map['title'],
        description = map['description'],
        price = map['price'],
        imageUrl = map['imageUrl'],
        isFavorite = map['isFavorite'];

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'isFavorite': isFavorite,
    };
  }

  void toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final res = await http.patch(
        'https://storage-253004.firebaseio.com/products/$id.json',
        body: json.encode({'isFavorite': isFavorite}),
      );

      if (res.statusCode >= 400) {
        throw HttpException('Could not update isFavorite');
      }
    } catch (_) {
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}

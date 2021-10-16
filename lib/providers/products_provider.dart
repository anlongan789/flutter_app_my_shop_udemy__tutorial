// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_app_my_shop/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Yellow Scarf',
      description: 'Warm and cozy',
      price: 19.99,
      imgUrl:
          "https://thumbs.dreamstime.com/b/yellow-knitted-scarf-18952858.jpg",
    ),
    Product(
      id: 'p2',
      title: 'Blue T-Shirt',
      description: 'Simple and comfortable',
      price: 9.99,
      imgUrl:
          "https://5.imimg.com/data5/YJ/BO/MY-10973479/mens-designer-casual-shirt-500x500.jpg",
    ),
    Product(
      id: 'p3',
      title: 'Blue Jeans',
      description: 'Slim jeans',
      price: 15.99,
      imgUrl:
          "https://storage.googleapis.com/cdn.nhanh.vn/store/2071/ps/20210121/bj041_xanh_da_tri_1_50857999998_o.jpg",
    ),
    Product(
      id: 'p4',
      title: 'Fedora Hat',
      description: 'Classic blue hat',
      price: 7.99,
      imgUrl:
          "https://img.hatshopping.com/Manuel-Fedora-Hat-by-Mayser.44100_pf192.jpg",
    ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  List<Product> get favoviteItems {
    return _items.where((prodItems) => prodItems.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
        id: DateTime.now().toString(),
        title: product.title,
        description: product.description,
        price: product.price,
        imgUrl: product.imgUrl);
    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}

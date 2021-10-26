// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_app_my_shop/models/http_exception.dart';
import 'package:flutter_app_my_shop/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy',
    //   price: 19.99,
    //   imgUrl:
    //       "https://thumbs.dreamstime.com/b/yellow-knitted-scarf-18952858.jpg",
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Blue T-Shirt',
    //   description: 'Simple and comfortable',
    //   price: 9.99,
    //   imgUrl:
    //       "https://5.imimg.com/data5/YJ/BO/MY-10973479/mens-designer-casual-shirt-500x500.jpg",
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Blue Jeans',
    //   description: 'Slim jeans',
    //   price: 15.99,
    //   imgUrl:
    //       "https://storage.googleapis.com/cdn.nhanh.vn/store/2071/ps/20210121/bj041_xanh_da_tri_1_50857999998_o.jpg",
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'Fedora Hat',
    //   description: 'Classic blue hat',
    //   price: 7.99,
    //   imgUrl:
    //       "https://img.hatshopping.com/Manuel-Fedora-Hat-by-Mayser.44100_pf192.jpg",
    // ),
  ];

  // var _showFavoritesOnly = false;

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        "flutter-update-b97fd-default-rtdb.firebaseio.com", "/products.json");
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((proId, prodData) {
        loadedProducts.add(
          Product(
              id: proId,
              title: prodData["title"],
              description: prodData["description"],
              price: prodData["price"],
              imgUrl: prodData["imgUrl"],
              isFavorite: prodData["isFavorite"]),
        );
      });
      _items = loadedProducts;
      notifyListeners();
      // print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  List<Product> get favoviteItems {
    return _items.where((prodItems) => prodItems.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> addProduct(Product product) async {
    // add async => all the method on which you use will return a future
    final url = Uri.https(
        "flutter-update-b97fd-default-rtdb.firebaseio.com", "/products.json");
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imgUrl': product.imgUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imgUrl: product.imgUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
    // if call catchError at this point, the then clause will execute after catching the error
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.https("flutter-update-b97fd-default-rtdb.firebaseio.com",
          "/products/$id.json");
      await http.patch(
        url,
        body: json.encode(
          {
            "title": newProduct.title,
            "description": newProduct.description,
            "price": newProduct.price,
            "imgUrl": newProduct.imgUrl,
          },
        ),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https("flutter-update-b97fd-default-rtdb.firebaseio.com",
        "/products/$id.json");
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    final response = await http.delete(url);
    _items.removeAt(existingProductIndex);
    notifyListeners();
    // delete will throw 405 error when an error occured
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product");
    }
    existingProduct = null;
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_app_my_shop/providers/cart_provider.dart';
import 'package:flutter_app_my_shop/providers/orders.dart';
import 'package:flutter_app_my_shop/providers/products_provider.dart';
import 'package:flutter_app_my_shop/screens/cart_screen.dart';
import 'package:flutter_app_my_shop/screens/product_detail_screen.dart';
import 'package:flutter_app_my_shop/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';
import './screens/orders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        )
      ],
      // create: (ctx) =>
      // value:
      //     ProductsProvider(), // provider version 4.0.0 use create instead of buider
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
        },
      ),
    );
  }
}

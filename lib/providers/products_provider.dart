

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:products_app/models/product.dart';
import 'package:http/http.dart' as http;



class ProductsProvider extends ChangeNotifier{

  final String _baseUrl = 'flutter-app-edb45-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  bool isLoading = true;

 

  ProductsProvider(){
    loadProducts();
  }

  Future loadProducts() async{

    isLoading = true;
    notifyListeners();
    final url = Uri.https(_baseUrl,'Products.json');
    final resp = await http.get(url);

    final Map<String,dynamic> productsMap = jsonDecode(resp.body);


    productsMap.forEach((key, value) {

      final temProduct = Product.fromMap(value);
      temProduct.id = key;
      products.add(temProduct);
    });


    isLoading = false;
    notifyListeners();
}
 

}
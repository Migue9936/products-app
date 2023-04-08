

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:products_app/models/product.dart';
import 'package:http/http.dart' as http;



class ProductsProvider extends ChangeNotifier{

  final String _baseUrl = 'flutter-app-edb45-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
  
  bool isLoading = true;
  bool isSaving = false;
 

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
 
 Future saveOrCreateProduct(Product product)async{
  isSaving = true;
  notifyListeners();
  
  if (product.id == null) {
    //Created a new product
  }else{
    //Update exist product
    await updateProduct(product);

  }
  isSaving = false;
  notifyListeners();
 }

  Future updateProduct(Product product) async {
  final url = Uri.https(_baseUrl, 'Products/${product.id}.json');
  final resp = await http.put(url, body: product.toJson());
  final decodeData = resp.body;

  // Se busca el producto que cpincida con el producto que esté en la lista product[]
  final index = products.indexWhere((element) => element.id == product.id);
  products[index] = product;

  return product.id;
}



}
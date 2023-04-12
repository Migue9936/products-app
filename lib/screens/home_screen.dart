import 'package:flutter/material.dart';
import 'package:products_app/providers/providers.dart';

import 'package:products_app/models/models.dart';
import 'package:products_app/screens/screens.dart';
import 'package:products_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {

  final productProvider = Provider.of<ProductsProvider>(context);
  final numProducts = productProvider.products.length;
  final products = productProvider.products;
  final authProvider = Provider.of<AuthProvider>(context);

    if(productProvider.isLoading) return const LoadingScreen();

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              authProvider.logOut();
              Navigator.pushReplacementNamed(context, 'login');
            }, 
            icon: const Icon(Icons.logout_outlined)
          )
        ],
      ),
      body: ListView.builder(
        itemCount: numProducts,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            productProvider.selectedProduct = products[index].copy();
            Navigator.pushNamed(context, 'product');
          }, 
          child:  ProductCard(product: products[index],)
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productProvider.selectedProduct  = Product(available: true, name: '', price: 0);
          Navigator.pushNamed(context, 'product');
        },
        child: const Icon(Icons.add_to_queue_rounded),
      ),
    );
    
  }
}
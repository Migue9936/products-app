import 'package:flutter/material.dart';
import 'package:products_app/providers/providers.dart';
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

    if(productProvider.isLoading) return const LoadingScreen();

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: ListView.builder(
        itemCount: numProducts,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => Navigator.pushNamed(context, 'product'),
          child:  ProductCard(product: products[index],)
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_to_queue_rounded),
      ),
    );
    
  }
}
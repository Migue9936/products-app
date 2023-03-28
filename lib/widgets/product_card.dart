import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30,bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _productCardDecoration(),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children:  [
            _BackgroundImage(),
            _ProductDescription()
          ],
        ),
      ),
    );
  }







  BoxDecoration _productCardDecoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 7),
            blurRadius: 10
          )
        ],
        color: Colors.white,
      );
  }
}

class _ProductDescription extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      color: Colors.indigoAccent,
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 400,
        child: const FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'), 
          image: NetworkImage('https://via.placeholder.com/400x300/f6f6f6'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
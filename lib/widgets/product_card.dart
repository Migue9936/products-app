import 'package:flutter/material.dart';
import 'package:products_app/models/models.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  const ProductCard({super.key, required this.product});

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
            _BackgroundImage(picture: product.picture),
            _ProductDescription(id: product.id, name: product.name,),
             Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(price: product.price),

            ),
             if(!product.available) 
             Positioned(
              top: 0,
              left: 0,
              child: _NotAvaible(available: product.available,),

            ),
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

class _NotAvaible extends StatelessWidget {

  final bool available;

  const _NotAvaible({required this.available}); 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration:  BoxDecoration(
        color: available == false ? Colors.yellow[800] : Colors.greenAccent,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(25)),

      ),
      child:  const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child:  Text('Not Avaible',style: TextStyle(color: Colors.white,fontSize: 20)),
        ),
      ),
    );
  }
}

class _PriceTag extends StatelessWidget {

  final double price;

  const _PriceTag({required this.price});@override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 70,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.only(topRight: Radius.circular(21),bottomLeft: Radius.circular(25)),

      ),
      child:  FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('\$${price.toString()}',style: const TextStyle(color: Colors.white,fontSize: 20)),
        ),
      ),
    );
  }
}

class _BackgroundImage extends StatelessWidget {
  
   final String? picture;


  const _BackgroundImage({this.picture});


  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 400,
        child: picture == null
        ? const Image(image: AssetImage('assets/no-image.png'),fit: BoxFit.cover,) 
        :FadeInImage(
          placeholder: const AssetImage('assets/jar-loading.gif'), 
          image: NetworkImage(picture!),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
class _ProductDescription extends StatelessWidget {


  final String name;
  final String? id;

  const _ProductDescription({super.key, required this.name, this.id});

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
        width: double.infinity,
        height: 60,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(name,
            style: const TextStyle(fontSize:20 ,color: Colors.white,fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            ),
            Text(id.toString(),
            style: const TextStyle(fontSize:15 ,color: Colors.white),
            ),
          ]
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return const BoxDecoration(
        color: Colors.indigoAccent,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(21),topRight: Radius.circular(25))
      );
  }
}

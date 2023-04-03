import 'package:flutter/material.dart';
import 'package:products_app/ui/input_decorations.dart';
import 'package:products_app/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
   
  const ProductScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children:  [
                const ProductImage(),
                Positioned(
                  top: 60,
                  left:4,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context), 
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,size: 40,)
                  )
                ),
                Positioned(
                  top: 60,
                  right:20,
                  child: IconButton(
                    onPressed: () {
                    }, 
                    icon: const Icon(Icons.camera_alt_outlined,color: Colors.white,size: 40,)
                  )
                ),
              ],
            ),
            _ProductForm(),

            const SizedBox(height: 100)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(

        child: const Icon(Icons.save_outlined),
        onPressed: () {
          
        },
      ),
    );
    
  }
}

class _ProductForm extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Product Name', 
                  labelText: 'Name'
                ),

              ),

              const SizedBox(height: 30),
              
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Price'
                ),
              ),
              const SizedBox(height: 30),

              SwitchListTile.adaptive(
                value: true,
                title: const Text('Available'), 
                activeColor: Colors.indigoAccent,
                onChanged: (value) {
                },
              ),

              const SizedBox(height: 30)
            ],
          ) 
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return  BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: const Offset(0,5),
          blurRadius: 5
        )
      ]
    );
  }
}
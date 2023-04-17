import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:products_app/providers/providers.dart';
import 'package:products_app/ui/input_decorations.dart';
import 'package:products_app/widgets/widgets.dart';


class ProductScreen extends StatelessWidget {
   
  const ProductScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final productProvider = Provider.of<ProductsProvider>(context);

    return  ChangeNotifierProvider(
      create: (context) => ProductFormProvider(productProvider.selectedProduct),
      child: _ProductScreenBody(productProvider: productProvider),
    );
    
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    required this.productProvider,
  });

  final ProductsProvider productProvider;

  @override
  Widget build(BuildContext context) {

    final productForm = Provider.of<ProductFormProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children:  [
                 ProductImage(url: productProvider.selectedProduct.picture),
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
                    onPressed: ()async{

                      final picker = ImagePicker();
                      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery,imageQuality: 100);
                      if (pickedFile == null) {
                      }

                      productProvider.updateSelectedProductImage(pickedFile!.path);

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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(

        onPressed: productProvider.isSaving
        ? null
        :() async {
            if (!productForm.isValidForm()) return;

            final String? imageUrl = await productProvider.uploadImage();

            if (imageUrl !=null) productForm.product.picture = imageUrl;

            await productProvider.saveOrCreateProduct(productForm.product);
        },
        child: productProvider.isSaving
        ? const CircularProgressIndicator(color: Colors.white,)
        : const Icon(Icons.save_alt_outlined),

      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
 
  final productForm = Provider.of<ProductFormProvider>(context);
  final product = productForm.product; 
 
 
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: productForm.formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name Required';
                  }
                  return null;
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Product Name', 
                  labelText: 'Name'
                ),

              ),

              const SizedBox(height: 30),
              
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  if (double.tryParse(value)==null) {
                    product.price = 0;
                  }else{
                    product.price = double.parse(value);
                  }

                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: '\$150', 
                  labelText: 'Price'
                ),
              ),
              const SizedBox(height: 30),

              SwitchListTile.adaptive(
                value: product.available,
                title: const Text('Available'), 
                activeColor: Colors.indigoAccent,
                onChanged:  productForm.updateAvailability,
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


import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:products_app/models/product.dart';
import 'package:http/http.dart' as http;



class ProductsProvider extends ChangeNotifier{

  final String _baseUrl = 'flutter-app-edb45-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
  File? newPictureFile;
  
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
    await createProduct(product);

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
    // ignore: unused_local_variable
    final decodeData = resp.body;

    // Se busca el producto que cpincida con el producto que esté en la lista product[]
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id;
  }
  Future createProduct(Product product) async {
    final url = Uri.https(_baseUrl, 'Products.json');
    final resp = await http.post(url, body: product.toJson());
    final decodeData = jsonDecode(resp.body) ;
    
    product.id = decodeData['name']; 
    products.add(product);

     return product.id;
  }

  void updateSelectedProductImage(String path){
    
    selectedProduct.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    // Se verifica si la imagen seleccionada es nula
    if (newPictureFile == null) return null;

    // Se establece la variable isSaving en verdadero para indicar que se está guardando la imagen
    isSaving = true;

    // Se notifica a los oyentes que se está guardando la imagen
    notifyListeners();

    // Se define la URL del servicio de almacenamiento en la nube (Cloudinary) donde se cargará la imagen
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dmzqdqszl/image/upload?upload_preset=u1hyyrzc');

    // Se crea una solicitud HTTP multipart para cargar la imagen en Cloudinary
    final imageUploadRequest = http.MultipartRequest('Post', url);

    // Se crea un archivo multipart a partir del archivo de imagen seleccionado
    final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

    // Se agrega el archivo a la solicitud HTTP multipart
    imageUploadRequest.files.add(file);

    // Se envía la solicitud HTTP multipart a la URL definida anteriormente y se obtiene la respuesta como un objeto Stream
    final streamResponse = await imageUploadRequest.send();

    // Se convierte el objeto Stream de la respuesta en un objeto Response de la biblioteca http
    final resp = await http.Response.fromStream(streamResponse);

    // Se comprueba si la respuesta HTTP tiene un código de estado que indica que la carga de la imagen ha fallado
    if (resp.statusCode != 200 && resp.statusCode!=201) {
      return null;
    }

    // Se establece la variable que contiene la imagen cargada en nulo para que no haya conflictos si se intenta cargar una imagen nuevamente
    newPictureFile = null;

    // Se decodifica la respuesta JSON del servicio Cloudinary
    final decodeData = json.decode(resp.body);

    // Se devuelve la URL segura de la imagen (secure_url) de la respuesta JSON decodificada
    return decodeData['secure_url'];
  }



}
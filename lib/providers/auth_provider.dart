import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;



class AuthProvider extends ChangeNotifier{

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyAyIEco5YIsUcT1HU9urKgC6s900ChIrAU';
  final storage = const FlutterSecureStorage();

  Future <String?>createUser(String email, String password) async{

    // Crear un mapa con las credenciales de autenticación del usuario
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    
    // Crear la URL de la solicitud HTTP para crear un nuevo usuario en Firebase Authentication
    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    // Realizar una solicitud HTTP POST a la URL con las credenciales de autenticación del usuario
    final resp = await http.post(url, body: json.encode(authData));

    // Decodificar la respuesta JSON recibida de la solicitud HTTP
    final Map<String, dynamic> decodedResp = jsonDecode(resp.body);

    // Imprimir la respuesta decodificada en la consola para fines de depuración
    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    }else{
      return decodedResp['error']['message'];
    }


  }

  Future <String?>login(String email, String password) async{

    // Crear un mapa con las credenciales de autenticación del usuario
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };
    
    // Crear la URL de la solicitud HTTP para crear un nuevo usuario en Firebase Authentication
    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    // Realizar una solicitud HTTP POST a la URL con las credenciales de autenticación del usuario
    final resp = await http.post(url, body: json.encode(authData));

    // Decodificar la respuesta JSON recibida de la solicitud HTTP
    final Map<String, dynamic> decodedResp = jsonDecode(resp.body);

    // Imprimir la respuesta decodificada en la consola para fines de depuración
    if (decodedResp.containsKey('idToken')) {
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    }else{
      return decodedResp['error']['message'];
    }


  }

  Future logOut() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken()async{
 
    return  await storage.read(key: 'token') ?? '';
    

  }


}
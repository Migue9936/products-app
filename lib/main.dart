import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:products_app/providers/providers.dart';
import 'package:products_app/screens/screens.dart';

void main() => runApp( const AppState());

class AppState extends StatelessWidget {
  const AppState({super.key});

  

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login':(_) => const LoginScreen(),
        'register':(_) => const RegisterScreen(),
        'home':(_) => const HomeScreen(),
        'product':(_) => const ProductScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(color: Colors.indigoAccent),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.indigoAccent)
      ),
    );
  }
}
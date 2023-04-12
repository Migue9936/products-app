import 'package:flutter/material.dart';

class NotificationsProvider{

  static GlobalKey<ScaffoldMessengerState> messegerKey = GlobalKey<ScaffoldMessengerState>();


  static showSnackbar(String message){

    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Center(child: Text(message,style: const TextStyle(color: Colors.white,fontSize: 20)))
    );

    messegerKey.currentState!.showSnackBar(snackBar);

  }



}
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:recyclo/authentication/handler.dart';
import 'package:recyclo/models/firebase_user.dart';
import 'package:recyclo/screens/basic/home.dart';


class Wrapper extends StatelessWidget{
  
  @override
  Widget build(BuildContext context) {
    
    final user =  Provider.of<FirebaseUser?>(context);
    
     if(user == null)
     {
       return Handler();
     }else
     {
       return  Home();
     }

  }
} 
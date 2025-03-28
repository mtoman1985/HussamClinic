import 'package:flutter/material.dart';

class CustomTheme {


  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: Colors.pinkAccent,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Montserrat',
        textTheme: //text styling
        const TextTheme(
          headline1: TextStyle(fontSize: 72.0,
              fontWeight: FontWeight.bold,
              color:Colors.white),
          headline6: TextStyle(fontSize: 30.0, color:Colors.pinkAccent,),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind',  color:Colors.pinkAccent,),
          bodyText1: TextStyle(fontSize: 16,
              fontWeight: FontWeight.bold,
              color:Colors.white),
         // bodyLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic, color:Colors.pinkAccent,),
        ),

        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.pink,
        )
    );
  }
}
import 'package:flutter/material.dart';
Widget technicalErrorWidget() {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
          image: AssetImage('assets/newerror.png',),
          height: 120,
        ),
        SizedBox(height: 15,),
        Text('Error!', style: TextStyle(color: Color(0xffC03744), fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.symmetric( horizontal: 30.0),
          child: Text('We are facing some Technical Errors at the moment. Please wait a while.', style: TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
        )
      ],
    ),
  );
}
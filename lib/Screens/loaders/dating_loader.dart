import 'package:flutter/material.dart';

class DatingLoader {
  static Widget simpleLoader() {
    return const Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image(
              image: AssetImage('assets/dating_loader.gif'),
              height: 320,
              width: 320,
            ),
            SizedBox(
              height: 10,
            ),
            Text('Dive into dating', style: TextStyle(color: Color(0xffAF2C80), fontSize: 14, fontWeight: FontWeight.w600),),
            Spacer(),
          ],
        )
    );
  }
}
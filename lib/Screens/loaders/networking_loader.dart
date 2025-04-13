import 'package:flutter/material.dart';

class NetworkingLoader {
  static Widget simpleLoader() {
    return const Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image(
              image: AssetImage('assets/animation-ezgif.com-video-to-gif-converter.gif'),
              height: 320,
              width: 320,
            ),
            SizedBox(
              height: 10,
            ),
            Text('Welcome to Networking', style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w600),),
            Spacer(),
          ],
        )
    );
  }
}
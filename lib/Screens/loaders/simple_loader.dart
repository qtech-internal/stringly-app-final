import 'package:flutter/material.dart';

class SimpleLoaderClass {
  static Widget simpleLoader({required String text}) {
    return Expanded(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        const Image(
          image: AssetImage('assets/loading_animation.gif'),
          height: 100,
          width: 100,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color(0xff26288B), fontWeight: FontWeight.w600),
        ),
        const Spacer(),
      ],
    ));
  }
}

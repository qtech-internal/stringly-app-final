import 'package:flutter/material.dart';

class MessageScreenLoader {
  static Widget simpleLoader({required String text}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Image(
            image: AssetImage('assets/loader_s.gif'),
            height: 70,
            width: 70,
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
      ),
    );
  }
}

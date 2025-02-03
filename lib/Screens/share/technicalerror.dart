import 'package:flutter/material.dart';


class Technicalerror extends StatelessWidget {
  const Technicalerror({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: Colors.white,
      child: Container(height: 370,
        width: 300,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 120,),
              Image.asset(
                'assets/error.jpg',

              ),
              const SizedBox(height: 30),
              const Text(
                ' Error!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                ' We are facing some Technical Errors at the moment. Please wait a while.',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

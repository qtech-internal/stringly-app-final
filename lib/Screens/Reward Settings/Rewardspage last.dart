import 'package:flutter/material.dart';

import '../SubscriptionSettings/SubscriptionandPaymentComponent20.1.dart';
import 'RewardSettings1.dart';
import 'RewardsPage.dart';

class RewardsPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child:const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title:const Text(
          'Rewards',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Points display section
              const SizedBox(height: 30,),
              Center(
                child: Container(
                  height: 40,
                  width: 300,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(

                    gradient:const LinearGradient(
                      colors: [
                        Color(0xFFD83694), // First color for the gradient
                        Colors.blue, // Second color for the gradient
                      ],
                      stops: [
                        0.25,
                        1.0,
                      ],

                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child:const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
                    crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
                    children: [
                      Image(
                        height: 20,
                        image: AssetImage('assets/reward.png'),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '10 points',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )


              ),
              const SizedBox(height: 32),
              // Dating section
              const  Text(
                'Dating',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color:  Color(0xFFAF2C80),
                ),
              ),
              const  SizedBox(height: 8),
              const  Text(
                'Make 3 meaningful connections today and earn 20 reward points!',
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
              ),
              const  SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 280,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.purpleAccent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RewardPointsSettings()));
                    },
                    child:Center(
                      child: const Text(
                        'Earn now',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Networking section
              const Text(
                'Networking',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5355D0),
                ),
              ),
              const SizedBox(height: 8),
              const  Text(
                'Expand your professional network with 5 new contacts today and earn 30 reward points',
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
              ),
              const  SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 280,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RewardPointsScreen()));
                    },
                    child:const Text(
                      'Earn now',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                'Redeem Subscription',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black ,
                ),
              ),
              const SizedBox(height: 8),
              const  Text(
                'Expand your professional network with 5 new contacts today and earn 30 reward points',
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
              ),
              const  SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 280,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      shadowColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>RewardPointsScreen()));
                    },
                    child:const Text(
                      'Redeem',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40,)
            ],
          ),
        ),
      ),
    );
  }
}

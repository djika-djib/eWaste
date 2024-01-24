import 'package:ewaste/screens/home_screen.dart';
import 'package:ewaste/screens/recyclingCenters/recycling_center_screen.dart';
import 'package:ewaste/screens/register_screen.dart';
import 'package:ewaste/screens/residents/resident_screen.dart';
import 'package:ewaste/screens/wasteCollectors/waste_collector_screen.dart';
import 'package:ewaste/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ewaste/provider/auth_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/welcome-img.png",
                ),
                const SizedBox(height: 20),
                const Text(
                  "Let's get started",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "This is the time to start making change for a better life in a sustainable environment.",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // custom button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                      onPressed: () async {
                        // Check if user is signed in
                        if (ap.isSignedIn == true) {
                          await ap.getDataFromSP().whenComplete(() {
                            // Check the type of user
                            if (ap.userModel.userRole == 'Resident') {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ResidentScreen()),
                                  (route) => false);
                            } else if (ap.userModel.userRole ==
                                'Waste Collector') {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WasteCollectorScreen()),
                                  (route) => false);
                            } else if (ap.userModel.userRole ==
                                'Recycling Center') {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RecyclingCenterScreen()),
                                  (route) => false);
                            } else {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                  (route) => false);
                            }
                            // End checking the type of user
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: ((context) => const RegisterScreen()),
                            ),
                          );
                        }
                        // End checking the sign in status
                      },
                      text: "Get started"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

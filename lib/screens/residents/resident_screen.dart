import 'package:ewaste/screens/residents/post_object_screen.dart';
import 'package:ewaste/screens/residents/report_screen.dart';
import 'package:ewaste/screens/residents/resident_maps_screen.dart';
import 'package:ewaste/screens/welcome_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ewaste/provider/auth_provider.dart';

class ResidentScreen extends StatefulWidget {
  const ResidentScreen({super.key});

  @override
  State<ResidentScreen> createState() => _ResidentScreenState();
}

class _ResidentScreenState extends State<ResidentScreen> {
  // int _currentIndex = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.teal,
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            // setState(() {
            //   _currentIndex = index;
            // });
          },
          children: [
            WillPopScope(
              onWillPop: () async {
                if (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                  return false;
                }
                return true; // No previous route, let the back button exit the app.
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome,',
                              style: TextStyle(
                                color: Color.fromARGB(228, 255, 255, 255),
                                fontSize: 18.0,
                              ),
                            ),
                            Text(
                              ap.userModel.name,
                              style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        // const SizedBox(
                        //   width: 205,
                        // ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Show a bottom sheet with a "Logout" button
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height: 100, // Adjust the height as needed
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ElevatedButton(
                                        onPressed: () {
                                          ap.userSignOut().then(
                                                (value) => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const WelcomeScreen(),
                                                  ),
                                                ),
                                              );
                                        },
                                        child: const Text('Logout'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.menu, // Replace with your desired menu icon
                            color: Colors.white,
                            size: 30.0, // Adjust the size as needed
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 70.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 50,
                        mainAxisSpacing: 60,
                        children: [
                          // const Text('Our Services'),
                          // const SizedBox(height: 8.0),
                          itemDashboard(
                            'Request for pick up',
                            Icons.cleaning_services_rounded,
                            Colors.green,
                            () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ResidentMapsScreen()),
                                  (route) => false);
                            },
                          ),

                          itemDashboard(
                            'Report Improper Disposal',
                            CupertinoIcons.photo_camera,
                            Colors.red,
                            () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ReportScreen()),
                                  (route) => false);
                            },
                          ),
                          itemDashboard(
                            'Post Recycling Objects',
                            CupertinoIcons.arrow_3_trianglepath,
                            Colors.green,
                            () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const PostRecyclingObjectScreen()),
                                  (route) => false);
                            },
                          ),
                          itemDashboard(
                            'Separation Guidelines',
                            CupertinoIcons.book_solid,
                            Colors.teal,
                            () {
                              // Navigator.pushAndRemoveUntil(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const RequestPickUpScreen()),
                              //     (route) => false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const HistoryScreen(),
            // const UserInformationScreen(),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: (newIndex) {
      //     setState(() {
      //       _pageController.jumpToPage(newIndex);
      //     });
      //   },
      //   items: const [
      //     BottomNavigationBarItem(label: 'Home', icon: Icon(Icons.home)),
      //     BottomNavigationBarItem(label: 'History', icon: Icon(Icons.history)),
      //     BottomNavigationBarItem(label: 'Profile', icon: Icon(Icons.person)),
      //   ],
      // ),
      // bottom navbar
    );
  }

  itemDashboard(String title, IconData iconData, Color background,
          Function() onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(color: background, shape: BoxShape.circle),
                  child: Icon(iconData, color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      );
}

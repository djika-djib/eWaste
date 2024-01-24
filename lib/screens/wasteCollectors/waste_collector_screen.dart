import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ewaste/screens/wasteCollectors/map_route_screen.dart';
import 'package:ewaste/screens/welcome_screen.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ewaste/provider/auth_provider.dart';

class WasteCollectorScreen extends StatefulWidget {
  const WasteCollectorScreen({super.key});

  @override
  State<WasteCollectorScreen> createState() => _WasteCollectorScreenState();
}

class _WasteCollectorScreenState extends State<WasteCollectorScreen> {
  late PageController _pageController;
  final CollectionReference _pickupRequests =
      FirebaseFirestore.instance.collection("pickupRequests");
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
                          horizontal: 20.0, vertical: 20.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: StreamBuilder(
                        stream: _pickupRequests.snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          if (streamSnapshot.hasData) {
                            return ListView.builder(
                                itemCount: streamSnapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final DocumentSnapshot documentSnapshot =
                                      streamSnapshot.data!.docs[index];

                                  final username =
                                      documentSnapshot['username'] ?? 'N/A';
                                  final location = documentSnapshot['location']
                                          ?.toString() ??
                                      'N/A';
                                  // final area =
                                  //     documentSnapshot['Area'] ?? 'N/A';
                                  final residentPhoneNo =
                                      documentSnapshot['ResidentPhoneNumber']
                                              ?.toString() ??
                                          'N/A';

                                  final price =
                                      documentSnapshot['price'] ?? 'N/A';

                                  final wasteType =
                                      documentSnapshot['wasteType'] ?? 'N/A';

                                  final nbrOfBags =
                                      documentSnapshot['numberOfBags'] ?? 'N/A';

                                  return Card(
                                    color: const Color.fromARGB(
                                        255, 228, 226, 226),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: ListTile(
                                        title: Text(
                                          username,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Location: $location',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Phone: $residentPhoneNo',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                        trailing: Text(
                                          'GHC$price',
                                          style: const TextStyle(
                                              // fontSize: 16,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        leading:
                                            const Icon(Icons.cleaning_services),
                                        onTap: () {
                                          // Show bottom sheet with more details on the request
                                          showModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    20.0)),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ListTile(
                                                        title: Text(
                                                          "Waste Type: $username",
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black87),
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Location: $location',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                              'Phone: $residentPhoneNo',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                              'Phone: $wasteType',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                height: 5),
                                                            Text(
                                                              'Phone: $nbrOfBags',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 16),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => MapRouteScreen(
                                                                          residentLocation:
                                                                              location)),
                                                                  (route) =>
                                                                      false);
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .green),
                                                            child: const Text(
                                                                'Accept'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              // Handle reject logic
                                                              // You can update the status in the database here
                                                            },
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .red),
                                                            child: const Text(
                                                                'Reject'),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                      ),
                                    ),
                                  );
                                });
                          }
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.teal,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

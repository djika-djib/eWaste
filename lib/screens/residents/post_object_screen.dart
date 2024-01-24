import 'dart:io';
import 'package:ewaste/screens/residents/resident_screen.dart';
import 'package:ewaste/utils/utils.dart';
import 'package:ewaste/widgets/custom_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ewaste/provider/auth_provider.dart';
// import 'package:ewaste/model/user_model.dart';

const List<String> objectTypeList = [
  "Plastic Sachets",
  "Plastic Bottles",
  "Cans"
];

class PostRecyclingObjectScreen extends StatefulWidget {
  const PostRecyclingObjectScreen({
    super.key,
  });
  // final String location;

  @override
  State<PostRecyclingObjectScreen> createState() =>
      _PostRecyclingObjectScreenState();
}

class _PostRecyclingObjectScreenState extends State<PostRecyclingObjectScreen> {
  String selectedWasteType = objectTypeList.first;
  // ignore: unused_field
  String? _objectDescription;

  // ignore: unused_field
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget _buildWasteType() {
    return DropdownButton(
      hint: const Text("Select A Role: "),
      dropdownColor: Colors.grey[200],
      icon: const Icon(Icons.arrow_drop_down),
      iconSize: 36,
      isExpanded: true,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
      value: selectedWasteType,
      onChanged: (newValue) {
        setState(
          () {
            selectedWasteType = newValue.toString();
          },
        );
      },
      items: objectTypeList.map(
        (selectedItem) {
          return DropdownMenuItem(
              value: selectedItem, child: Text(selectedItem));
        },
      ).toList(),
    );
  }

  Widget _buildObjectDescription() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Enter Description"),
      maxLines: 2,
      onSaved: (value) {
        _objectDescription = value;
      },
    );
  }

  int numberOfKg = 1;
  double objectPrice = 1.0;
  File? objectImage;

  // To upload the picture to firebase storage
  Future<String> uploadFile() async {
    final path = 'files/${DateTime.now().microsecondsSinceEpoch}';
    final file = File(objectImage!.path);

    try {
      await FirebaseStorage.instance.ref(path).putFile(file);
      String downloadUrl =
          await FirebaseStorage.instance.ref(path).getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading file: $e');
      return '';
    }
  }

  // for selecting image
  void selectImage() async {
    objectImage = await pickImage(context);
    setState(() {});
  }

  void updatePrice() {
    setState(() {
      objectPrice = numberOfKg * 1.0;
    });
  }

  final CollectionReference _recyclingObjects =
      FirebaseFirestore.instance.collection('recyclingObjects');

  // Method to show the confirmation
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
              SizedBox(width: 10),
              Text('Success'),
            ],
          ),
          content: const Text("Your object has been posted successfully."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Method to show error message on the confirmation
  Future<void> _showErrorDialog(String errorMessage) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
              ),
              SizedBox(width: 10),
              Text('Error'),
            ],
          ),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.teal,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
                top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResidentScreen()),
                        (route) => false);
                  },
                  child: const Icon(
                    Icons.arrow_back, // Replace with your desired menu icon
                    color: Colors.white,
                    size: 30.0, // Adjust the size as needed
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Post Recycling Objects',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  InkWell(
                    onTap: () => selectImage(),
                    child: objectImage == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the border radius as needed
                            child: Container(
                              color: const Color.fromARGB(179, 204, 202, 202),
                              width: 150, // Adjust the width as needed
                              height: 150, // Adjust the height as needed
                              child: const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the border radius as needed
                            child: SizedBox(
                              width: 150, // Adjust the width as needed
                              height: 150, // Adjust the height as needed
                              child: Image.file(
                                objectImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildWasteType(),
                  _buildObjectDescription(),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Number of Kg: $numberOfKg'),
                      Text('Price: $objectPrice GHC'),
                    ],
                  ),

                  // Buttons to increment and decrement bags
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            numberOfKg++;
                            updatePrice();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (numberOfKg > 1) {
                            setState(() {
                              numberOfKg--;
                              updatePrice();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),

                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                      text: 'Confirm',
                      onPressed: () async {
                        String imageDownloadUrl = await uploadFile();
                        String username = ap.userModel.name;
                        String userId = ap.userModel.uid;
                        String residentPhoneNo = ap.userModel.phoneNumber;
                        try {
                          await _recyclingObjects.add({
                            "objectImage": imageDownloadUrl,
                            "userID": userId,
                            "username": username,
                            "wasteType": selectedWasteType,
                            "objectDescription": _objectDescription,
                            "numberOfKg": numberOfKg,
                            "price": objectPrice,
                            // "location": widget.location,
                            "ResidentPhoneNumber": residentPhoneNo,
                          });
                          _showConfirmationDialog();
                        } catch (e) {
                          await _showErrorDialog(
                              "Error saving data. Please try again.");
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

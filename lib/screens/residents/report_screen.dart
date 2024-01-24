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

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    super.key,
  });
  // final String location;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  // ignore: unused_field
  // String? _reportDescription;
  // String? _areaLocation;

  final reportDescription = TextEditingController();
  final areaLocation = TextEditingController();

  Widget textField({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.green,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
            prefixIcon: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green,
              ),
              child: Icon(
                icon,
                size: 20,
                color: Colors.white,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            hintText: hintText,
            alignLabelWithHint: true,
            border: InputBorder.none,
            fillColor: Colors.green.shade50,
            filled: true),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    reportDescription.dispose();
    areaLocation.dispose();
  }

  // ignore: unused_field
  // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // Widget _buildReportDescription() {
  //   return TextFormField(
  //     decoration: const InputDecoration(
  //         labelText:
  //             "Describe your report. eg: GIve more details about the Improper disposal"),
  //     maxLines: 2,
  //     onSaved: (newValue) {
  //       _reportDescription = newValue;
  //     },
  //   );
  // }

  // Widget _buildAreaLocation() {
  //   return TextFormField(
  //     decoration: const InputDecoration(
  //         labelText: "eg: Area where you identify the improper disposal"),
  //     maxLines: 2,
  //     onSaved: (newValue) {
  //       _areaLocation = newValue;
  //     },
  //   );
  // }

  File? reportImage;

  // To upload the picture to firebase storage
  Future<String> uploadFile() async {
    final path = 'files/${DateTime.now().microsecondsSinceEpoch}';
    final file = File(reportImage!.path);

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
    reportImage = await pickImage(context);
    setState(() {});
  }

  final CollectionReference _reports =
      FirebaseFirestore.instance.collection('Reports');

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
                  'Report Improper Disposal',
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
                    child: reportImage == null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the border radius as needed
                            child: Container(
                              color: const Color.fromARGB(179, 204, 202, 202),
                              width: 300, // Adjust the width as needed
                              height: 200, // Adjust the height as needed
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
                              width: 300, // Adjust the width as needed
                              height: 200, // Adjust the height as needed
                              child: Image.file(
                                reportImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // _buildReportDescription(),
                  // _buildAreaLocation(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        textField(
                            hintText: 'eg. New Town',
                            icon: Icons.location_city,
                            inputType: TextInputType.name,
                            maxLines: 1,
                            controller: areaLocation),
                        const SizedBox(
                          height: 15,
                        ),
                        textField(
                            hintText:
                                'Describe your report. eg: GIve more details about the Improper disposal',
                            icon: Icons.description,
                            inputType: TextInputType.name,
                            maxLines: 3,
                            controller: reportDescription),
                      ],
                    ),
                  ),
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
                          await _reports.add({
                            "reportImage": imageDownloadUrl,
                            "userID": userId,
                            "username": username,
                            "reportDescription": reportDescription.text,
                            "AreaLocation": areaLocation.text,
                            "ResidentPhoneNumber": residentPhoneNo,
                            "timestamp": FieldValue.serverTimestamp(),
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

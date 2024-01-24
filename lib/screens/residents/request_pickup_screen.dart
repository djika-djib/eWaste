import 'package:ewaste/screens/residents/resident_maps_screen.dart';
import 'package:ewaste/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:ewaste/provider/auth_provider.dart';
// import 'package:ewaste/model/user_model.dart';

const List<String> wasteTypeList = ["Organic Waste", "Plastic Waste"];

class RequestPickUpScreen extends StatefulWidget {
  const RequestPickUpScreen({super.key, required this.location});
  final String location;

  @override
  State<RequestPickUpScreen> createState() => _RequestPickUpScreenState();
}

class _RequestPickUpScreenState extends State<RequestPickUpScreen> {
  String selectedWasteType = wasteTypeList.first;
  // ignore: unused_field
  String? _wasteDescription;
  String? _collectionArea;
  // DateTime? _selectedDate;

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
      items: wasteTypeList.map(
        (selectedItem) {
          return DropdownMenuItem(
              value: selectedItem, child: Text(selectedItem));
        },
      ).toList(),
    );
  }

  Widget _buildWasteDescription() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Enter Description"),
      maxLines: 2,
      onSaved: (value) {
        _wasteDescription = value;
      },
    );
  }

  Widget _buildCollectionArea() {
    return TextFormField(
      decoration: const InputDecoration(
          labelText: "Enter your area. eg: New Town Post office"),
      onSaved: (value) {
        _collectionArea = value;
      },
    );
  }

  int numberOfBags = 1;
  double bagPrice = 10.0;

  void updatePrice() {
    setState(() {
      bagPrice = numberOfBags * 10.0;
    });
  }

  DateTime dateTime = DateTime.now();

  final CollectionReference _pickupRequests =
      FirebaseFirestore.instance.collection('pickupRequests');

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
          content: const Text("Your request has been submitted successfully."),
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
                            builder: (context) => const ResidentMapsScreen()),
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
                  'Request Pick Up',
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
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  _buildWasteType(),
                  _buildCollectionArea(),
                  _buildWasteDescription(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Number of Bags: $numberOfBags'),
                      Text('Price: $bagPrice GHC'),
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
                            numberOfBags++;
                            updatePrice();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (numberOfBags > 1) {
                            setState(() {
                              numberOfBags--;
                              updatePrice();
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  CupertinoButton(
                    color: Colors.teal,
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => SizedBox(
                          height: 250,
                          child: CupertinoDatePicker(
                            backgroundColor: Colors.white,
                            initialDateTime: dateTime,
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                dateTime = newTime;
                              });
                            },
                            use24hFormat: true,
                            mode: CupertinoDatePickerMode.dateAndTime,
                          ),
                        ),
                      );
                    },
                    child: Text(
                        '${dateTime.day}-${dateTime.month}-${dateTime.year}, ${dateTime.hour}:${dateTime.minute}'),
                  ),
                  const SizedBox(height: 100),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                      text: 'Confirm',
                      onPressed: () async {
                        String username = ap.userModel.name;
                        String userId = ap.userModel.uid;
                        String residentPhoneNo = ap.userModel.phoneNumber;
                        try {
                          await _pickupRequests.add({
                            "userID": userId,
                            "username": username,
                            "wasteType": selectedWasteType,
                            "wasteDescription": _wasteDescription,
                            "numberOfBags": numberOfBags,
                            "price": bagPrice,
                            "scheduledCollectionDate": dateTime,
                            "Area": _collectionArea,
                            "location": widget.location,
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

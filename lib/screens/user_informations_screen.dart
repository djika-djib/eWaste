import 'dart:io';
import 'package:ewaste/model/user_model.dart';
import 'package:ewaste/screens/home_screen.dart';
import 'package:ewaste/screens/recyclingCenters/recycling_center_screen.dart';
import 'package:ewaste/screens/residents/resident_screen.dart';
import 'package:ewaste/screens/wasteCollectors/waste_collector_screen.dart';
import 'package:ewaste/utils/utils.dart';
import 'package:ewaste/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:ewaste/provider/auth_provider.dart';
import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';

const List<String> listRole = [
  "Resident",
  "Waste Collector",
  "Recycling Center"
];

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  State<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  File? image;
  final nameController = TextEditingController();
  final emailContoller = TextEditingController();
  final bioController = TextEditingController();
  String selectedUserRole =
      listRole.first; // Variable to store the selected role

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailContoller.dispose();
    bioController.dispose();
  }

  // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              )
            : Center(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => selectImage(),
                      child: image == null
                          ? const CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 50,
                              child: Icon(
                                Icons.account_circle,
                                size: 50,
                                color: Colors.white,
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(image!),
                              radius: 50,
                            ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      margin: const EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          // Name field
                          textField(
                              hintText: 'Djika Djibrila',
                              icon: Icons.account_circle,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              controller: nameController),

                          // email Field
                          textField(
                              hintText: 'name@example.com',
                              icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                              maxLines: 1,
                              controller: emailContoller),

                          // bio field
                          textField(
                              hintText: 'Enter your bio here',
                              icon: Icons.edit,
                              inputType: TextInputType.name,
                              maxLines: 2,
                              controller: bioController),
                          // User Role
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green.shade50, width: 1),
                                  borderRadius: BorderRadius.circular(15)),
                              child: DropdownButton(
                                hint: const Text("Select A Role: "),
                                dropdownColor: Colors.grey[200],
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 36,
                                isExpanded: true,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                value: selectedUserRole,
                                onChanged: (newValue) {
                                  setState(
                                    () {
                                      selectedUserRole = newValue.toString();
                                    },
                                  );
                                },
                                items: listRole.map(
                                  (selectedItem) {
                                    return DropdownMenuItem(
                                        value: selectedItem,
                                        child: Text(selectedItem));
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      height: 50,
                      child: CustomButton(
                        text: 'Continue',
                        onPressed: () => storeData(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    ));
  }

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

  // Store user data to db
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailContoller.text.trim(),
      bio: bioController.text.trim(),
      userRole: selectedUserRole,
      profilePic: "",
      // createdAt: "",
      phoneNumber: "",
      uid: "",
    );
    if (image != null) {
      ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        onSuccess: () {
          // once data is saved we also need to store it locally
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then((value) {
                  if (selectedUserRole == 'Resident') {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResidentScreen()),
                        (route) => false);
                  } else if (selectedUserRole == 'Waste Collector') {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WasteCollectorScreen()),
                        (route) => false);
                  } else if (selectedUserRole == 'Recycling Center') {
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
                  // Navigator.pushAndRemoveUntil(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const HomeScreen()),
                  //     (route) => false),
                }),
              );
        },
      );
    } else {
      showsSnackBar(context, "Please upload your profile picture");
    }
  }
}



// 520032542 
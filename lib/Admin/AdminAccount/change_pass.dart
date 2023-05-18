import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Admin/admin_main.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController email = TextEditingController();
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    email.text = FirebaseAuth.instance.currentUser!.email.toString();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.teal, // transparent status bar
      systemNavigationBarColor: Colors.transparent, // navigation bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness: Brightness.dark,
      //navigation bar icons' color
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onTap: () => Navigator.of(context).pop()),
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(15),
                child: Text(
                  "Hi There..!",
                  style: GoogleFonts.righteous(
                      fontSize: 30, color: Colors.teal.shade700),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Email I'd",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        readOnly: true,
                        controller: email,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black54),
                        cursorColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Old Password",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        controller: oldPass,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 6,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            counterText: "",
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            border: InputBorder.none),
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black54),
                        cursorColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "New Password",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        controller: newPass,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 6,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            counterText: "",
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            border: InputBorder.none),
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black54),
                        cursorColor: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Confirm Password",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        controller: confirmPass,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        maxLength: 6,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                            counterText: "",
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            border: InputBorder.none),
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black54),
                        cursorColor: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, top: 30, right: 15),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.teal.shade700),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ))),
                  onPressed: changePass,
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Please Wait...',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ))
                          ],
                        )
                      : const Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  changePass() async {
    String emailId = email.text;
    String oldPassword = oldPass.text;
    String newPassword = newPass.text;
    String cPassword = confirmPass.text;

    if (oldPassword.isEmpty || newPassword.isEmpty || cPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Fill all details')));
    } else if (newPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password length should be 6 digit')));
    } else if (newPassword != cPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password does not match')));
    } else {
      setState(() {
        isLoading = true;
      });
      var cred =
          EmailAuthProvider.credential(email: emailId, password: oldPassword);
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(cred)
          .then((value) {
        FirebaseAuth.instance.currentUser!
            .updatePassword(newPassword)
            .then((_) async {
          await FirebaseFirestore.instance
              .collection('Admin')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({'Password': newPassword}, SetOptions(merge: true)).then(
                  (value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const AdminDashboard()),
                (Route<dynamic> route) => false);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Successfully changed password")));
          });
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Password can't be changed$error")));
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'The password is invalid or the user does not have a password.')));
      });
    }
  }
}

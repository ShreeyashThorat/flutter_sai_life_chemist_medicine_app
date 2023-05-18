import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customizable_dropdown/customizable_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/screens/dashboard.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  bool isLoading = false;
  String dist = '';
  List<String> district = [
    'Mumbai',
    'Thane',
    'Palghar',
    'Raigad',
    'Ratnagiri',
    'Sindhudurg',
    'Dhule',
    'Jalgaon',
    'Nandurbar',
    'Nashik',
    'Ahmednagar',
    'Bhandara',
    'Chandrapur',
    'Gadchiroli',
    'Gondia',
    'Nagpur',
    'Wardha',
    'Aurangabad',
    'Beed',
    'Jalna',
    'Osmanabad',
    'Nanded',
    'Latur',
    'Parbhani',
    'Hingoli',
    'Akola',
    'Amravati',
    'Buldhana',
    'Yavatmal',
    'Washim',
    'Sangli',
    'Satara',
    'Solapur',
    'Kolhapur',
    'Pune',
  ];

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController add1 = TextEditingController();
  TextEditingController add2 = TextEditingController();
  TextEditingController add3 = TextEditingController();
  TextEditingController add4 = TextEditingController();
  String state = "Maharashtra";
  String contact = FirebaseAuth.instance.currentUser!.phoneNumber.toString();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    phone.dispose();
    add1.dispose();
    add2.dispose();
    add3.dispose();
    add4.dispose(); // dispose of the controller when the widget is removed from the tree
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    add3.text = state;
    phone.text = contact;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarIconBrightness: Brightness.dark, // status bar icons' color
      systemNavigationBarIconBrightness:
          Brightness.dark, //navigation bar icons' color
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
          'SAi LiFE CHEMiST',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Almost There !",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.righteous(
                        fontSize: 30, color: Colors.teal.shade700),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 10),
                  child: Text(
                    "We are excited to see you here..!",
                    style: GoogleFonts.acme(fontSize: 25, color: Colors.teal),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: fullName,
                    keyboardType: TextInputType.name,
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
                        labelText: 'Full Name',
                        prefixIcon:
                            Icon(Icons.person_outline, color: Colors.black),
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    cursorColor: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
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
                        labelText: "Email I'd",
                        prefixIcon:
                            Icon(Icons.email_outlined, color: Colors.black),
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    cursorColor: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: TextField(
                    readOnly: true,
                    maxLength: 10,
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: 'Contact no',
                        prefixIcon: Icon(Icons.phone_iphone_outlined,
                            color: Colors.black),
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    cursorColor: Colors.grey,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 25),
                  child: const Text(
                    'Your Address',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: add1,
                    keyboardType: TextInputType.streetAddress,
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
                        labelText: 'House Number & Building',
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    cursorColor: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: add2,
                    keyboardType: TextInputType.streetAddress,
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
                        labelText: 'Street & City',
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    cursorColor: Colors.grey,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0)),
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  child: CustomizableDropdown(
                      width: MediaQuery.of(context).size.width,
                      maxHeight: MediaQuery.of(context).size.height / 3,
                      height: 50,
                      icon: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black,
                      ),
                      titleStyle: const TextStyle(fontSize: 20),
                      titleAlign: TextAlign.center,
                      itemList: district,
                      onSelectedItem: (sele) {
                        setState(() {
                          dist = sele;
                        });
                      },
                      placeholder: const Text(
                        "DISTRICT",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      )),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: add3,
                    readOnly: true,
                    keyboardType: TextInputType.streetAddress,
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
                        labelText: 'State',
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    cursorColor: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: add4,
                    maxLength: 6,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                        counterText: "",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        labelText: 'PIN Number',
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    cursorColor: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 50),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.teal.shade700),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ))),
                    onPressed: storeuser,
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
            ),
          )
        ],
      ),
    );
  }

  storeuser() async {
    if (fullName.text.isEmpty ||
        email.text.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.text) ||
        phone.text.isEmpty ||
        add1.text.isEmpty ||
        add2.text.isEmpty ||
        add3.text.isEmpty ||
        add4.text.isEmpty ||
        dist == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Fill all details')));
    } else if (dist != "Mumbai") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'We are unavailable to deliver in $dist. We will be there very soon')));
    } else {
      setState(() {
        isLoading = true;
      });
      try {
        String uid = FirebaseAuth.instance.currentUser!.uid.toString();
        String fname = fullName.text;
        String femail = email.text;

        await FirebaseFirestore.instance.collection('Users').doc(uid).set({
          'Name': fname,
          'Email': femail,
          'Phone No': contact,
          'uid': uid,
          'wallet': 0
        }).then((value) async {
          String address =
              "${add1.text}, ${add2.text}, $dist, ${add3.text}, ${add4.text}";
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(uid)
              .collection('Address')
              .doc()
              .set({
            'Address': address,
          }).then((value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Dashboard()),
                (Route<dynamic> route) => false);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$fname : Welcom to Sai Life")));
          });
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error Occured')));
      }
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/Database/databasedata.dart';
import 'package:sai_life/UserScreens/All%20Transactions/all_transactions.dart';
import 'package:sai_life/UserScreens/Bank%20Account/bank_details.dart';
import 'package:sai_life/UserScreens/Manage%20Address/manage_address.dart';
import 'package:sai_life/UserScreens/My%20Prescription/my_prescriptions.dart';
import 'package:sai_life/UserScreens/My%20Profile/my_orders.dart';
import 'package:sai_life/UserScreens/Need%20Help/need_help.dart';
import 'package:sai_life/UserScreens/Wallet/wallet.dart';
import 'package:sai_life/UserScreens/about_us.dart';
import 'package:sai_life/UserScreens/edit_profile.dart';
import 'package:sai_life/screens/register_user.dart';

import '../screens/signin.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String contact = FirebaseAuth.instance.currentUser!.phoneNumber.toString();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseData.getUser(FirebaseAuth.instance.currentUser!.uid),
      builder: (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.black54),
            ),
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi There..!",
                          style: GoogleFonts.righteous(
                              fontSize: 30, color: Colors.teal.shade700),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          contact,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    height: 3,
                    width: MediaQuery.of(contex).size.width,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterUser()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Update Profile",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.calendar_today,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Reminder Me Pill",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.help,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Need Help ?",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                    'Do you want to exit this application?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 20),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login()),
                                          (Route<dynamic> route) => false);
                                    },
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                        color: Colors.deepOrange))),
                            child: const Text(
                              'LOGOUT',
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        } else {
          var data = snapshot.data!.docs[0];
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${data['Name']}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(contact),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfile(data: data)),
                              );
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.blueAccent,
                            ))
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade100,
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: const Text(
                      "Your Details",
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyOrders()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.article,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "My Orders",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyPrescriptions()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.assignment,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "My Prescriptions",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BankDetails()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.account_balance,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Bank Details",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ManageAddress()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.location_pin,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Manage Addresses",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AllTransaction()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.currency_exchange_rounded,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "All Transactions",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Wallet()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.wallet,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Wallet",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade100,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                    child: const Text(
                      "Others",
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AboutUs()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.aod_outlined,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "About Us",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black54,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NeedHelp()),
                            );
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 36,
                                width: 36,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8.0)),
                                child: const Icon(
                                  Icons.help,
                                  size: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                "Need Help ?",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black54),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(15),
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text(
                                    'Do you want to exit this application?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 20),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseAuth.instance.signOut();
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Login()),
                                          (Route<dynamic> route) => false);
                                    },
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(
                                          color: Colors.orange, fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                )),
                                side: MaterialStateProperty.all<BorderSide>(
                                    const BorderSide(
                                        color: Colors.deepOrange))),
                            child: const Text(
                              'LOGOUT',
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: Colors.grey.shade100,
                    padding: const EdgeInsets.fromLTRB(15, 50, 15, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("SAi LiFE CHEMiSt",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold)),
                        Text(
                          "GET WHAT YOU NEED",
                          style: GoogleFonts.righteous(
                              letterSpacing: 3,
                              fontSize: 27,
                              color: Colors.black45),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        }
      },
    );
  }
}

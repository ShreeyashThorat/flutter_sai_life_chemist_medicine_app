import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sai_life/Admin/AdminAccount/change_pass.dart';
import 'package:sai_life/Admin/AdminAccount/account_details.dart';
import 'package:sai_life/Admin/AdminDatabase/admin_data.dart';
import 'package:sai_life/screens/signin.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AdminData.getAdmin(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.black54),
              ),
            );
          } else {
            var data = snapshot.data!.docs[0];
            return ListView(
              shrinkWrap: true,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AdminAccount()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                        child: Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(103, 241, 195, 125),
                                  borderRadius: BorderRadius.circular(180)),
                              child: Text(data['Name'][0],
                                  style: const TextStyle(
                                      fontSize: 40,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['Name'],
                                  style: const TextStyle(fontSize: 23),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  FirebaseAuth.instance.currentUser!.email
                                      .toString(),
                                  style: const TextStyle(fontSize: 15),
                                )
                              ],
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade100,
                      height: 20,
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangePassword()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
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
                                Icons.lock,
                                size: 20,
                                color: Colors.black45,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Change Password",
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
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text(
                              'Do you want to exit this application?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.orange, fontSize: 20),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                await FirebaseAuth.instance
                                    .signOut()
                                    .then((value) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Login()),
                                      (Route<dynamic> route) => false);
                                });
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
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15),
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
                                Icons.logout,
                                size: 20,
                                color: Colors.black45,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "Logout",
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
                    ),
                  ],
                )
              ],
            );
          }
        });
  }
}

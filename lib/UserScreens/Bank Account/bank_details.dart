import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sai_life/Database/databasedata.dart';
import 'package:sai_life/UserScreens/Bank%20Account/bank_account.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  State<BankDetails> createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  @override
  Widget build(BuildContext context) {
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
          'Manage Addresses',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder(
          stream: FirebaseData.getBanks(FirebaseAuth.instance.currentUser!.uid),
          builder:
              (BuildContext contex, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.black54),
                ),
              );
            } else {
              var data = snapshot.data!.docs;
              return Padding(
                padding: const EdgeInsets.all(15),
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: List.generate(
                          data.length,
                          (index) => Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        padding: const EdgeInsets.all(15),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Bank Name :",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    data[index]['Bank'],
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "IFSC Code :",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    data[index]['IFSC'],
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Account Number :",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    data[index]['Account No'],
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text(
                                                    "Beneficiary Name :",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    data[index]['B Name'],
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.highlight_remove,
                                        color: Colors.deepOrange,
                                      ),
                                      onPressed: () => showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text(
                                              'Do you want to delete this address?'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 20),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                final firestoreInstance =
                                                    FirebaseFirestore.instance;
                                                final collectionRef =
                                                    firestoreInstance
                                                        .collection('Users')
                                                        .doc(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid)
                                                        .collection("Address");
                                                final documentRef =
                                                    collectionRef.where(
                                                        'Address',
                                                        isEqualTo: data[index]
                                                            ['Address']);
                                                final documentSnapshot =
                                                    await documentRef.get();
                                                await documentSnapshot
                                                    .docs.first.reference
                                                    .delete()
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              'Address has been removed')));
                                                });
                                              },
                                              child: const Text(
                                                'OK',
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )),
                    ),
                  ],
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BankAccount()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Bank'),
      ),
    );
  }
}

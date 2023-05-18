import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sai_life/Database/databasedata.dart';

class AllTransaction extends StatefulWidget {
  const AllTransaction({super.key});

  @override
  State<AllTransaction> createState() => _AllTransactionState();
}

class _AllTransactionState extends State<AllTransaction> {
  final int transactionsPerPage = 10;
  int currentPage = 1;
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
          'All Transactions',
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseData.getTransactions(
                    FirebaseAuth.instance.currentUser!.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.black54),
                      ),
                    );
                  }
                  final List<QueryDocumentSnapshot> documents =
                      snapshot.data!.docs;
                  final int totalTransactions = documents.length;

                  final int startIndex =
                      (currentPage - 1) * transactionsPerPage;
                  final int endIndex = startIndex + transactionsPerPage;
                  final List<QueryDocumentSnapshot> currentDocuments =
                      documents.sublist(
                    startIndex,
                    endIndex < totalTransactions ? endIndex : totalTransactions,
                  );

                  return Column(children: [
                    ...List.generate(currentDocuments.length, (index) {
                      final Map<String, dynamic> data = currentDocuments[index]
                          .data() as Map<String, dynamic>;

                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  data['Date'],
                                  style: const TextStyle(
                                      fontSize: 17, color: Colors.black54),
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 120,
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      color: data['Particular'] !=
                                              "Order Cancelled"
                                          ? const Color.fromARGB(
                                              103, 247, 210, 155)
                                          : const Color.fromARGB(
                                              94, 127, 212, 203),
                                      alignment: Alignment.center,
                                      child: Text(
                                        data['Particular'],
                                        style: TextStyle(
                                          color: data['Particular'] !=
                                                  "Order Cancelled"
                                              ? Colors.orange
                                              : Colors.green,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: data['Particular'] !=
                                                "Order Cancelled"
                                            ? Text(
                                                "-${data['Amount']}.00",
                                                style: TextStyle(
                                                  color: Colors.red.shade600,
                                                  fontSize: 20,
                                                ),
                                              )
                                            : Text(
                                                "+${data['Amount']}.00",
                                                style: TextStyle(
                                                  color: Colors.green.shade600,
                                                  fontSize: 20,
                                                ),
                                              )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade200,
                            height: 2,
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: currentPage > 1
                              ? () => setState(() => currentPage--)
                              : null,
                          child: const Text('Prev'),
                        ),
                        const SizedBox(width: 16.0),
                        Text('Page $currentPage'),
                        const SizedBox(width: 16.0),
                        ElevatedButton(
                          onPressed: endIndex < totalTransactions
                              ? () => setState(() => currentPage++)
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ]);
                }),
          ),
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sai_life/Admin/Product/get_product.dart';

class AdminSearchProduct extends StatefulWidget {
  const AdminSearchProduct({super.key});

  @override
  State<AdminSearchProduct> createState() => _AdminSearchProductState();
}

class _AdminSearchProductState extends State<AdminSearchProduct> {
  final searchProduct = TextEditingController();
  Stream<QuerySnapshot>? searchResult;

  @override
  void dispose() {
    searchProduct.dispose();
    super.dispose();
  }

  String _query = "";
  void startSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _query = query;
        searchResult = FirebaseFirestore.instance
            .collection("Products")
            .orderBy("P_Name")
            .limit(100)
            .snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
            child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 45,
              child: TextField(
                controller: searchProduct,
                autofocus: true,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    labelText: 'Search medicines & health products',
                    suffixIcon:
                        const Icon(Icons.search_rounded, color: Colors.black54),
                    labelStyle:
                        const TextStyle(fontSize: 20, color: Colors.grey)),
                style: const TextStyle(fontSize: 20, color: Colors.black54),
                cursorColor: Colors.grey,
                cursorHeight: 22,
                onChanged: startSearch,
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: StreamBuilder<QuerySnapshot>(
                  stream: searchResult,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final searchResults = snapshot.data!.docs.where((document) {
                      final name = document['P_Name'].toString().toLowerCase();
                      final queryLowerCase = _query.toLowerCase();
                      return name.contains(queryLowerCase);
                    }).map((document) {
                      final name = document['P_Name'];
                      final image = document['Image'];
                      final price = document["S_price"];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GetProduct(pname: name, data: document)),
                          );
                        },
                        child: ListTile(
                          leading: Image(
                            alignment: Alignment.center,
                            image: NetworkImage(image),
                            width: 50,
                            height: 50,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                "\u{20B9}$price",
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList();

                    return ListView(children: searchResults);
                  }),
            ))
          ],
        )),
      ),
    );
  }
}

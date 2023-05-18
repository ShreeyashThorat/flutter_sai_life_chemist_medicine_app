import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDeals extends StatefulWidget {
  final String? deal;
  const AddDeals({Key? key, required this.deal}) : super(key: key);

  @override
  State<AddDeals> createState() => _AddDealsState();
}

class _AddDealsState extends State<AddDeals> {
  TextEditingController sPrice = TextEditingController();
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
      body: SafeArea(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25),
            padding: const EdgeInsets.only(left: 15, right: 15),
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
                    final price = document["Price"];
                    final sprice = document["S_price"];
                    return GestureDetector(
                      onTap: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Add Product'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name),
                              Text(
                                "\u{20B9}$price",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.red),
                              ),
                              Container(
                                height: 40,
                                margin: const EdgeInsets.only(top: 10),
                                child: TextField(
                                  controller: sPrice,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      labelText: 'Selling Price',
                                      labelStyle: TextStyle(
                                          fontSize: 20, color: Colors.grey)),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  cursorColor: Colors.grey,
                                ),
                              ),
                            ],
                          ),
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
                                  String sellingPrice = sPrice.text;
                                  if (sellingPrice.toString().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Selling price can't be empty")));
                                  } else {
                                    try {
                                      await FirebaseFirestore.instance
                                          .collection('Products')
                                          .doc(name)
                                          .set({
                                        "S_price": num.parse(sellingPrice),
                                        widget.deal!: true,
                                      }, SetOptions(merge: true)).then((value) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('Successful')));
                                      });
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text('Error: $e')));
                                    }
                                  }
                                },
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Colors.teal, fontSize: 20),
                                ))
                          ],
                        ),
                      ),
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
                              "\u{20B9}$sprice",
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
    );
  }
}

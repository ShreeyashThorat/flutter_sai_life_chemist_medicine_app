import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sai_life/Admin/admin_main.dart';

class EditProduct extends StatefulWidget {
  final String? pname;
  const EditProduct({Key? key, required this.pname}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  TextEditingController image = TextEditingController();
  TextEditingController pname = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController ingredients = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController ratings = TextEditingController();
  @override
  Widget build(BuildContext context) {
    pname.text = widget.pname!;
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
              size: 18,
            ),
            onTap: () => Navigator.of(context).pop()),
        title: const Text(
          'Edit Product',
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: editProduct,
              child: Row(
                children: const [
                  Text(
                    'Save',
                    style: TextStyle(color: Colors.black, fontSize: 21),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.save,
                    color: Colors.black,
                    size: 18,
                  )
                ],
              ))
        ],
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        child: Expanded(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  readOnly: true,
                  controller: pname,
                  keyboardType: TextInputType.text,
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
                      labelText: 'Product Name',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey)),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  cursorColor: Colors.grey,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: category,
                  keyboardType: TextInputType.text,
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
                      labelText: 'Drug Category',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey)),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  cursorColor: Colors.grey,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: description,
                  minLines: 6,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
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
                      labelText: 'Product Description',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey)),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  cursorColor: Colors.grey,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: ingredients,
                  keyboardType: TextInputType.text,
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
                      labelText: 'Ingredients',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey)),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  cursorColor: Colors.grey,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: price,
                  keyboardType: TextInputType.number,
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
                      labelText: 'Price',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey)),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  cursorColor: Colors.grey,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: TextField(
                  controller: image,
                  keyboardType: TextInputType.text,
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
                      labelText: 'Product ImageURL',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey)),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  cursorColor: Colors.grey,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: ratings,
                  keyboardType: TextInputType.text,
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
                      labelText: 'Ratings',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.grey)),
                  style: const TextStyle(fontSize: 20, color: Colors.black),
                  cursorColor: Colors.grey,
                ),
              ),
            ],
          ),
        )),
      )),
    );
  }

  editProduct() async {
    String imageurl = image.text;
    String dCat = category.text;
    String des = description.text;
    String ingredient = ingredients.text;
    String val = price.text;
    String rates = ratings.text;

    if (imageurl.isEmpty ||
        dCat.isEmpty ||
        des.isEmpty ||
        ingredient.isEmpty ||
        val.toString().isEmpty ||
        rates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Fill all details')));
    } else {
      final CollectionReference productsRef =
          FirebaseFirestore.instance.collection('Products');
      final QuerySnapshot snapshot =
          await productsRef.where('P_Name', isEqualTo: widget.pname!).get();
      final DocumentSnapshot documentSnapshot = snapshot.docs.first;

      await productsRef.doc(documentSnapshot.id).update({
        'DrugCategory': dCat,
        'Price': num.parse(val),
        'Image': imageurl,
        'Description': des,
        'Ingredients': ingredient,
        'Ratings': rates
      }).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      });
    }
  }
}

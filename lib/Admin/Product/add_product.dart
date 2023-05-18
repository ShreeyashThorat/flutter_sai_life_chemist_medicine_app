import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sai_life/Database/databasedata.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController image = TextEditingController();
  TextEditingController pname = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController ingredients = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController sPrice = TextEditingController();
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
              size: 18,
            ),
            onTap: () => Navigator.of(context).pop()),
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.black, fontSize: 23),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: addData,
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
      body: ListView(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextField(
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
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
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
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
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
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
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
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
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
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
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
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    cursorColor: Colors.grey,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: sPrice,
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
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.grey)),
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                    cursorColor: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  addData() {
    String imageurl = image.text;
    String pName = pname.text;
    String dCat = category.text;
    String des = description.text;
    String ingredient = ingredients.text;
    String val = price.text;
    String sellingPrice = sPrice.text;

    if (imageurl.isEmpty ||
        pName.isEmpty ||
        dCat.isEmpty ||
        des.isEmpty ||
        ingredient.isEmpty ||
        val.toString().isEmpty ||
        sellingPrice.toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Fill all details')));
    } else {
      addProduct(pName, dCat, num.parse(val), imageurl, des, ingredient,
          num.parse(sellingPrice));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddProduct()),
      );
    }
  }
}

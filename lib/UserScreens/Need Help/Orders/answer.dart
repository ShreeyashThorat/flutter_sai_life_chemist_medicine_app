import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FAQAnswers extends StatefulWidget {
  final String? question;
  final dynamic data;
  const FAQAnswers({Key? key, required this.question, this.data})
      : super(key: key);

  @override
  State<FAQAnswers> createState() => _FAQAnswersState();
}

class _FAQAnswersState extends State<FAQAnswers> {
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
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              widget.data["Answer"],
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}

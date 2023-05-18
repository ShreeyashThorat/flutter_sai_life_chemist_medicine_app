import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sai_life/screens/dashboard.dart';
import 'package:sai_life/screens/signin.dart';

class LoginOTP extends StatefulWidget {
  final String contactNo;
  const LoginOTP({super.key, required this.contactNo});

  @override
  State<LoginOTP> createState() => _LoginOTPState();
}

class _LoginOTPState extends State<LoginOTP> {
  var otpval = '';
  bool isLoading = false;

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
            onTap: () => exit(0)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Text(
                  "Phone Verification",
                  style: GoogleFonts.righteous(
                      fontSize: 30, color: Colors.teal.shade700),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: const Text(
                      "We sent you a code to verify your mobile number",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.teal)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Image(
                    image: AssetImage("assets/logos/otp.jpg"),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: OtpTextField(
                      cursorColor: Colors.black,
                      mainAxisAlignment: MainAxisAlignment.center,
                      numberOfFields: 6,
                      borderColor: Colors.black,
                      borderWidth: 4.0,
                      fillColor: Colors.lightGreen.shade50,
                      filled: true,
                      textStyle: const TextStyle(
                        fontSize: 22,
                      ),
                      showFieldAsBox: false,
                      focusedBorderColor: Colors.black,
                      autoFocus: true,
                      onCodeChanged: (value) {},
                      onSubmit: (code) async {
                        otpval = code;
                        setState(() {
                          isLoading = true;
                        });
                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: Login.verify,
                                  smsCode: otpval);

                          // Sign the user in (or link) with the credential
                          await FirebaseAuth.instance
                              .signInWithCredential(credential)
                              .then((value) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Dashboard()),
                                (Route<dynamic> route) => false);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('OTP Verified')));
                          });
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Wrong OTP')));
                        }
                      }),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
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
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: Login.verify, smsCode: otpval);
                        await FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Dashboard()),
                              (Route<dynamic> route) => false);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('OTP Verified')));
                        });
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Wrong OTP')));
                      }
                    },
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
                            'VERIFY OTP',
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side:
                                        const BorderSide(color: Colors.teal)))),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: const Text(
                      'TRY AGAIN',
                      style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
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
}

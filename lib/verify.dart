import 'package:ark/signUp.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  TextEditingController email = new TextEditingController();
  TextEditingController otp = new TextEditingController();
  EmailOTP myauth = EmailOTP();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Email Verification"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: email,
                        decoration:
                            const InputDecoration(hintText: "User Email")),
                  ),
                  GestureDetector(
                      onTap: () async {
                        myauth.setConfig(
                            appEmail: "me@rohitchouhan.com",
                            appName: "Email OTP",
                            userEmail: email.text,
                            otpLength: 6,
                            otpType: OTPType.digitsOnly);
                        if (await myauth.sendOTP() == true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("OTP has been sent"),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Oops, Unable to send OTP"),
                          ));
                        }
                      },
                      child: Text(
                        "Send OTP",
                        style: GoogleFonts.openSans(color: blue),
                      )),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                        controller: otp,
                        decoration:
                            const InputDecoration(hintText: "Enter OTP")),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (await myauth.verifyOTP(otp: otp.text) == true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("OTP is verified"),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Invalid OTP"),
                          ));
                        }
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp(
                                        email: email.toString(),
                                      )));
                        });
                      },
                      child: const Text("Verify")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
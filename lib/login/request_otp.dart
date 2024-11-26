import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

import 'package:zs_satis/login/model_user.dart';

import 'user_tapildi_screans.dart';


class Request_OTP extends StatefulWidget {
  ModelUser modelUser;
  String verificationId;
  Request_OTP({required this.phoneNumber,required this.modelUser,required this.verificationId});

  final phoneNumber;

  @override
  _Request_OTPState createState() => _Request_OTPState();
}

class _Request_OTPState extends State<Request_OTP> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isResendAgain = false;
  bool _isVerified = false;
  bool _isLoading = false;

  String _code = '';

  late Timer _timer;
  int _start = 60;

  void resend() {
    setState(() {
      _isResendAgain = true;
    });

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_start == 0) {
          _start == 60;
          _isResendAgain = false;
          timer.cancel();
        } else {
          _start--;
        }
      });
    });
  }

  verify() {
    setState(() {
      _isLoading=true;
      _signInWithPhoneNumber();
    });

    const oneSec = Duration(milliseconds: 1000);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        _isLoading = false;
        _isVerified = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var phoneNumber;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 250,
                height: 250,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.white),
                child: Image.asset("images/codeverify.png"),
              ),
              const SizedBox(height: 20),
              const Text(
                "Verification",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Please enter the 6 digit code sent to \n ${widget.phoneNumber}",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.grey.shade500, height: 1.5),
              ),
              SizedBox(height: 30),
              VerificationCode(
                itemSize: 40,
                  length: 6,
                  textStyle: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.number,
                  onCompleted: (value) {
                    setState(() {
                      _code = value;
                    });
                  },
                  onEditing: (value) {}),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't receive the OTP?",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                  TextButton(
                      onPressed: () {
                        if (_isResendAgain) return;
                        resend();
                      },
                      child: Text(
                        _isResendAgain
                            ? "Try again in " + _start.toString()
                            : "Resend",
                        style: TextStyle(color: Colors.blueAccent),
                      ))
                ],
              ),
              SizedBox(height: 50),
              MaterialButton(
                disabledColor: Colors.grey.shade300,
                color: Colors.black,
                height: 40,
                minWidth: double.infinity,
                child: _isLoading
                    ? Container(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 3,
                    color: Colors.black,
                  ),
                )
                    : _isVerified ? Icon(Icons.check, color: Colors.white, size: 30,) : Text(
                  "Verify",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: _code.length < 6 ? null : () { verify(); },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _signInWithPhoneNumber() async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _code,
      );
      FocusScope.of(context).unfocus();
      final User user = (await _auth.signInWithCredential(credential)).user!;
      // showToast('Successfully signed in UID: ${user.uid}', Colors.red);
      setState(() {
       String userId = user.uid;
       _isLoading = false;
        Fluttertoast.showToast(msg: "Hirmetli is id :$userId",toastLength: Toast.LENGTH_LONG);
       _checkPhonenumbberFromDatabase(widget.phoneNumber, userId);
      });
    } catch (e) {
      print(e);
     // showToast('Failed to sign in', Colors.red);
    }
  }

  Future _checkPhonenumbberFromDatabase(String _phone, String userid) async {
    FirebaseFirestore.instance
        .collection("Users")
        .where("userPhone", isEqualTo: _phone)
        .get()
        .then((value) {
      if (value.size == 0) {

      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserTapildi(userid: userid)));
      }
    });

    // DatabaSeservice databaSeservice = DatabaSeservice();
    // CollectionReference reference =
    // FirebaseFirestore.instance.collection("Users");
    // reference.get().then((value) {
    //   value.docs.forEach((element) {
    //     String number = element['userPhone'];
    //     if (number==_phone) {
    //       setState(() {
    //         isLoading = false;
    //       });
    //       showToast('Bu nomre qeydiyyatda var', Colors.blueAccent);
    //     } else {
    //       showToast('Bu nomre qeydiyyatda YOXDUR', Colors.red);
    //
    //       //  _verifyPhoneNumber(_phoneNo);
    //       setState(() {
    //         isLoading = false;
    //       });
    //     }
    //   });
    // });

    //////////////////////////////////////////////////////
    // bool nomrevar=await databaSeservice.checkPhoneNumber(_phone);
    //   if (nomrevar) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //     showToast('Bu nomre qeydiyyatda var', Colors.blueAccent);
    //   } else {
    //     showToast('Bu nomre qeydiyyatda YOXDUR', Colors.red);
    //
    //     //  _verifyPhoneNumber(_phoneNo);
    //     setState(() {
    //       isLoading = false;
    //     });
    //   }
  }
}
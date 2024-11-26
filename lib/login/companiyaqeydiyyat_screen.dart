import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tunaf_country_code/country_code_picker.dart';
import 'package:zs_satis/login/model_user.dart';
import 'package:zs_satis/login/request_otp.dart';

import '../constandlar/sablom_suzler.dart';
import '../custom_alert.dart';


class ComppaniyaQeydiyyatScreen extends StatefulWidget {
  const ComppaniyaQeydiyyatScreen({Key? key}) : super(key: key);

  @override
  _ComppaniyaQeydiyyatScreenState createState() => _ComppaniyaQeydiyyatScreenState();
}

class _ComppaniyaQeydiyyatScreenState extends State<ComppaniyaQeydiyyatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;
  var phoneNumber;
  var selectedcontrycode = "+994";
  bool codeselected=false;
  final TextEditingController _kompani = TextEditingController();
  final TextEditingController _adsoyad = TextEditingController();
  ModelUser modelUser=ModelUser();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.white24,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 1),
              FadeInDown(
                duration: Duration(seconds: 1),
                child: Image.asset(
                  "images/global_hesab.png",
                  fit: BoxFit.cover,
                  height: 100,
                ),
              ),
              SizedBox(height: 20),
              FadeInDown(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1300),
                child: Text(
                  Shablomsozler().basliqkompaniya,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              FadeInDown(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1300),
                child: Text(
                  "Zehmet olmasa melumatlari tam doldurun",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50),
              FadeInDown(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1300),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: _kompani,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.account_balance_outlined),
                        hintText: 'Kompaniya adini yazin',
                        hintStyle: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        border: InputBorder.none),
                    validator: (val) => (val!.length != 10 || val.isEmpty)
                        ? 'Ad və soyadınızı daxil edın'
                        : null,
                    onChanged: (val) {
                      //   setState(() => _phoneNo = val);
                    },
                  ),
                ),
              ),//edittext compani
              SizedBox(height: 15),
              FadeInDown(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1300),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    textAlign: TextAlign.start,
                    controller: _adsoyad,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.normal),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_outline_outlined),
                        hintText: 'Sahibkad ad ve soyad',
                        hintStyle: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                        border: InputBorder.none),
                    validator: (val) => (val!.length != 10 || val.isEmpty)
                        ? 'Ad və soyadınızı daxil edın'
                        : null,
                    onChanged: (val) {
                      //   setState(() => _phoneNo = val);
                    },
                  ),
                ),
              ),//edittext ad soyad
              SizedBox(height: 15),
              FadeInDown(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1300),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black.withOpacity(0.15)),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFEEEEEE),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children:   [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: CountryCodePicker(
                          onChanged: (value){
                            codeselected=true;
                            selectedcontrycode=value.code.toString();
                          },
                          padding: EdgeInsets.all(1),
                          textStyle: TextStyle(color: Colors.black),
                          showFlagDialog: false,
                          showFlag: false,
                          favorite: ["AZ","TR"],
                          alignLeft: false,
                          initialSelection: "+994",
                        ),
                      ),
                      Container(margin: EdgeInsets.all(10),width: 1,height: 30,color: Colors.black,),
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                              hintText: "(050) 000 00 00",
                              border: InputBorder.none
                          ),
                          onChanged: (value){
                            phoneNumber=value.toString();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              FadeInDown(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1300),
                child: MaterialButton(
                  onPressed: () {
                    if(!codeselected){
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlert(
                              icon: Icons.info,
                              color: Colors.red,
                              textinfo: "Olke kodu secin ",
                            );
                          });
                    } else if(phoneNumber.toString().length<10) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return CustomAlert(
                              icon: Icons.info,
                              color: Colors.red,
                              textinfo: "Telefon nomresini tam girin \n Misal(0552000000)",
                            );
                          });
                    }else{
                      setState(() {
                        _verifyPhoneNumber(phoneNumber);
                      });
                    }
                  },
                  color: Colors.green,
                  minWidth: double.infinity,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  child: Text(
                    Shablomsozler().tesdiqle,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 5),
              FadeInDown(
                delay: Duration(milliseconds: 800),
                duration: Duration(milliseconds: 1300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhoneNumber(String _phoneNo) async {
    setState(() {});
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      // showToast(
      //     'Phone number automatically verified and user signed in: $phoneAuthCredential',
      //     Colors.red);
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setState(() {
        // showToast(
        //     'Phone number verification failed. Code: ${authException.code}. '
        //         'Message: ${authException.message}',
        //     Colors.red);
      });
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      // showToast(
      //     'Please check your phone for the verification code.', Colors.blue);
      setState(() {
       // isLoading = false;
        ModelUser modelUser = ModelUser(
            id: "0",
            qeydiyyattarixi: DateTime.now().toIso8601String(),
            sonaktivlik: DateTime.now().toIso8601String(),
            cancreatemusteri: true,
            caneditprofil: true,
            caneditstock: true,
            canseecarihereketrapor: true,
            canseehesabatscreen: true,
            canseemusterilerscreen: true,
            canseeprofilscreen: true,
            canseesatishereketrapor: true,
            canseestockhereketrapor: true,
            companiname: _kompani.text,
            istifadehuququ: true,
            satisedebilsin: true,
            satisscreengorsun: true,
            stockscreengorsun: true,
            telefonnom: phoneNumber.toString(),
            userlogged: true,
            username: _adsoyad.text,
            vezife: "admin",
            yenimehsulyaratsin: true,
            downloadedebilsin: true,
            syncedebilsin: true);
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Request_OTP(phoneNumber: phoneNumber, modelUser: modelUser,verificationId: _verificationId,)));
      });
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: "+994" + _phoneNo,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      print(e.toString());
    //  showToast('Failed to Verify Phone Number: $e', Colors.red);
    }
  }
}

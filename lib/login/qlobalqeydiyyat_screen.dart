import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:tunaf_country_code/country_code_picker.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';
import 'package:zs_satis/custom_alert.dart';
import 'package:zs_satis/esas_sehfe/screen/screen_esassehfe.dart';
import 'package:zs_satis/login/model_user.dart';
import 'package:zs_satis/preff/user_reference.dart';

import 'request_otp.dart';

class QlobalQeydiyyatScreen extends StatefulWidget {
  const QlobalQeydiyyatScreen({Key? key}) : super(key: key);

  @override
  _QlobalQeydiyyatScreenState createState() => _QlobalQeydiyyatScreenState();
}

class _QlobalQeydiyyatScreenState extends State<QlobalQeydiyyatScreen> {
  ModelUser? modelUser;
  final TextEditingController _adsoyad = TextEditingController();
  var phoneNumber;
  var selectedcontrycode = "+994";
  bool codeselected=false;

  @override
  void initState() {
    userRefCagir();
    // TODO: implement initState
    super.initState();
  }

  Future userRefCagir() async {
    await UsersReferanc.instance.createPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.white24,
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 20),
                FadeInDown(
                  duration: Duration(seconds: 1),
                  child: Image.asset(
                    "images/global_ferdi.png",
                    fit: BoxFit.cover,
                    height: 100,
                  ),
                ),
                SizedBox(height: 30),
                FadeInDown(
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1300),
                  child: Text(
                    Shablomsozler().basliqferdionline,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10),
                FadeInDown(
                  delay: Duration(milliseconds: 800),
                  duration: Duration(milliseconds: 1300),
                  child: Text(
                    Shablomsozler().otp,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 50),
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
                SizedBox(height: 50),
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             Request_OTP(phoneNumber: phoneNumber)));
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
      ),
    );
  }

  _savemodeltoFirebase() {
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
        companiname: _adsoyad.text,
        istifadehuququ: true,
        satisedebilsin: true,
        satisscreengorsun: true,
        stockscreengorsun: true,
        telefonnom: "unneeded",
        userlogged: true,
        username: _adsoyad.text,
        vezife: "admin",
        yenimehsulyaratsin: true,
        downloadedebilsin: false,
        syncedebilsin: false);
    UsersReferanc.instance.storeUserData(modelUser);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ScreenEsasSehfe(
              user: modelUser,
            )));
  }
}

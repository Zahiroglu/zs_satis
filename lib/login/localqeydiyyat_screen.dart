import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';
import 'package:zs_satis/esas_sehfe/screen/screen_esassehfe.dart';
import 'package:zs_satis/login/model_user.dart';
import 'package:zs_satis/preff/user_reference.dart';

class LocalQeydiyyatScreen extends StatefulWidget {
  const LocalQeydiyyatScreen({Key? key}) : super(key: key);

  @override
  _LocalQeydiyyatScreenState createState() => _LocalQeydiyyatScreenState();
}

class _LocalQeydiyyatScreenState extends State<LocalQeydiyyatScreen> {
  ModelUser? modelUser;
  final TextEditingController _adsoyad = TextEditingController();

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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              FadeInDown(
                duration: Duration(seconds: 1),
                child: Image.asset(
                  "images/local_phone.png",
                  fit: BoxFit.fill,
                  height: 150,
                ),
              ),
              SizedBox(height: 20),
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
                  Shablomsozler().teliniziyazin,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  FadeInDown(
                    delay: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 1300),
                    child: Container(padding: const EdgeInsets.symmetric(
                          vertical: 10),
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
                          prefixIcon: Icon(Icons.person_outline_outlined,),
                            hintText: 'Ad və soyadınızı daxil edın...',
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
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FadeInDown(
                    delay: Duration(milliseconds: 800),
                    duration: Duration(milliseconds: 1300),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Colors.green, padding: EdgeInsets.all(5),
                          elevation: 10,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        onPressed: () {
                          _savemodeltoFirebase();
                        },
                        child: Text("Hesab yarat")),
                  ),
                ],
              )
            ],
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

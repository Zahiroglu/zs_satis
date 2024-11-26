import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constandlar/app_theme.dart';
import '../constandlar/sablom_suzler.dart';
import '../constandlar/size_config.dart';
import '../preff/user_reference.dart';
import 'model_user.dart';

class UserTapildi extends StatefulWidget {
  String userid;

  UserTapildi({required this.userid, Key? key}) : super(key: key);

  @override
  _UserTapildiState createState() => _UserTapildiState();
}

class _UserTapildiState extends State<UserTapildi> {
  late ModelUser modelUser;
  late bool melumattapildi = false;
  late bool ishover = false;
  bool icazevar = false;

  @override
  void initState() {
    userRefCagir();
    _getAllUserData(widget.userid);
    // TODO: implement initState
    super.initState();
  }

  Future userRefCagir() async {
    await UsersReferanc.instance.createPref();
  }

  Future _getAllUserData(String userid) async {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(userid)
        .get()
        .then((data) {
      if (data.exists) {
        setState(() {
          // melumattapildi = true;
          // modelUser = ModelUser(
          //   userId: data['userId'],
          //   userName: data['userName'],
          //   userPhone: data['userPhone'],
          //   userSirket: data['userSirket'],
          //   userRegion: data['userRegion'],
          //   userSobe: data['userSobe'],
          //   userVezife: data['userVezife'],
          //   userTemsilcikodu: data['userTemsilcikodu'],
          //   userMaliyyebaglanti: data['userMaliyyebaglanti'],
          //   userCrmbaglanti: data['userCrmbaglanti'],
          //   userBmbaglanti: data['userBmbaglanti'],
          //   userStbaglanti: data['userStbaglanti'],
          //   userLisenziya: data['userLisenziya'],
          //   userIzlemeGiris: data['userIzlemeGiris'],
          //   userIzlemeFull: data['userIzlemeFull'],
          //   userYetkiler: data['userYetkiler'],
          // );
          // icazevar = modelUser.userLisenziya!;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: AppTheme.bacgroundgradient,
            ),
            child: melumattapildi
                ? Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(top: SizeConfig.screenHeight!*0.05),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  Stack(children: [
                                    Opacity(
                                        child: Image.asset('images/zs5.png',
                                            color: Colors.black,
                                            height: SizeConfig.screenHeight! * 0.21,
                                            width: SizeConfig.screenWidth! * 0.35),
                                        opacity: 0.4),
                                    ClipRect(
                                        child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 2.0, sigmaY: 2.0,tileMode: TileMode.clamp),
                                            child: Image.asset('images/zs5.png',
                                                height: SizeConfig.screenHeight! *
                                                        0.2,
                                                width: SizeConfig.screenWidth! * 0.35)))
                                  ]),
                                  Text(
                                    Shablomsozler().appname,
                                    style: TextStyle(
                                        fontSize: SizeConfig.textsize20SP,
                                        wordSpacing: 2,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 2),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(15)),
                                color: Colors.white.withOpacity(0.4),
                              ),
                              child: userMelumatlar(context),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Column(
                            children: [
                              icazevar
                                  ? customButton(
                                      context,
                                      _qeydiyyatadavamet,
                                      true,
                                      modelUser.username! + "",
                                      Icons.arrow_forward_ios)
                                  : customButton(context, _yenidenYoxla, true,
                                      Shablomsozler().tekrarYoxla, Icons.refresh),
                              const SizedBox(
                                height: 15.0,
                              ),
                              customButton(context, _yeniQeydiyyatEt, false,
                                  Shablomsozler().profilyarat, Icons.person_add),
                            ],
                          )
                        ],
                      ),
                    ],
                  )
                : const SpinKitCircle(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  void _qeydiyyatadavamet() {
    UsersReferanc.instance.storeUserData(modelUser);
  }

  void _yeniQeydiyyatEt() {
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (context) => AuthScreen()));
  }

  void _yenidenYoxla() {
    setState(() {
      melumattapildi = false;
      _getAllUserData(widget.userid);
    });
  }

  Material customButton(BuildContext context, void Function() qeydiyyatadavamet,
      davamet, text, icon) {
    SizeConfig().init(context);
    return Material(
      color: Colors.transparent,
      child: Ink(
        width: SizeConfig.screenWidth! * 0.8,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: davamet ? Colors.green : Colors.transparent,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: InkWell(
          splashColor: Colors.black,
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: davamet ? Colors.white : Colors.black,
                            fontSize: SizeConfig.textsize18SP,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Icon(icon,
                    color: davamet
                        ? Colors.white.withOpacity(1)
                        : Colors.black.withOpacity(1)),
              ],
            ),
          ),
          onTap: qeydiyyatadavamet,
          onHover: (value) {
            setState(() {
              ishover = value;
            });
          },
        ),
      ),
    );
  }

  Column userMelumatlar(BuildContext context) {
    SizeConfig().init(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Text(
                Shablomsozler().adsoyad,
                style:  TextStyle(fontSize: SizeConfig.textsize14SP, letterSpacing: 0.3),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                modelUser.username!.toUpperCase(),
                style: AppTheme.title,
              )
            ],
          ),
        ),
        const Divider(height: 2, color: Colors.white),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Text(
               "Sirket adi",
                style:  TextStyle(fontSize: SizeConfig.textsize14SP, letterSpacing: 0.3),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Sirket ati",
                style: AppTheme.title,
              )
            ],
          ),
        ),
        const Divider(height: 2, color: Colors.white),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
               Text(
                Shablomsozler().vezifeadi,
                style: TextStyle(fontSize: SizeConfig.textsize14SP, letterSpacing: 0.3),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                modelUser.vezife!.toUpperCase(),
                style: AppTheme.title,
              )
            ],
          ),
        ),
        const Divider(height: 2, color: Colors.white),
        // Padding(
        //   padding: const EdgeInsets.only(top: 10.0, left: 20),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     children: [
        //        Text(
        //         Shablomsozler().temkodu,
        //         style: TextStyle(fontSize: SizeConfig.textsize14SP, letterSpacing: 0.3),
        //       ),
        //       const SizedBox(
        //         width: 8,
        //       ),
        //       Text(
        //         modelUser.userTemsilcikodu!,
        //         style: AppTheme.title,
        //       )
        //     ],
        //   ),
        // ),
        const Divider(height: 5, color: Colors.white),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                  Shablomsozler().lisenziya,
                style: TextStyle(fontSize: SizeConfig.textsize18SP, letterSpacing: 0.3),
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                modelUser.istifadehuququ! ? Shablomsozler().huquqvar :Shablomsozler().huquqyoxdu,
                style: TextStyle(
                    color: modelUser.istifadehuququ! ? Colors.green : Colors.red,
                    fontSize: SizeConfig.textsize18SP,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              )
            ],
          ),
        ),
        const Divider(height: 2, color: Colors.white),
      ],
    );
  }
}

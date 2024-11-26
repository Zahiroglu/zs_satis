import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zs_satis/constandlar/app_theme.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/esas_sehfe/Drawer_menu/esas_screen_drawer.dart';
import 'package:zs_satis/login/model_user.dart';
import '../../clipper.dart';
import '../enum_drawerIndex.dart';

class ScreenEsasSehfe extends StatefulWidget {
  ModelUser user;
   ScreenEsasSehfe({Key? key,required this.user}) : super(key: key);

  @override
  _ScreenEsasSehfeState createState() => _ScreenEsasSehfeState();
}

class _ScreenEsasSehfeState extends State<ScreenEsasSehfe> {
  List<ButtonList>? buttonList;
  List<String>? endirilmelerList;
  String username = "Yoxdur";
  String vezife = "Yoxdur";
  ModelUser? modelUser;

  @override
  void initState() {
    modelUser=widget.user;
    // TODO: implement initState
    super.initState();
  }


  void setButtonListArray() {
    buttonList = [];
    if(modelUser!.satisscreengorsun!) {
      ButtonList button = ButtonList(
        index: DrawerIndex.Satis,
        labelName: Shablomsozler().satiset,
        color: Colors.red,
        imageName: "images/sales.png",
        isAssetsImage: true,
      );
      buttonList!.add(button);
    }
    if(modelUser!.stockscreengorsun!) {
      ButtonList button_anbar = ButtonList(
        index: DrawerIndex.Stock,
        labelName: Shablomsozler().anbar,
        color: Colors.lightBlue,
        imageName: "images/warehouse.png",
        isAssetsImage: true,);
      buttonList!.add(button_anbar);
    }
    if(modelUser!.canseemusterilerscreen!) {
      ButtonList bt_musteriler = ButtonList(
        index: DrawerIndex.Musteriler,
        color: Colors.green,
        labelName: Shablomsozler().musteriler,
        imageName: "images/users.png",
        isAssetsImage: true,);
      buttonList!.add(bt_musteriler);
    }
    if(modelUser!.canseehesabatscreen!) {
      ButtonList bt_hesabat = ButtonList(
        index: DrawerIndex.Hesabat,
        labelName: Shablomsozler().hesabat,
        color: Colors.lightBlue,
        imageName: "images/forecast.png",
        isAssetsImage: true,);
      buttonList!.add(bt_hesabat);
    }
    if(modelUser!.canseeprofilscreen!) {
      ButtonList bt_hesabim = ButtonList(
        index: DrawerIndex.Hesabim,
        labelName: Shablomsozler().prifil,
        color: Colors.yellow,
        imageName: "images/profile.png",
        isAssetsImage: true,);
      buttonList!.add(bt_hesabim);
    }
    if(modelUser!.vezife=="admin"&&modelUser!.downloadedebilsin!) {
      ButtonList bt_isciler= ButtonList(
        index: DrawerIndex.Isciler,
        labelName: Shablomsozler().isciler,
        color: Colors.red,
        imageName: "images/employee.jpg",
        isAssetsImage: true,);
      buttonList!.add(bt_isciler);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    setButtonListArray();
    String cihaznovu = SizeConfig.screenSize!;
    return buildMaterial_mobile();
  }


  Material buildMaterial_mobile() {
    return Material(
      child: Center(
        child: Container(
            padding: const EdgeInsets.only(left: 10,top: 10),
            alignment: Alignment.bottomCenter,
            decoration:
                const BoxDecoration(gradient: AppTheme.bacgroundgradient),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30,bottom: 2),
                      height: SizeConfig.screenHeight! * 0.08,
                      width: SizeConfig.screenWidth! * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'images/zs5.png',
                              width: SizeConfig.screenWidth! / 10,
                              height: SizeConfig.screenHeight! / 6,
                              alignment: Alignment.center,
                            ),
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth! * 0.1,
                          ),
                          Center(
                              child: Text(
                            Shablomsozler().esas,
                            style: TextStyle(
                                fontSize: SizeConfig.textsize30SP,
                                letterSpacing: 2),
                          )),
                        ],
                      ),
                    ),
                    Positioned(
                      width: MediaQuery.of(context).size.width * 0.05,
                      height: MediaQuery.of(context).size.width * 0.05,
                      bottom: MediaQuery.of(context).size.height * 0.046,
                      left: MediaQuery.of(context).size.width * 0.15,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      width: MediaQuery.of(context).size.width * 0.02,
                      height: MediaQuery.of(context).size.width * 0.02,
                      top: MediaQuery.of(context).size.height * 0.08,
                      left: MediaQuery.of(context).size.width * 0.15,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                           const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: buttonList!.isEmpty ? 0 : buttonList!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return inkwell_mobile(buttonList![index]);
                      }),
                ),
                Expanded(
                  child: Align(
                    child: ClipPath(
                      child: Container(
                        color: Colors.white,
                        height: 300.0,
                      ),
                      clipper: BottomWaveClipper(),
                    ),
                    alignment: Alignment.bottomCenter,
                  ),
                )

              ],
            )),
      ),
    );
  }

  Widget inkwell_mobile(ButtonList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.red.withOpacity(0.8),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index, listData.labelName);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 2.5,
                  color: Colors.white38,
                  offset: Offset(6, 6),
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 5,),
                  listData.isAssetsImage?
                  Container(
                    height: SizeConfig.widgethundurluk01,
                    width: SizeConfig.widgethundurluk01,
                    child: Image.asset(
                      listData.imageName,
                    color: listData.color,
                    width: SizeConfig.widgethundurluk01,
                    height: SizeConfig.widgethundurluk01,
                    fit: BoxFit.fill,),
                  ):Icon(listData.icon!.icon,size: SizeConfig.screenWidth!*0.15,color: listData.color,),
                  SizedBox(height: 5,),
                  Text(listData.labelName,style: TextStyle(fontSize: SizeConfig.textsize14SP),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void navigationtoScreen(param, String labelName) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EsasScreen(
              indexsecilen: param,
            )));
  }
}

class ButtonList {
  ButtonList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.color,
    this.index,
    this.imageName = '',
    this.isvisible = false,
  });

  String labelName;
  Icon? icon;
  Color? color;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
  bool? isvisible;
}

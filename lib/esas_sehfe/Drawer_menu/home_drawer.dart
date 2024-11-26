import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zs_satis/constandlar/app_theme.dart';
import 'package:zs_satis/constandlar/sablom_suzler.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/preff/user_reference.dart';
import '../../main.dart';
import '../controller_menular.dart';
import '../enum_drawerIndex.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key? key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);
  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList>? drawerList;
  String vezife = "Rut";

  @override
  void initState() {
    userRefCagir();
    setDrawerListArray();
    // ModelUserYetkiler _modelUserYetkiler=ModelUserYetkiler.fromJson(widget.modelUser.userYetkiler);
    super.initState();
  }

  Future userRefCagir() async {
   // await UsersReferanc.instance.createPref();
  }


  void setDrawerListArray() {
    drawerList = [];
    DrawerList button = DrawerList(
      index: DrawerIndex.Satis,
      labelName: Shablomsozler().satiset,
      //icon: Icon(Icons.receipt),
      imageName: "images/sales.png",
      isAssetsImage: true,
    );
    drawerList!.add(button);

    DrawerList button_anbar = DrawerList(
      index: DrawerIndex.Stock,
      labelName: Shablomsozler().anbar,
      imageName: "images/warehouse.png",
      isAssetsImage: true,
    );
    drawerList!.add(button_anbar);

    DrawerList bt_musteriler = DrawerList(
      index: DrawerIndex.Musteriler,
      labelName: Shablomsozler().musteriler,
      imageName: "images/users.png",
      isAssetsImage: true,    );
    drawerList!.add(bt_musteriler);

    DrawerList bt_hesabat = DrawerList(
      index: DrawerIndex.Hesabat,
      labelName: Shablomsozler().hesabat,
      imageName: "images/forecast.png",
      isAssetsImage: true,      );
    drawerList!.add(bt_hesabat);

    DrawerList bt_hesabim = DrawerList(
      index: DrawerIndex.Hesabim,
      labelName: Shablomsozler().prifil,
      icon: const Icon(Icons.account_circle),
    );
    drawerList!.add(bt_hesabim);

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
    //  backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding:  EdgeInsets.only(top: SizeConfig.screenHeight!*0.03),
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.bacgroundgradient,
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(1.0 -
                            (widget.iconAnimationController!.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                      begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(
                                      parent: widget.iconAnimationController!,
                                      curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            //height: SizeConfig.screenHeight!*0.15,
                           // width: SizeConfig.screenWidth!*0.3,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                // BoxShadow(color: AppTheme.grey.withOpacity(0.6), offset: const Offset(2.0, 4.0), blurRadius: 8),
                              ],
                            ),
                            child:  ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(60.0)),
                              //  child: Image.asset('assets/images/userImage.png'),
                              child: Icon(
                                Icons.supervised_user_circle,
                                size: SizeConfig.screenHeight!*0.1,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                   Padding(
                    padding: const EdgeInsets.only(top: 10, left: 4),
                    child: Text(
                     "Istifadeci adi",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.darkerText,
                        fontSize: SizeConfig.textsize16SP,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length??0,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title:  Text(
                  Shablomsozler().cixiset,
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.textsize16SP,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                onTap: () {
                  onTapped();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  void onTapped() {
    _showMyDialog();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(Shablomsozler().diqqet),
          content: SingleChildScrollView(
            child: ListBody(
              children:  <Widget>[
                Text(Shablomsozler().cixiucuneminsiz),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:  Text(Shablomsozler().beli),
              onPressed: () {
                UsersReferanc.instance.clearPref();
                UsersReferanc.instance.clearPref();
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyApp()));
              },
            ),
            TextButton(
              child:  Text(Shablomsozler().xeyir),
              onPressed: () {Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.blue
                                  : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon?.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue
                              : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController!.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
    this.isvisible = false,
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
  bool? isvisible;
}
import 'package:flutter/material.dart';
import 'package:zs_satis/anbar/esas_sehfeanbaranaqrup.dart';
import 'package:zs_satis/constandlar/app_theme.dart';
import 'package:zs_satis/constandlar/size_config.dart';
import 'package:zs_satis/musteriler/screen_esassehfemusteriler.dart';
import 'package:zs_satis/raporlar/screen_reporlar.dart';
import 'package:zs_satis/satis/screen_dashbordsatis.dart';
import '../enum_drawerIndex.dart';
import 'drawer_user_controller.dart';

class EsasScreen extends StatefulWidget {
  DrawerIndex indexsecilen;

  EsasScreen({required this.indexsecilen, Key? key}) : super(key: key);

  @override
  _EsasScreenState createState() => _EsasScreenState();
}

class _EsasScreenState extends State<EsasScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;
  int acilissayi = 0;

  @override
  void initState() {
    if (acilissayi == 0) {
      changeIndex(widget.indexsecilen);
    } else {
      print("2-ci acilis isledi");
      drawerIndex = drawerIndex;
      screenView = Container();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.white,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: SizeConfig.screenWidth! * 0.7,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              setState(() {
                acilissayi = acilissayi + 1;
              });
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.Satis) {
        setState(() {
          screenView = ScreenDashbordSatis();
        });
      } else if (drawerIndex == DrawerIndex.Stock) {
        setState(() {
          screenView = ScreenEsasSehfeAnbarAnaqrup();
        });
      } else if (drawerIndex == DrawerIndex.Hesabim) {
        setState(() {
          //screenView = ScreenDashbordSatis();
        });
      } else if (drawerIndex == DrawerIndex.Musteriler) {
        setState(() {
          screenView = ScreenEsasSehfeMusteriler();
        });
      } else if (drawerIndex == DrawerIndex.Hesabat) {
        setState(() {
          screenView = ScreenRaporlar();
        });
      }
    }
  }
}

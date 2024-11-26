import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zs_satis/login/model_user.dart';

class UsersReferanc {
  UsersReferanc._privatePref();

  static final UsersReferanc instance = UsersReferanc._privatePref();
  late SharedPreferences _preferences;

  Future createPref() async =>
      _preferences = await SharedPreferences.getInstance();

  Future clearPref() async {
    _preferences = await SharedPreferences.getInstance();
    _preferences.clear();
  }

  Future storeUserData(ModelUser userModel) async {
    _preferences = await SharedPreferences.getInstance();
    setId(userModel.id!);
    setUsername(userModel.username!);
    setTelefonnom(userModel.telefonnom!);
    setCompaniname(userModel.companiname!);
    setVezife(userModel.vezife!);
    setQeydiyyattarixi(userModel.qeydiyyattarixi!);
    setSonaktivlik(userModel.sonaktivlik!);
    setIstifadehuququ(userModel.istifadehuququ!);
    setSatisscreengorsun(userModel.satisscreengorsun!);
    setSatisedebilsin(userModel.satisedebilsin!);
    setStockscreengorsun(userModel.stockscreengorsun!);
    setYenimehsulyaratsin(userModel.yenimehsulyaratsin!);
    setCaneditstock(userModel.caneditstock!);
    setCanseemusterilerscreen(userModel.canseemusterilerscreen!);
    setCancreatemusteri(userModel.cancreatemusteri!);
    setCanseehesabatscreen(userModel.canseemusterilerscreen!);
    setCanseecarihereketrapor(userModel.canseehesabatscreen!);
    setCanseestockhereketrapor(userModel.canseestockhereketrapor!);
    setCanseesatishereketrapor(userModel.canseesatishereketrapor!);
    setCanseeprofilscreen(userModel.canseeprofilscreen!);
    setCaneditprofil(userModel.caneditprofil!);
    setDownloadedebilsin(userModel.downloadedebilsin!);
    setSyncedebilsin(userModel.syncedebilsin!);
    setUserlogged(userModel.userlogged!);
  }

  Future<ModelUser?> initialGetSaved() async {
    _preferences = await SharedPreferences.getInstance();
    ModelUser user;
    if(_preferences.containsKey('key_id')){
      String id =  await UsersReferanc.instance.getId();
      String username = await UsersReferanc.instance.getUsername();
      String telefon = await UsersReferanc.instance.getTelefonnom();
      String compani = await UsersReferanc.instance.getCompaniname();
      String vezife = await UsersReferanc.instance.getVezife();
      bool userlogged=await UsersReferanc.instance.getUserlogged();
      bool syncedebilmek=await UsersReferanc.instance.getSyncedebilsin();
      bool downedebilmek=await UsersReferanc.instance.getDownloadedebilsin();
      bool yenimusteriyarat=await UsersReferanc.instance.getCancreatemusteri();
      bool musterilergormek=await UsersReferanc.instance.getCanseemusterilerscreen();
      bool stockgormek=await UsersReferanc.instance.getStockscreengorsun();
      bool satisgormek=await UsersReferanc.instance.getSatisscreengorsun();
      bool satisedebilmek=await UsersReferanc.instance.getSatisedebilsin();
      bool stokhereketgormek=await UsersReferanc.instance.getIstifadehuququ();
      bool satishereketgormek=await UsersReferanc.instance.getCanseesatishereketrapor();
      bool profilgormek=await UsersReferanc.instance.getCanseeprofilscreen();
      bool hesabatlarigormek=await UsersReferanc.instance.getCanseehesabatscreen();
      bool carihereketgormek=await UsersReferanc.instance.getCanseecarihereketrapor();
      bool stockeditetmek=await UsersReferanc.instance.getCaneditstock();
      bool profileditetmek=await UsersReferanc.instance.getCaneditprofil();
      bool musteriyaradabilmek=await UsersReferanc.instance.getCancreatemusteri();
      String qeydiyyattarixi=await UsersReferanc.instance.getQeydiyyattarixi();
      String sonaktivlik=await UsersReferanc.instance.getSonaktivlik();
      user=ModelUser(
          id: "0",
          username: username,
          telefonnom: telefon,
          companiname: compani,
          vezife: vezife,
          userlogged: userlogged,
          syncedebilsin: syncedebilmek,
          downloadedebilsin: downedebilmek,
          yenimehsulyaratsin: yenimusteriyarat,
          canseemusterilerscreen: musterilergormek,
          stockscreengorsun: stockgormek,
          satisscreengorsun: satisgormek,
          satisedebilsin: satisedebilmek,
          istifadehuququ: stokhereketgormek,
          canseestockhereketrapor: stokhereketgormek,
          canseesatishereketrapor: satishereketgormek,
          canseeprofilscreen: profilgormek,
          canseehesabatscreen: hesabatlarigormek,
          canseecarihereketrapor: carihereketgormek,
          caneditstock: stockeditetmek,
          caneditprofil: profileditetmek,
          cancreatemusteri: musteriyaradabilmek,
          qeydiyyattarixi: qeydiyyattarixi,
          sonaktivlik: sonaktivlik
      );}else{
      user=ModelUser();
    }
    return user;
  }

  ///////////////////////////////insert into///////////////////////////////////////
  Future setId(String id) async => _preferences.setString("key_id", id);

  Future setUsername(String username) async =>
      _preferences.setString("key_username", username);

  Future setTelefonnom(String telefonnom) async =>
      _preferences.setString("key_telefonnom", telefonnom);

  Future setCompaniname(String companiname) async =>
      _preferences.setString("key_companiname", companiname);
Future setVezife(String companiname) async =>
      _preferences.setString("key_vezife", companiname);

  Future setQeydiyyattarixi(String qeydiyyattarixi) async =>
      _preferences.setString("key_qeydiyyattarixi", qeydiyyattarixi.toString());

  Future setSonaktivlik(String sonaktivlik) async =>
      _preferences.setString("key_sonaktivlik", sonaktivlik.toString());

  Future setIstifadehuququ(bool istifadehuququ) async =>
      _preferences.setBool("key_istifadehuququ", istifadehuququ);

  Future setSatisscreengorsun(bool satisscreengorsun) async =>
      _preferences.setBool("key_satisscreengorsun", satisscreengorsun);

  Future setSatisedebilsin(bool satisedebilsin) async =>
      _preferences.setBool("key_satisedebilsin", satisedebilsin);

  Future setStockscreengorsun(bool stockscreengorsun) async =>
      _preferences.setBool("key_stockscreengorsun", stockscreengorsun);

  Future setYenimehsulyaratsin(bool yenimehsulyaratsin) async =>
      _preferences.setBool("key_yenimehsulyaratsin", yenimehsulyaratsin);

  Future setCaneditstock(bool caneditstock) async =>
      _preferences.setBool("key_caneditstock", caneditstock);

  Future setCanseemusterilerscreen(bool canseemusterilerscreen) async =>
      _preferences.setBool(
          "key_canseemusterilerscreen", canseemusterilerscreen);

  Future setCancreatemusteri(bool cancreatemusteri) async =>
      _preferences.setBool("key_cancreatemusteri", cancreatemusteri);

  Future setCanseehesabatscreen(bool canseehesabatscreen) async =>
      _preferences.setBool("key_canseehesabatscreen", canseehesabatscreen);

  Future setCanseecarihereketrapor(bool canseecarihereketrapor) async =>
      _preferences.setBool(
          "key_canseecarihereketrapor", canseecarihereketrapor);

  Future setCanseestockhereketrapor(bool canseestockhereketrapor) async =>
      _preferences.setBool(
          "key_canseestockhereketrapor", canseestockhereketrapor);

  Future setCanseesatishereketrapor(bool canseesatishereketrapor) async =>
      _preferences.setBool(
          "key_canseesatishereketrapor", canseesatishereketrapor);

  Future setCanseeprofilscreen(bool canseeprofilscreen) async =>
      _preferences.setBool("key_canseeprofilscreen", canseeprofilscreen);

  Future setCaneditprofil(bool caneditprofil) async =>
      _preferences.setBool("key_caneditprofil", caneditprofil);

  Future setDownloadedebilsin(bool downloadedebilsin) async =>
      _preferences.setBool("key_downloadedebilsin", downloadedebilsin);

  Future setSyncedebilsin(bool syncedebilsin) async =>
      _preferences.setBool("key_syncedebilsin", syncedebilsin);

  Future setUserlogged(bool userlogged) async =>
      _preferences.setBool("key_userlogged", userlogged);

  ////////////////////////////get info//////////////////////////////////////////////
  Future getId() async => _preferences.getString("key_id");

  Future getUsername() async => _preferences.getString("key_username");

  Future getTelefonnom() async => _preferences.getString("key_telefonnom");

  Future getCompaniname() async => _preferences.getString("key_companiname");
  Future getVezife() async => _preferences.getString("key_vezife");

  Future getQeydiyyattarixi() async =>
      _preferences.getString("key_qeydiyyattarixi");
  Future getSonaktivlik() async =>
      _preferences.getString("key_sonaktivlik");

  Future getIstifadehuququ() async =>
      _preferences.getBool("key_istifadehuququ");

  Future getSatisscreengorsun() async =>
      _preferences.getBool("key_satisscreengorsun");

  Future getSatisedebilsin() async =>
      _preferences.getBool("key_satisedebilsin");

  Future getStockscreengorsun() async =>
      _preferences.getBool("key_stockscreengorsun");

  Future getYenimehsulyaratsin() async =>
      _preferences.getBool("key_yenimehsulyaratsin");

  Future getCanseemusterilerscreen() async =>
      _preferences.getBool("key_canseemusterilerscreen");

  Future getCancreatemusteri() async =>
      _preferences.getBool("key_cancreatemusteri");

  Future getCanseehesabatscreen() async =>
      _preferences.getBool("key_canseehesabatscreen");

  Future getCanseecarihereketrapor() async =>
      _preferences.getBool("key_canseecarihereketrapor");

  Future getCanseestockhereketrapor() async =>
      _preferences.getBool("key_canseestockhereketrapor");

  Future getCanseesatishereketrapor() async =>
      _preferences.getBool("key_canseesatishereketrapor");

  Future getCanseeprofilscreen() async =>
      _preferences.getBool("key_canseeprofilscreen");

  Future getCaneditprofil() async =>
      _preferences.getBool("key_caneditprofil");

  Future getCaneditstock() async =>
      _preferences.getBool("key_caneditstock");

  Future getDownloadedebilsin() async =>
      _preferences.getBool("key_downloadedebilsin");

  Future getSyncedebilsin() async =>
      _preferences.getBool("key_syncedebilsin");

  Future getUserlogged() async => _preferences.getBool("key_userlogged");
}

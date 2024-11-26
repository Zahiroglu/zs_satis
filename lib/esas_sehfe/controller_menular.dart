import 'package:flutter/material.dart';

import 'Drawer_menu/home_drawer.dart';
import 'enum_drawerIndex.dart';

class MenuController{
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

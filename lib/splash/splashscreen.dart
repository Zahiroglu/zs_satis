import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zs_satis/esas_sehfe/screen/screen_esassehfe.dart';
import 'package:zs_satis/login/model_user.dart';
import 'package:zs_satis/preff/user_reference.dart';
import 'package:zs_satis/splash/staggeredraindropanimation.dart';
import 'holepainter.dart';
import '../login/welcome_screen.dart';

class AnimationScreen extends StatefulWidget {
  AnimationScreen({required this.color});

  final Color color;

  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with SingleTickerProviderStateMixin {
  Size size = Size.zero;
  AnimationController? _controller;
  StaggeredRaindropAnimation? _animation;
  ModelUser modelUser = ModelUser();
  bool qeydiyyatvar = false;
  bool? conn = false;
  bool statanima=false;



  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _animation = StaggeredRaindropAnimation(_controller!);
    _controller!.forward();
    _controller!.addListener(() {
      setState(() {});
    });

    super.initState();
    userRefCagir();
    getUserInfoLocal();
  }


  Future userRefCagir() async {
    await UsersReferanc.instance.createPref();
  }

  Future checkInternt() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        conn = true;
      }
    } on SocketException catch (_) {
      conn = false;
    }
    getUserInfoLocal();
  }

  Future getUserInfoLocal() async {
    modelUser = (await UsersReferanc.instance.initialGetSaved())!;
    if (modelUser.id != null) {
      if (modelUser.downloadedebilsin!) {
        if (conn = true) {
          startTime();
          //  userMelumatlariYenile(modelUser.id!);
        } else {
          setState(() {
            startTime();
          });
        }
        qeydiyyatvar = true;
      } else {
        qeydiyyatvar = true;
      }
    } else {
      qeydiyyatvar = false;
      statanima=true;
    }
    startTime();
  }

  startTime() async {
    var _duration = const Duration(milliseconds: 2500);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    if (qeydiyyatvar) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  ScreenEsasSehfe(user: modelUser,)));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const WelcomeScreen()));
    }
  }

  @override
  void didChangeDependencies() {
    setState(() {
      size = MediaQuery.of(context).size;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(children: [
        Container(
            width: double.infinity,
            height: double.infinity,
            child: CustomPaint(
                painter: HolePainter(
                    color: widget.color,
                    holeSize: _animation!.holeSize.value * size.width))),
        Positioned(
            top: _animation!.dropPosition.value * size.height,
            left: size.width / 2 - _animation!.dropSize.value / 2,
            child: SizedBox(
                width: _animation!.dropSize.value,
                height: _animation!.dropSize.value,
                child: CustomPaint(
                  painter: DropPainter(visible: _animation!.dropVisible.value),
                ))),
        Padding(
            padding: EdgeInsets.only(bottom: 200),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                    opacity: _animation!.textOpacity.value,
                    child: Container(
                      height: 250,
                      child: Column(
                        children: [
                          Image.asset(
                            "images/zs5.png",
                            height: 100,
                            width: 100,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'ZS SALES MANAGMENT',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          SpinKitCircle(color: Colors.white,)
                        ],
                      ),
                    ))))
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }
}

class DropPainter extends CustomPainter {
  DropPainter({this.visible = true});

  bool visible;

  @override
  void paint(Canvas canvas, Size size) {
    if (!visible) {
      return;
    }

    Path path = new Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(0, size.height * 0.8, size.width / 2, size.height);
    path.quadraticBezierTo(size.width, size.height * 0.8, size.width / 2, 0);
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

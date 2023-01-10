import 'dart:async';
import 'package:flutter/material.dart';
import 'package:outlead_solutions/screens/entryPoint/entry_point.dart';
import 'package:outlead_solutions/screens/onboding/onboding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  AnimationController? controller;
  Animation<double>? animation;

  @override
   initState()  {
    super.initState();
    // isConnected();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller!, curve: Curves.easeIn);
    controller!.forward();

    // callProvidersPre();
    timer();
    // callProvidersAfter();

    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen())));
  }

/*  isConnected() async{
    await execute(InternetConnectionChecker());
    WidgetsFlutterBinding.ensureInitialized();
    final InternetConnectionChecker customInstance =
    InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 1),
      checkInterval: const Duration(seconds: 1),
    );

    // Check internet connection with created instance
    await execute(customInstance);
  }

  callProvidersPre() async{
      await InitProviders().initProvider();
  }

  callProvidersAfter(){
     InitProviders().initProviderAfter();
  }*/

  dispose() {
    controller!.dispose();
    super.dispose();
  }

  Future<void> timer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    var InstituteName = prefs.getString('InstituteName');
    var InstituteLogo = prefs.getString('InstituteLogo');

    if((InstituteName != null) && (InstituteLogo != null) && (username != null)){
/*      callProvidersPre();
      callProvidersAfter();*/
    }

    /*print(username);
    print(InstituteName);
    print(InstituteLogo);*/

    Timer(Duration(seconds: 1), () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) =>
        (username == null)? OnbodingScreen() : EntryPoint()))
/*        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) =>
        ((InstituteName == null) || (InstituteLogo == null) || (username == null)) ? prepSeed_login() :
        (username == null || username == '') ? signIn_signUp(clientname: InstituteName,clientlogo: InstituteLogo,) :
        landingScreen()  ))*/
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        // color: Constants.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                    scale: animation!,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:[
                          Image.asset('assets/Backgrounds/Spline.png',fit: BoxFit.cover,)
                        ]
                    )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
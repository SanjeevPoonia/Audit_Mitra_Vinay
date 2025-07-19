import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:qaudit_tata_flutter/view/update_app_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qaudit_tata_flutter/utils/app_modal.dart';
import 'package:qaudit_tata_flutter/view/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
/*
void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}
*/

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token=prefs.getString('auth_key')??'';
  String? userID=prefs.getString('user_id')??'';
  print(token);
   if(token!='')
   {
     print("Test");
     AppModel.setTokenValue(token.toString());
     AppModel.setUserID(userID);
   }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.black,
  ));

  await Firebase.initializeApp();


  runApp( MyApp(token.toString()));
}


class MyApp extends StatefulWidget
{
  final String token;
  MyApp(this.token);
  MyAppState createState()=>MyAppState(token);
}



class MyAppState extends State<MyApp> {
  final String token;
  MyAppState(this.token);
  final _noScreenshot = NoScreenshot.instance;




  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audit Mitra',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home:FutureBuilder(
          future: checkUpdateRequired(context),
          builder: (context,snapshot)
          {
            if (snapshot.connectionState != ConnectionState.done)
              return Container(
                color: Colors.white,
              );
            else if (snapshot.connectionState==ConnectionState.done && snapshot.data==true)
              return UpdateAppScreen();
            else
              return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child:

                  SplashScreen(token)
              );
            // return main screen here
          }

      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    disableScreenshot();

  }

  disableScreenshot() async {
    bool result = await _noScreenshot.screenshotOff();
    debugPrint('Screenshot Off: $result');
  }

  Future<bool>checkUpdateRequired(BuildContext context) async {
    bool updateRequired=false;
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    print("USER APP VERSION");
    print(version);

    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 12),
      minimumFetchInterval: const Duration(seconds: 1),
    ));
    /* await remoteConfig.setDefaults(<String, dynamic>{
      'android_version': '1.0.1',
      'ios_version': '1.71'
    });*/
    //RemoteConfigValue(RemoteConfigValue, ValueSource.valueStatic);

    await remoteConfig.ensureInitialized();
    await remoteConfig.fetchAndActivate();
    print('SERVER VERSION');
    print(remoteConfig.getString('android_version'));
    print(remoteConfig.getString('ios_version'));

    String versionName;
    if(Platform.isIOS)
    {
      versionName=remoteConfig.getString('ios_version');
    }
    else
    {
      versionName=remoteConfig.getString('android_version');
    }
    print('sfwfwf');

    print(versionName);

    int userAppVersion = getExtendedVersionNumber(version); // return 10020003
    int storeAppVersion = getExtendedVersionNumber(versionName); // return 10020011


    if(userAppVersion<storeAppVersion)
    {
      print('UPDATE FOUND');
      updateRequired=true;
    }
    else
    {
      print('NO UPDATE');
      updateRequired=false;
    }
    return updateRequired;
  }


  int getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

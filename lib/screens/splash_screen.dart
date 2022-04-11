import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../components/loading_widget.dart';
import '../system/constants.dart' as constants;

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<String> policy;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  late Future<String> ip;

  bool connected = false, logged = false;

  late String thePolicy, theLegal;

  late bool firstOpen;

  Future<void> _checkConnected() async {
    await (Connectivity().checkConnectivity()).then((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        connected = true;
      } else if (result == ConnectivityResult.wifi) {
        connected = true;
      } else {
        connected = false;
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text('Sin internet'),
                  content: const Text(
                      'Disculpe las molestias, la APP de Comunica Ideal necesita oblicatoriamente el uso de internet, por favor activelo para poder entrar en la aplicación.'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("Vale"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      },
                    )
                  ],
                ));
      }
    }).then((_) {
      _checkLastLogin();
    });
  }

  Future<void> _checkLastLogin() async {

  }

  Future<void> _checkFirstOpen() async {
    firstOpen = false;
    //TODO comprobar primer inicio
    _checkConnected();
  }

  AlertDialog Function(BuildContext context) _alertDialog(String message) {
    return (BuildContext context) => AlertDialog(
          title: null,
          content: SingleChildScrollView(
              child: HtmlWidget(
                  message
              )),
          contentPadding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          actions: <Widget>[
            TextButton(
              child: const Text('Volver'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: Future.wait([Future.delayed(const Duration(seconds: 3)),_checkFirstOpen()]),
          builder: (BuildContext context, AsyncSnapshot<List<void>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (kDebugMode) {
                print("Done fetchs");
              }

              if (connected && logged && !firstOpen) {
                if (kDebugMode) {
                  print("connected && policyAccept && loggeds");
                }
                // Entro normal
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed(HomeScreen.routeName, arguments: "smart home");
                });
              } else if (connected && !logged && !firstOpen) {
                if (kDebugMode) {
                  print("connected && !logged && !firstOpen");
                }
                // Voy al logins
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/login');
                });
              } else if (!connected) {
                if (kDebugMode) {
                  print("!connected");
                }
                // Muestro que encienda el wifi.
              } else if (firstOpen) {
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  Navigator.of(context).pushReplacementNamed('/intro');
                });
              }
            }
            return Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/logo.png'),
                  const LoadingWidget(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

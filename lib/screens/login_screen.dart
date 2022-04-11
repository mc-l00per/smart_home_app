import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/api.dart' as api;
import '../system/constants.dart' as constants;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores del estado de los textField
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  late String _token, _tokenInstance;
  late String _menu;

  bool rememberMe = false;

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  late IosDeviceInfo iosInfo;

  bool _obscureText = true;

  bool showEye = false;

  void _fetchInfoDevice() async {
    if (Platform.isAndroid) {
      api.androidInfo = await deviceInfo.androidInfo;
    } else {
      api.iosDeviceInfo = await deviceInfo.iosInfo;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchInfoDevice();
    api.fetchInstanceToken();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      cursorColor: Colors.black,
      style: TextStyle(color: Colors.black),
      autocorrect: false,
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      onTap: () {
        print("TAP email");
        setState(() {
          showEye = false;
        });
      },
      decoration: InputDecoration(
          labelText: "Email",
          prefixIcon: Icon(
            Icons.account_circle,
            size: 30,
          ),
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      controller: emailTextController,
    );

    void _toggle() {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    final passwordField = TextField(
      obscureText: _obscureText,
      cursorColor: Colors.black,
      style: const TextStyle(color: Colors.black),
      onTap: () {
        if (kDebugMode) {
          print("TAPP");
        }
        setState(() {
          showEye = true;
        });
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        labelText: "Password",
        suffixIcon: Visibility(
          visible: showEye,
          child: IconButton(
            onPressed: () => _toggle(),
            icon: const Icon(Icons.remove_red_eye, color: constants.primaryMaterial),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      controller: passwordTextController,
    );

    final loginButton = Material(
      elevation: 1.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.grey[300],
      child: MaterialButton(
          elevation: 1,
          padding: const EdgeInsets.fromLTRB(40.0, 15.0, 40.0, 15.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          splashColor: Colors.white,
          color: constants.primary[900],
          onPressed: () {
            api.submitLogin({
              'email': emailTextController.text,
              'password': passwordTextController.text,
              /*'brand': api.androidInfo == null ? api.iosDeviceInfo.systemName : api.androidInfo.brand,
              'model': api.androidInfo == null ? api.iosDeviceInfo.localizedModel : api.androidInfo.model,
              'id_device': api.androidInfo == null ? api.iosDeviceInfo.identifierForVendor : api.androidInfo.androidId,
              'instance_token': api.instance_token,*/
              'remember_me': rememberMe.toString(),
            }, context);
          },
          child: const Text(
            "INICIAR SESIÓN",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          )),
    );

    final resetPasswordButton = Container(
      margin: const EdgeInsets.all(10),
      height: 40.0,
      child: InkWell(
        child: const Center(
          child: Text(
            '¿Has olvidado la contraseña?',
            textAlign: TextAlign.center,
            style: TextStyle(decoration: TextDecoration.underline, color: Colors.black),
          ),
        ),
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(context, '/reset', (_) => false);
        },
      ),
    );

    void _onRememberMeChanged(bool? newValue) {
      return setState(() {
        rememberMe = newValue!;
        if (rememberMe) {
          // TODO: Here goes your functionality that remembers the user.
        } else {
          // TODO: Forget the user
        }
      });
    }

    Widget rememberPassword = Flexible(
      child: CheckboxListTile(
        title: const Text("Recordarme"),
        value: rememberMe,
        onChanged: _onRememberMeChanged,
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: 800,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      "assets/logo.png",
                    ),
                    emailField,
                    passwordField,
                    Row(
                      children: <Widget>[
                        rememberPassword,
                      ],
                    ),
                    loginButton,
                    resetPasswordButton,
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

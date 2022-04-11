library api;

import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as https;
import '../system/constants.dart' as constant;

late String bearerToken;
late String instanceToken;

late AndroidDeviceInfo androidInfo;
late IosDeviceInfo iosDeviceInfo;

// **** Firebase instancia para mensajeria push ***/

void initFCM() {

}

Future<void> fetchInstanceToken() async {

}

///////////////////////////////////////////////////////////////////////////////

/*void checkResponse(section, Response response, context) {
  print(" Response API: " +
      jsonDecode(utf8.decode(response.bodyBytes)).toString());
  print(response.statusCode);

  if (response.statusCode >= 300) {
    AlertdialogWidget alert = AlertdialogWidget(
        jsonDecode(utf8.decode(response.bodyBytes)).toString());

    showDialog(context: context, builder: (context) => alert);
  } else if (response.statusCode == 203) {
    Widget alert = AlertDialog(
      title: Text(
        jsonDecode(utf8.decode(response.bodyBytes)).toString(),
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Vale"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(context: context, builder: (context) => alert);
  } else {
    print("Goog response");
  }
}*/

////////////////////////////////////////////////////////////////////////////////
/// Login

void submitLogin(Map<String, String> data, context) async {
  if (kDebugMode) {
    print(data);
  }

  final response = await https.post(constant.loginRoute, headers: {
    "Accept": "application/json",
  }, body: {
    "email": data['email'],
    "password": data['password'],
    "id_device": data['id_device'],
    "instance_token": data['instance_token'],
  });

  if (kDebugMode) {
    print(response.body);
  }

  // checkResponse('submitLogin', response, context);

  if (data['remember_me'] == "true") {
    saveLogging(jsonDecode(response.body)['bearer_token'], context);
  } else {
    allowLogging(jsonDecode(response.body)['bearer_token'], context);
  }
}

void saveLogging(String token, context) {
  bearerToken = token;
  if (token.isNotEmpty) {
    /*Prefs.setString('bearer_token', bearer_token)
        .then((value) => print("GUARDADO"))
        .catchError((onError) => print(onError));
    checkPrivacy(context);*/
  }
}

/*void removeSession(context, data) async {
  if (kDebugMode) {
    print(data);
  }

  final response = await http.post(Constants.LOGOUT_ROUTE, headers: {
    "Accept": "application/json",
    "Authorization": "Bearer " + bearerToken
  }, body: {
    "instance_token": data['instance_token'],
  });

  if (kDebugMode) {
    print(response.body);
  }

  checkResponse('removeSession', response, context);
}

void checkPrivacy(context) {
  getLastPrivacy(context, {}).then((thePolicy) {
    if (jsonDecode(thePolicy)['status'] == 'Accept' && bearer_token.isEmpty) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    } else if (jsonDecode(thePolicy)['status'] == 'Accept' &&
        bearer_token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, DashboardScreen.routeName,
          arguments: MenuArguments('Inicio', -1, -1));
    } else {
      dynamic defaultAuthorizations = new List<Authorization>();
      defaultAuthorizations.add(new Authorization(
          id: 1,
          name: "¿Deseas recibir notificaciones PUSH?",
          authorized: true));
      defaultAuthorizations.add(new Authorization(
          id: 2,
          name: "¿Deseas recibir notificaciones por EMAIL?",
          authorized: false));

      Privacy privacy = Privacy.fromRawJson(thePolicy);

      Widget alert = AlertDialog(
        title: const Text("Política de privacidad"),
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            const TextSpan(
                text: 'Al hacer click en "confirmar" aceptará ',
                style: TextStyle(color: Colors.black)),
            TextSpan(
                text: 'los términos de uso',
                style: const TextStyle(
                    color: constant.PRIMARY_MATERIAL,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    var alertText = (BuildContext context) => AlertDialog(
                          title: Text('Terminos de uso - Comunica Ideal'),
                          contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          content: Container(
                              child: SingleChildScrollView(
                                  child: Html(
                            data: privacy.legal,
                            padding: EdgeInsets.all(8.0),
                            defaultTextStyle: const TextStyle(fontSize: 18),
                            //Must have useRichText set to false for this to work
                            customRender: (node, children) {
                              if (node is dom.Element) {
                                switch (node.localName) {
                                  case "custom_tag":
                                    return Column(children: children);
                                }
                              }
                              return null;
                            },
                            customTextStyle:
                                (dom.Node node, TextStyle baseStyle) {
                              if (node is dom.Element) {
                                switch (node.localName) {
                                  case "li":
                                    print("li detectado");
                                    return baseStyle.merge(
                                        TextStyle(height: 2, fontSize: 18));
                                }
                              }
                              return baseStyle;
                            },
                          ))),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Volver'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                    showDialog(builder: alertText, context: context);
                  }),
            TextSpan(text: ' y ', style: TextStyle(color: Colors.black)),
            TextSpan(
                text: 'aviso de privacidad',
                style: TextStyle(
                    color: PRIMARY_MATERIAL,
                    decoration: TextDecoration.underline),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    var alertText = (BuildContext context) => AlertDialog(
                          title:
                              Text('Politica de privacidad - Comunica Ideal'),
                          contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          content: Container(
                              child: SingleChildScrollView(
                                  child: Html(
                            data: privacy.policy,
                            imageProperties: ImageProperties(
                              height: 300,
                              matchTextDirection: false,
                            ),
                            padding: EdgeInsets.all(8.0),
                            defaultTextStyle: const TextStyle(fontSize: 11),
                            linkStyle: const TextStyle(
                              color: PRIMARY_MATERIAL,
                              decorationColor: PRIMARY_MATERIAL,
                              decoration: TextDecoration.underline,
                            ),
                            onLinkTap: (url) {
                              launch(url);
                            },
                            onImageTap: (src) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        content: Image.network(
                                          src,
                                          fit: BoxFit.fill,
                                        ),
                                      ));
                              print(src);
                            },
                            //Must have useRichText set to false for this to work
                            customRender: (node, children) {
                              if (node is dom.Element) {
                                switch (node.localName) {
                                  case "custom_tag":
                                    return Column(children: children);
                                }
                              }
                              return null;
                            },
                            customTextAlign: (dom.Node node) {
                              if (node is dom.Element) {
                                switch (node.localName) {
                                  case "p":
                                    return TextAlign.justify;
                                }
                              }
                              return null;
                            },
                            customTextStyle:
                                (dom.Node node, TextStyle baseStyle) {
                              if (node is dom.Element) {
                                switch (node.localName) {
                                  case "p":
                                    return baseStyle.merge(
                                        TextStyle(height: 2, fontSize: 18));
                                }
                              }
                              return baseStyle;
                            },
                          ))),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Volver'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                    showDialog(builder: alertText, context: context);
                  })
          ]),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text("Rechazar"), onPressed: () => SystemNavigator.pop()),
          FlatButton(
            child: Text("Confirmar"),
            onPressed: () {
              GetIp.ipAddress.then((ip) {
                updateAuthorizations(context, defaultAuthorizations);
                updatePrivacy(context, {
                  'privacy_id': privacy.policyId.toString(),
                  'legal_id': privacy.legalId.toString(),
                  'ip_accept_privacy': ip
                }).then((value) {
                  if (jsonDecode(value)['status'] == 'Accept') {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacementNamed(
                          context, DashboardScreen.routeName,
                          arguments: MenuArguments('Inicio', -1, -1));
                    });
                  }
                });
              });
            },
          ),
        ],
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (dialogContext) => alert);
      });
    }
  });
}*/

void allowLogging(String token, context) {
  bearerToken = token;
  //checkPrivacy(context);
}

void requireReset(Map<String, String> data, context) async {
  if (kDebugMode) {
    print(data);
  }

  final response = await https.post(constant.resetRoute, headers: {
    "Accept": "application/json",
  }, body: {
    "email": data['email'],
  });

  if (kDebugMode) {
    print(response.body);
  }

  /*checkResponse('requireReset', response, context);*/
}

Future<String> getLastPrivacy(context, data) async {
  final response = await https.get(
    constant.loginRoute,
    headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + bearerToken
    },
  );

  if (kDebugMode) {
    print("Entry getLogin");
  }

  return response.body.toString();
}

library constants;

import 'package:flutter/material.dart';

const String applicationsIp = "my_application_id";

const String url = "https://smarthome.local";

Uri loginRoute = Uri.parse(url + "/api/login");
Uri resetRoute = Uri.parse(url + "/api/password/create");
Uri passwordRoute = Uri.parse(url + "/api/change-password");
Uri logoutRoute = Uri.parse(url + "/api/logout");

const Map<int, Color> primary = {
  50: Color.fromRGBO(152, 30, 151, .1),
  100: Color.fromRGBO(152, 30, 151, .2),
  200: Color.fromRGBO(152, 30, 151, .3),
  300: Color.fromRGBO(152, 30, 151, .4),
  400: Color.fromRGBO(152, 30, 151, .5),
  500: Color.fromRGBO(152, 30, 151, .6),
  600: Color.fromRGBO(152, 30, 151, .7),
  700: Color.fromRGBO(152, 30, 151, .8),
  800: Color.fromRGBO(152, 30, 151, .9),
  900: Color.fromRGBO(152, 30, 151, 1),
};

const Color primaryMaterial = MaterialColor(0xFF981e97, primary);

const Map<int, Color> secondary = {
  50: Color.fromRGBO(150, 148, 145, .1),
  100: Color.fromRGBO(150, 148, 145, .2),
  200: Color.fromRGBO(150, 148, 145, .3),
  300: Color.fromRGBO(150, 148, 145, .4),
  400: Color.fromRGBO(150, 148, 145, .5),
  500: Color.fromRGBO(150, 148, 145, .6),
  600: Color.fromRGBO(150, 148, 145, .7),
  700: Color.fromRGBO(150, 148, 145, .8),
  800: Color.fromRGBO(150, 148, 145, .9),
  900: Color.fromRGBO(150, 148, 145, 1),
};

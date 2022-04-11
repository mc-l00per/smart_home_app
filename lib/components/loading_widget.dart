import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../system/constants.dart' as constants;

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: const Center(
        child: SpinKitFadingFour(
          color: constants.primaryMaterial,
          shape: BoxShape.rectangle,
          size: 40.0,
        ),
      ),
    );
  }
}

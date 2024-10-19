import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hfbbank/theme/theme.dart';

class RaoLoading extends StatelessWidget {
  const RaoLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryLightVariant,
      child: Center(
        child: SpinKitSpinningLines(color: primaryColor, duration: Duration(milliseconds: 2000), size: 40,),
      ),
    );
  }
}

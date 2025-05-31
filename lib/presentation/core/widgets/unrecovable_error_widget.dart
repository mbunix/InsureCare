import 'package:autoflex/application/services/asset_strings.dart';
import 'package:autoflex/application/services/utils.dart';
import 'package:autoflex/presentation/core/theme/text_theme.dart';
import 'package:flutter/material.dart';

class UnrecovarableErrorWidget extends StatelessWidget {
  const UnrecovarableErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(errorDisplayImageUrl),
          fit: BoxFit.fitHeight,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(3, 0),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          margin: EdgeInsets.all(10),
          child: Text(
            getErrorMessage(),
            style: boldSize15Text(Colors.black87),
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
  }
}

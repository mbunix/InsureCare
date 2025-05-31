import 'package:flutter/material.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({
    super.key,
  });
  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  @override
  void initState() {
    super.initState();
    final List<String> FavouriteCountries = <String>[
      'KE',
      'UG',
      'TZ',
      'US',
      'NG',
    ];
    
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
          ),
        ),
      );
    }
  }


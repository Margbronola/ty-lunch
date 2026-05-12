// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tylunch/global/container.dart';
import 'package:tylunch/global/datacacher.dart';
import 'package:tylunch/services/api/authentication.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  final DataCacher _cacher = DataCacher.instance;
  final Authentication auth = Authentication();

  Future<void> _checker() async {
    String? d = _cacher.token;
    print("ACCESS TOKEN: $d");

    if (d == null) {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushNamed(context, '/login_page');
    } else {
      try {
        setState(() {
          accesstoken = d;
        });
        await Navigator.pushReplacementNamed(context, '/landing_page');
      } catch (e) {
        await _cacher.deleteToken();
        await Navigator.pushReplacementNamed(context, '/login_page');
        print(e);
        return;
      }
    }
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checker();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splashscreen.png',
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

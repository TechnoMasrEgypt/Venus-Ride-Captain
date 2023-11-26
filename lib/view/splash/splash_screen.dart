import 'dart:async';
import 'package:flutter/material.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/view/auth/presentation/screens/login_screen.dart';
import 'package:venus_driver/view/home/presentation/screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  _goNext() async {
    if (CacheHelper.getData(key: 'login') == true) {
      MagicRouter.navigateAndPopAll(const HomeScreen());
    } else {
      MagicRouter.navigateAndPopAll(const LoginScreen());
    }
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/space.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SizedBox(
          child: Image.asset("assets/images/white_logo.png"),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

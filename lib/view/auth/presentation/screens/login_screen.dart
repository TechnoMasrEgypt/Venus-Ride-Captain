// ignore_for_file: missing_required_param, use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/view/auth/presentation/cubit/login/login_cubit.dart';
import 'package:venus_driver/view/auth/presentation/widget/login_screen_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    CacheHelper.saveData(key: 'lang', value: 'en');
    try{
      FirebaseMessaging.instance
          .getToken()
          .then((value) => CacheHelper.saveData(key: 'token', value: value))
          .toString();
    }catch(e){

    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const Scaffold(
          backgroundColor: Colors.white, body: LoginScreenBody()),
    );
  }
}

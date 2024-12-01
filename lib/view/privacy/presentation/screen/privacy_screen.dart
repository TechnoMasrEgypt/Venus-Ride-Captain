import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/view/privacy/presentation/cubit/privacy_cubit.dart';
import 'package:venus_driver/view/privacy/presentation/widget/privacy_body.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrivacyCubit()..getPrivacy(),
      child: const Scaffold(backgroundColor: Colors.white, body: PrivacyBody()),
    );
  }
}

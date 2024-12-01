import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/view/auth/presentation/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:venus_driver/view/auth/presentation/widget/verification_code_body.dart';

class VerificationCodeScreen extends StatelessWidget {
  const VerificationCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhoneAuthCubit(),
      child: const Scaffold(
          backgroundColor: Colors.white, body: VerificationCodeBody()),
    );
  }
}

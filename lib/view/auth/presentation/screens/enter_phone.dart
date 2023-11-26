// ignore_for_file: missing_required_param, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/view/auth/presentation/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:venus_driver/view/auth/presentation/widget/enter_phone_body.dart';

class EnterPhoneScreen extends StatelessWidget {
  const EnterPhoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhoneAuthCubit(),
      child:
          const Scaffold(backgroundColor: Colors.white, body: EnterPhoneBody()),
    );
  }
}

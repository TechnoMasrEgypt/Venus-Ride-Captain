// ignore_for_file: missing_required_param, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/view/update_password/presentation/cubit/update_password_cubit.dart';
import 'package:venus_driver/view/update_password/presentation/widget/update_password_body.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdatePasswordCubit(),
      child: const Scaffold(
          backgroundColor: Colors.white, body: UpdatePasswordBody()),
    );
  }
}

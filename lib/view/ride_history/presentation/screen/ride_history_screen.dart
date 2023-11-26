// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/view/ride_history/presentation/cubit/ride_history_cubit.dart';
import 'package:venus_driver/view/ride_history/presentation/widget/ride_history_body.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RideHistoryCubit()..getRideHistory(),
      child: const Scaffold(
          backgroundColor: Colors.white, body: RideHistoryBody()),
    );
  }
}

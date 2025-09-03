import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/view/chat/presentations/views/widgets/chat_view_body.dart';

import '../../../../global_variables.dart';
import '../views_models/chat_cubit/cubit/chat_cubit.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key, required this.driverName, required this.rideId});
  final String driverName;
  final int rideId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          driverName,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: kDeepBlue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
          child: BlocProvider(
        create: (context) => ChatCubit()..getAllMessages(rideId: rideId),
        child: ChatViewBody(rideId: rideId),
      )),
    );
  }
}

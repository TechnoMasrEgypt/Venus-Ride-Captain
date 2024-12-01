import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/view/profile/presentation/cubit/profile_cubit.dart';
import 'package:venus_driver/view/profile/presentation/widget/profile_body.dart';

import 'package:venus_driver/widgets/loading_indicator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit()..getProfileDetails(),
      child: Scaffold(
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return state is GetProfileDetailsLoading
                ? const LoadingIndicator()
                : const ProfileBody();
          },
        ),
      ),
    );
  }
}

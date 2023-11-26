// ignore_for_file: missing_required_param

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/view/update_password/presentation/screen/update_password_screen.dart';
import 'package:venus_driver/view/profile/presentation/cubit/profile_cubit.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';
import 'package:venus_driver/widgets/custom_text_field_profile.dart';
import 'package:venus_driver/widgets/loading_indicator.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = ProfileCubit.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return state is EditProfileDetailsLoading
                    ? const LoadingIndicator()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 32.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              customIconBack(
                                icon: Localizations.localeOf(context)
                                            .languageCode ==
                                        'en'
                                    ? Icons.keyboard_arrow_right
                                    : Icons.keyboard_arrow_left,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          InkWell(
                            onTap: () async {
                              final image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              cubit.photo = image!;
                              await cubit.editImageProfile();
                              // buildGetImageBottomSheet(context)
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topRight,
                              children: [
                                cubit.photo == null
                                    ? cubit.driverData?.photo == null
                                        ? Container(
                                            width: 90.w,
                                            height: 90.w,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.asset(
                                                'assets/images/user_icon.png'))
                                        : Container(
                                            width: 90.w,
                                            height: 90.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(
                                                      cubit.driverData!.photo
                                                      // CacheHelper.getData(
                                                      //     key: 'photo')),
                                                      )),
                                            ))
                                    : Container(
                                        width: 90.w,
                                        height: 90.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(
                                                File(cubit.photo!.path)),
                                          ),
                                        ),
                                      ),
                                Positioned(
                                  top: -6.h,
                                  right: -1.w,
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: 25.w,
                                        width: 25.w,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        // child: Icon(Icons.edit_outlined),
                                      ),
                                      Positioned(
                                          bottom: 5.h,
                                          left: 5.w,
                                          child: Icon(
                                            Icons.edit_outlined,
                                            size: 25.r,
                                            // color: kDeepBlue
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            cubit.driverData!.name,
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          Card(
                            elevation: 4,
                            shadowColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      MagicRouter.navigateTo(
                                          const UpdatePasswordScreen());
                                    },
                                    child: buildTextFieldOfEditProfile(
                                      hint: 'Change password',
                                      icon: Icons.lock,
                                      enabled: false,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60.h,
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

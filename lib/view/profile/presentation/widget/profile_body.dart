// ignore_for_file: missing_required_param

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:venus_driver/extensions/extensions.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/view/profile/presentation/widget/popupmessgae.dart';
import 'package:venus_driver/view/update_password/presentation/screen/update_password_screen.dart';
import 'package:venus_driver/view/profile/presentation/cubit/profile_cubit.dart';
import 'package:venus_driver/widgets/custom_auth_button.dart';
import 'package:venus_driver/widgets/custom_icon_back.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';
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
                              Spacer(),
                              Text('Edit profile',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium),
                              Spacer(),
                              SizedBox(
                                width: 20,
                              ),
                              customIconBack(
                                icon: Localizations.localeOf(context)
                                            .languageCode ==
                                        'en'
                                    ? Icons.keyboard_arrow_right
                                    : Icons.keyboard_arrow_left,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              /*  */
                            ],
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          InkWell(
                            onTap: () async {
                              final image = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);
                              cubit.changeimage(image);
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topRight,
                              children: [
                                cubit.photo == null
                                    ? cubit.driverData?.photo == null
                                        ? InkWell(
                                            child: Container(
                                                width: 90.w,
                                                height: 90.w,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.asset(
                                                    'assets/images/user_icon.png')),
                                          )
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
                                          )),
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
                            height: 20.h,
                          ),
                          SizedBox(
                            width: 260.w,
                            child: Text(
                                'In this page You can only chage the password  and your profile image so be '),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Card(
                            elevation: 4,
                            shadowColor: Colors.blueGrey,
                            color: kDeepBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              //padding: const EdgeInsets.all(18.0),
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
                                      child: Container(
                                        width: 200,
                                        height: 40,
                                        // color: kDeepBlue,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.lock,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('Change password',
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    color: Colors.white,
                                                    fontFamily: 'Cairo',
                                                    fontWeight:
                                                        FontWeight.w700))
                                          ],
                                        ),
                                      )

                                      /*  buildTextFieldOfEditProfile(
                                      hint: 'Change password',
                                      icon: Icons.lock,
                                      enabled: false,
                                    ),*/
                                      ),
                                  SizedBox(
                                    height: 10.h,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Card(
                            elevation: 4,
                            shadowColor: Colors.blueGrey,
                            color: kDeepBlue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5),
                              //padding: const EdgeInsets.all(18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  InkWell(
                                      onTap: () {
                                        showUpdateProfileDialog(context, cubit);
                                      },
                                      child: Container(
                                        width: 200,
                                        height: 40,
                                        // color: kDeepBlue,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.upload,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text('updateprofile',
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    color: Colors.white,
                                                    fontFamily: 'Cairo',
                                                    fontWeight:
                                                        FontWeight.w700))
                                          ],
                                        ),
                                      )

                                      /*  buildTextFieldOfEditProfile(
                                      hint: 'Change password',
                                      icon: Icons.lock,
                                      enabled: false,
                                    ),*/
                                      ),
                                  SizedBox(
                                    height: 10.h,
                                  )
                                ],
                              ),
                            ),
                          ),

                          /*   customAuthButton(
                              color: kDeepBlue,
                              text: 'updateprofile',
                              onTap: () async {
                                showUpdateProfileDialog(context, cubit);
                              },
                              hight: 60,
                              width: 200.w)*/
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

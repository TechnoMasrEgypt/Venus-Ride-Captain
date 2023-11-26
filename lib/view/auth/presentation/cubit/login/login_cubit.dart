import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/view/auth/data/repo/login_repo.dart';
import 'package:venus_driver/view/home/presentation/screen/home_screen.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final loginRepo = LoginRepo();

  static LoginCubit of(context) => BlocProvider.of(context);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  Future login() async {
    // if (emailController.text.contains('@') ||
    //     emailController.text.length < 10) {
    //   showSnackBar(
    //     LocaleKeys.validEmailAddress.tr(),
    //   );
    //   return;
    // }

    if (passwordController.text.length < 8) {
      showSnackBar(
        LocaleKeys.validPassword.tr(),
      );
      return;
    }
    emit(LoginLoading());
    final res =
        await loginRepo.login(emailController.text, passwordController.text);
    res.fold(
      (err) async {
        await showSnackBar(CacheHelper.getData(key: 'lang') == 'en'
            ? err
            : 'Please check your data again, you have an error in the data');
        emit(LoginInitial());
      },
      (res) async {
        emit(LoginInitial());
        await CacheHelper.saveData(key: 'id', value: res.data.id);
        await CacheHelper.saveData(key: 'user', value: res.data.user);
        await CacheHelper.saveData(key: 'name', value: res.data.name);
        await CacheHelper.saveData(key: 'photo', value: res.data.photo);
        await CacheHelper.saveData(key: 'email', value: res.data.email);
        await CacheHelper.saveData(key: 'login', value: true);
        MagicRouter.navigateAndPopAll(const HomeScreen());
      },
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venus_driver/router/router.dart';
import 'package:venus_driver/translations/locale_keys.g.dart';
import 'package:venus_driver/view/auth/presentation/screens/login_screen.dart';
import 'package:venus_driver/view/update_password/data/repo/update_password_repo.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

part 'update_password_state.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordState> {
  UpdatePasswordCubit() : super(UpdatePasswordInitial());
  final updatePasswordRepo = UpdatePasswordRepo();

  static UpdatePasswordCubit of(context) => BlocProvider.of(context);

  final passwordController = TextEditingController();
  final passwordCoController = TextEditingController();

  Future updatePassword() async {
    if (passwordController.text != passwordCoController.text) {
      showSnackBar(
        LocaleKeys.similarPassword.tr(),
      );
      return;
    }

    emit(UpdatePasswordLoading());
    final res = await updatePasswordRepo.updatePassword(
        passwordController.text, passwordCoController.text);
    res.fold(
      (err) async {
        await showSnackBar(err);
        emit(UpdatePasswordInitial());
      },
      (res) async {
        emit(UpdatePasswordInitial());
        MagicRouter.navigateAndPopAll(const LoginScreen());
      },
    );
  }
}

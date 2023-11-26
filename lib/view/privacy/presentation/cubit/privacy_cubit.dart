import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:venus_driver/view/privacy/data/model/privacy_model.dart';
import 'package:venus_driver/view/privacy/data/repo/privacy_repo.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

part 'privacy_state.dart';

class PrivacyCubit extends Cubit<PrivacyState> {
  PrivacyCubit() : super(PrivacyInitial());
  final privacyRepo = PrivacyRepo();
  PrivacyData? privacyData;

  static PrivacyCubit of(context) => BlocProvider.of(context);

  Future getPrivacy() async {
    emit(PrivacyLoading());
    final res = await privacyRepo.getPrivacy();
    res.fold(
      (err) {
        showSnackBar(err);
        emit(PrivacyInitial());
      },
      (res) async {
        privacyData = res.data;
        emit(PrivacyInitial());
      },
    );
  }
}

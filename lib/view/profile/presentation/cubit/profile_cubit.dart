import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/models/driver_model.dart';
import 'package:venus_driver/services/location_service.dart';
import 'package:venus_driver/view/profile/data/profile_repo.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit of(context) => BlocProvider.of(context);
  final profileRepo = ProfileRepo();
  DriverData? driverData;
  final passwordConfirmationController = TextEditingController();
  XFile? photo;

  Future getProfileDetails() async {
    emit(GetProfileDetailsLoading());
    final res = await profileRepo.getProfileDetails();

    res.fold(
      (err) {
        showSnackBar(err);
        emit(ProfileInitial());
      },
      (res) async {
        driverData = res.data;
        emit(GetProfileDetailsLoaded());
      },
    );
  }

  void changeimage(XFile? image) {
    emit(changeimageintial());
    photo = image;
    emit(changeimagefone());
  }

  Future driverStatus(status) async {
    emit(StatusLoaded());
    final res = await profileRepo.driverStatus(status);
    res.fold(
      (err) async {
        emit(StatusLoading());
      },
      (res) async {
        driverData = res.data;
        emit(StatusLoading());
      },
    );
  }

  Future goOnline() async {
    await driverStatus('1');
    await LocationService.instance.startTracking();
  }

  Future goOffline() async {
    await driverStatus('0');
    await assetsAudioPlayer.stop();
    await LocationService.instance.stopTracking();
  }

  Future editImageProfile() async {
    emit(EditProfileDetailsLoading());
    final res = await profileRepo.editImageProfile(photo!);

    res.fold(
      (err) {
        showSnackBar(err);
        emit(ProfileInitial());
      },
      (res) async {
        await CacheHelper.saveData(key: 'photo', value: res.data.photo);
        showSnackBar('تم تحديث الصوره الشخصيه');
        emit(ProfileInitial());
      },
    );
  }
}

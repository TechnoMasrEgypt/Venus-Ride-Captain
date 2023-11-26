import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:venus_driver/view/ride_history/data/model/ride_history_model.dart';
import 'package:venus_driver/view/ride_history/data/repo/ride_history_repo.dart';
import 'package:venus_driver/widgets/custom_snackbar.dart';

part 'ride_history_state.dart';

class RideHistoryCubit extends Cubit<RideHistoryState> {
  RideHistoryCubit() : super(RideHistoryInitial());
  final rideHistoryRepo = RideHistoryRepo();

  static RideHistoryCubit of(context) => BlocProvider.of(context);

  List<RideHistoryData> listOfRideHistoryData = [];

  Future getRideHistory() async {
    emit(RideHistoryLoading());
    final res = await rideHistoryRepo.getRideHistory();
    res.fold(
      (err) {
        showSnackBar(err);
        emit(RideHistoryInitial());
      },
      (res) async {
        listOfRideHistoryData = res.data;
        emit(RideHistoryInitial());
      },
    );
  }
}

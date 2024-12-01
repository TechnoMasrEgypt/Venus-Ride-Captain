import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:venus_driver/global_variables.dart';
import 'package:venus_driver/view/receipt/data/model/receipt_model.dart';

part 'receipt_state.dart';

class ReceiptCubit extends Cubit<ReceiptState> {
  ReceiptCubit() : super(ReceiptInitial());
  ReceiptDetails? receiptDetails;
  static ReceiptCubit of(context) => BlocProvider.of(context);
  void getReceiptRide() async {
    emit(GetReceiptLoading());
    refReceiptRide.onValue.listen((DatabaseEvent event) {
      emit(GetReceiptRide());
      if (event.snapshot.value == null) {
        emit(DoneReceiptRide());
        return;
      } else {
        final Map data = event.snapshot.value as Map;

        String time = data['Time'].toString();
        String total = data['Total'].toString();
        String startTime = data['startTime'].toString();
        String cost = data['cost'].toString();
        String distance = data['distance'].toString();
        String driverId = data['driverId'].toString();
        String endRide = data['endRide'].toString();
        String endTime = data['endTime'].toString();
        String fee = data['fee'].toString();
        String id = data['id'].toString();
        String startRide = data['startRide'].toString();
        String late = data['late'].toString();
        String discount = data['discount'].toString();
        receiptDetails = ReceiptDetails(
            time: time,
            total: total,
            startTime: startTime,
            cost: cost,
            distance: distance,
            driverId: driverId,
            endRide: endRide,
            endTime: endTime,
            fee: fee,
            id: id,
            startRide: startRide,
            late: late,
            discount: discount);
        emit(DoneReceiptRide());
      }
    });
  }
}

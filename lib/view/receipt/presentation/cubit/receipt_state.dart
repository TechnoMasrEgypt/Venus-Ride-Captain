part of 'receipt_cubit.dart';

abstract class ReceiptState extends Equatable {
  const ReceiptState();

  @override
  List<Object> get props => [];
}

class ReceiptInitial extends ReceiptState {}

class GetReceiptLoading extends ReceiptState {}

class GetReceiptRide extends ReceiptState {}

class DoneReceiptRide extends ReceiptState {}

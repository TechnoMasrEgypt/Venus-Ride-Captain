part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class GetRequest extends HomeState {}

class RequestLoading extends HomeState {}

class DoneRequest extends HomeState {}

class LocationInitial extends HomeState {}

class LocationLoaded extends HomeState {}

class LocationLoading extends HomeState {}

class Offline extends HomeState {}

class Online extends HomeState {}
class UpdateLocationSuccess extends HomeState {}
class UpdateLocationFailed extends HomeState {}
 
class CheckOngoingRideLoading extends HomeState {}
class CheckOngoingRideNone extends HomeState {}
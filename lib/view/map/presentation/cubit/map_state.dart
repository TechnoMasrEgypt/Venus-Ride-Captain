part of 'map_cubit.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class RideDoneLoading extends MapState {}

class PolyLoaded extends MapState {}

class PolyLoading extends MapState {}

class LocationInitial extends MapState {}

class LocationLoaded extends MapState {}

class LocationLoading extends MapState {}

class CancleLoaded extends MapState {}

class CancleLoading extends MapState {}

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
 
// ─── [NEW] LocationUpdated ───────────────────────────────────────────────────
// Emitted on every position stream tick so the map redraws the captain marker.
class LocationUpdated extends MapState {}
 
// ─── [NEW] DirectionUpdated ──────────────────────────────────────────────────
// Emitted every 10 seconds with fresh distance and ETA for the info card.
class DirectionUpdated extends MapState {
  final String distance; // e.g. "1.2 km"
  final String duration; // e.g. "4 mins"
  DirectionUpdated({required this.distance, required this.duration});
}
 
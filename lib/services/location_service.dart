import 'dart:async';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:venus_driver/appStorage/local_cache_helper.dart';
import 'package:venus_driver/global_variables.dart';

/// Singleton that owns the Geolocator stream and writes the driver's
/// location to Firebase RTDB.
///
/// Upload throttle:
///  - every 30 seconds, AND/OR
///  - when the driver has moved ≥ 50 metres
///
/// The Geolocator stream itself uses distanceFilter: 4 m to stay in
/// sync with the backend 4 km radius logic.
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  // ── Public state ─────────────────────────────────────────────────────────

  /// Nullable — callers must null-check before reading.
  Position? currentPosition;

  /// Callback called whenever the driver's location successfully pushes to Firebase
  void Function(double lat, double lng)? onLocationUpdated;

  // ── Private ──────────────────────────────────────────────────────────────

  StreamSubscription<Position>? _sub;
  DateTime? _lastUpload;

  // ── Config ───────────────────────────────────────────────────────────────

  static const _minUploadInterval = Duration(seconds: 30);
  static const _minUploadDistance =
      50.0; // metres — min movement to trigger a Firebase write
  static const _streamDistanceFilter =
      4; // metres — stream fires every 4m of movement (GPS sensitivity)
  // NOTE: completely unrelated to the backend's 4 km ride-request radius,
  //       which is a server-side filter on the coordinates we upload.
  static const _accuracy = LocationAccuracy.bestForNavigation;

  // ── Public API ───────────────────────────────────────────────────────────

  /// Start GPS tracking. Safe to call multiple times — no-op if already running.
  Future<void> startTracking() async {
    if (_sub != null) return;

    await _ensurePermission();

    // Seed immediately so the rest of the app never reads a null position.
    currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: _accuracy,
    );
    await _pushToFirebase(); // first upload right away

    _sub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: _accuracy,
        distanceFilter: _streamDistanceFilter,
      ),
    ).listen(_onPositionUpdate, onError: _onError);

    log('[LocationService] tracking started');
  }

  /// Stop GPS tracking entirely (driver offline / logged out).
  Future<void> stopTracking() async {
    await _sub?.cancel();
    _sub = null;
    _lastUpload = null;
    log('[LocationService] tracking stopped');
  }

  /// Pause GPS while app is in background.
  void pauseTracking() {
    _sub?.pause();
    log('[LocationService] tracking paused');
  }

  /// Resume GPS when app returns to foreground.
  void resumeTracking() {
    _sub?.resume();
    
    log('[LocationService] tracking resumed');
  }

  bool get isTracking => _sub != null;

  // ── Private helpers ──────────────────────────────────────────────────────

  void _onPositionUpdate(Position newPos) {
    final previousPosition = currentPosition; // snapshot BEFORE mutating
    currentPosition = newPos;
    log('[LocationService] 📍 lat: ${newPos.latitude}, lng: ${newPos.longitude}, accuracy: ${newPos.accuracy.toStringAsFixed(1)}m, speed: ${newPos.speed.toStringAsFixed(1)}m/s');
    _maybeUpload(newPos, previousPosition);
  }

  void _onError(Object e) {
    log('[LocationService] stream error: $e');
  }

  void _maybeUpload(Position newPos, Position? previousPosition) {
    final now = DateTime.now();

    final timePassed = _lastUpload == null ||
        now.difference(_lastUpload!) >= _minUploadInterval;

    final distanceMoved = (previousPosition == null)
        ? double.infinity
        : Geolocator.distanceBetween(
            previousPosition.latitude,
            previousPosition.longitude,
            newPos.latitude,
            newPos.longitude,
          );

    if (timePassed || distanceMoved >= _minUploadDistance) {
      _pushToFirebase();
      // HelperMethods.postApi(endPoint: dio_string.updatelocation, data: {
      //   "lat": currentPosition!.latitude,
      //   "lng": currentPosition!.longitude,
      // });
      _lastUpload = now;
    }
  }

  Future<void> _pushToFirebase() async {
    final pos = currentPosition;
    if (pos == null) return;
    try {
      await refDriversInfo.set({
        'name': CacheHelper.getData(key: 'name'),
        'id': CacheHelper.getData(key: 'id'),
        'timestamp': pos.timestamp.toString(),
        'location': {
          'lat': pos.latitude,
          'lng': pos.longitude,
          'accuracy': pos.accuracy,
          'altitude': pos.altitude,
          'speed': pos.speed,
          'speedAccuracy': pos.speedAccuracy,
          'heading': pos.heading,
        },
      });
      // Notify listeners (like HomeCubit) to update the backend server
      onLocationUpdated?.call(pos.latitude, pos.longitude);
    } catch (e) {
      log('[LocationService] Firebase write error: $e');
    }
  }

  Future<void> _ensurePermission() async {
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever) {
      throw Exception(
          '[LocationService] Location permission permanently denied');
    }
  }
}

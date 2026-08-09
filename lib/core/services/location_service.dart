class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);
}

abstract class LocationService {
  Future<LatLng?> getCurrentLocation();
  Future<bool> isLocationServiceEnabled();
  Future<String?> getAddressFromLatLng(LatLng latLng);
}

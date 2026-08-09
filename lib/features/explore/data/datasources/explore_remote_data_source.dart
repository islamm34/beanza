abstract class ExploreRemoteDataSource {
  /// Gets cafes with filters
  Future<List<Map<String, dynamic>>> getCafes({
    String? searchQuery,
    String? categoryFilter,
    double? maxDistance,
  });

  /// Gets cafe details
  Future<Map<String, dynamic>> getCafeDetails(String cafeId);

  /// Gets cafe reviews
  Future<List<Map<String, dynamic>>> getCafeReviews(String cafeId);
}

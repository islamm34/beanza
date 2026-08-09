abstract class DigitalMenuRemoteDataSource {
  /// Gets digital menu for a cafe
  Future<Map<String, dynamic>> getDigitalMenu(String cafeId);

  /// Gets menu categories
  Future<List<Map<String, dynamic>>> getMenuCategories(String cafeId);

  /// Searches menu items
  Future<List<Map<String, dynamic>>> searchMenuItems(String cafeId, String query);
}

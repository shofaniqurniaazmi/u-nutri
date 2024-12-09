import 'package:test/test.dart';
import 'package:nutritrack/presentation/pages/archive.dart';

// Fungsi untuk memeriksa apakah URL valid
bool _isValidUrl(String url) {
  final uri = Uri.tryParse(url);
  return uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
}

void main() {
  final archiveData = ArchiveData();

  test('Create item with two valid URLs', () async {
    print("Running Create item with two valid URLs test");

    // URL yang valid
    const url1 = "https://storyblok-cdn.ef.com/f/60990/1200x666/13ee7171e6/makanan-tradisional-indonesia.png";
    const url2 = "https://storyblok-cdn.ef.com/f/60990/1200x666/13ee7171e6/makanan-tradisional-indonesia2.png"; // URL tambahan

    // Validasi URL pertama dan kedua
    if (_isValidUrl(url1) && _isValidUrl(url2)) {
      print("Both URLs are valid, proceeding with creation.");
      await archiveData.createItem(url1, url2); // Menyertakan dua URL
      final items = await archiveData.readItems();
      expect(items.isNotEmpty, true);
      print("Test passed! Items are not empty.");
    } else {
      print("One or both URLs are invalid.");
      throw ArgumentError('Invalid URL');
    }
  });

  test('Read item', () async {
    print("Running Read item test");

    final items = await archiveData.readItems();
    expect(items.isNotEmpty, true); // Memastikan bahwa item yang dibaca tidak kosong
    print("Test passed! Items are successfully read.");
  });

  test('Update item with two valid URLs', () async {
    print("Running Update item with two valid URLs test");

    final items = await archiveData.readItems();
    if (items.isNotEmpty) {
      final firstItemId = items.first['id'];
      const url1 = "https://storyblok-cdn.ef.com/f/60990/1200x666/13ee7171e6/makanan-tradisional-indonesia.png";
      const url2 = "https://storyblok-cdn.ef.com/f/60990/1200x666/13ee7171e6/makanan-tradisional-indonesia2.png"; // URL kedua

      // Memperbarui item dengan dua URL
      await archiveData.updateItem(firstItemId, url1, url2);
      final updatedItems = await archiveData.readItems();
      final updatedItem = updatedItems.firstWhere((item) => item['id'] == firstItemId);

      expect(updatedItem['imageUrl'], url1); // Memastikan URL pertama diperbarui
      expect(updatedItem['imageUrl2'], url2); // Memastikan URL kedua disertakan
      print("Test passed! Item updated with two URLs.");
    }
  });

  test('Delete item', () async {
    print("Running Delete item test");

    final items = await archiveData.readItems();
    if (items.isNotEmpty) {
      final firstItemId = items.first['id'];
      await archiveData.deleteItem(firstItemId);
      final updatedItems = await archiveData.readItems();
      expect(updatedItems.where((item) => item['id'] == firstItemId).isEmpty, true);
      print("Test passed! Item successfully deleted.");
    }
  });
}
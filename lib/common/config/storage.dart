import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = const FlutterSecureStorage();

  // Menyimpan userId
  Future<void> saveUserId(String userId) async {
    await storage.write(key: 'userId', value: userId);
  }

  // Mengambil userId
  Future<String?> getUserId() async {
    return await storage.read(key: 'userId');
  }

  // Menghapus userId (misalnya saat logout)
  Future<void> deleteUserId() async {
    await storage.delete(key: 'userId');
  }

  // Menyimpan data archive
  Future<void> saveArchive(String archiveData) async {
    await storage.write(key: 'archive', value: archiveData);
  }

  // Mengambil data archive
  Future<String?> getArchive() async {
    return await storage.read(key: 'archive');
  }

  // Menghapus data archive
  Future<void> deleteArchive() async {
    await storage.delete(key: 'archive');
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nutritrack/common/assets/assets.dart';
import 'package:nutritrack/common/config/storage.dart';
import 'package:nutritrack/service/firebase/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Archive extends StatefulWidget {
  const Archive({super.key});

  @override
  State<Archive> createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  final StorageFirebaseService _storageFirebaseService = StorageFirebaseService();
  List<Map<String, dynamic>>? archiveDataFromDatabase;

  Future<void> _getArchiveData() async {
    String? userId = await SecureStorage().getUserId();
    List<Map<String, dynamic>> data =
        await _storageFirebaseService.getAllArchives(userId!);
    setState(() {
      archiveDataFromDatabase = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _getArchiveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: const SizedBox(),
      ),
      body: archiveDataFromDatabase == null
          ? const Center(child: CircularProgressIndicator())
          : archiveDataFromDatabase!.isEmpty
              ? const Center(child: Text('No archive data available'))
              : ListView.builder(
                  itemCount: archiveDataFromDatabase!.length,
                  itemBuilder: (context, index) {
                    return ArchiveItem(archiveDataFromDatabase![index]);
                  },
                ),
    );
  }
}

class ArchiveItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const ArchiveItem(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    // Split time and date
    final timeParts = data['created_at'].toString().split(' ');
    final time = timeParts[0];
    final date = timeParts.length > 1 ? timeParts[1] : '';

    return InkWell(
      onTap: () {
        print(data['image_url']);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              content: data['content'] ?? '',
              date: date,
              time: time,
              image: data['image_url'] ?? '',
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  data['image_url'] ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('Image not available'));
                  },
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                if (date.isNotEmpty)
                  Text(
                    date,
                    style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              data['content'] ?? '',
              style: const TextStyle(
                fontSize: 16.0,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String content;
  final String date;
  final String time;
  final String image;

  const DetailPage({super.key, 
    required this.content,
    required this.date,
    required this.time,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Set the background color of the app bar
        elevation: 0, // Remove the shadow
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png', // Path to your logo image
            fit: BoxFit.contain,
            width: 40.0,
          ),
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min, // To avoid expanding the title
          children: [
            Text(
              'Nutri',
              style: TextStyle(
                color: Colors.purple, // Title text color for "Nutri"
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Text(
              'Track',
              style: TextStyle(
                color: Colors.green, // Title text color for "Track"
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
        centerTitle: true, // Center the title
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Text('Image not available'));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    time,
                    style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  if (date.isNotEmpty)
                    Text(
                      date,
                      style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(content),
            ],
          ),
        ),
      ),
    );
  }
}

class ArchiveData {
  final List<Map<String, dynamic>> _items = [];

  // Add item (Create)
  void addItem(String item) {
    _items.add({'id': DateTime.now().toString(), 'imageUrl': item});
  }

  // Remove item (Delete)
  bool removeItem(String item) {
    final index = _items.indexWhere((element) => element['imageUrl'] == item);
    if (index == -1) return false;
    _items.removeAt(index);
    return true;
  }

  // Get items (Read)
  List<Map<String, dynamic>> getItems() {
    return List.unmodifiable(_items);
  }

Future<void> createItem(String url1, String url2) async {
  final imageUrlPattern = RegExp(r'(https?:\/\/.*\.(?:png|jpg|jpeg|gif))');
  if (!imageUrlPattern.hasMatch(url1) || !imageUrlPattern.hasMatch(url2)) {
    throw ArgumentError("Invalid URL format.");
  }
  _items.add({
    'id': DateTime.now().toString(),
    'imageUrl1': url1,  // Menambahkan URL pertama
    'imageUrl2': url2   // Menambahkan URL kedua
  });
}

  // Read items
  Future<List<Map<String, dynamic>>> readItems() async {
    return List.unmodifiable(_items);
  }

 Future<void> updateItem(String id, String url1, String url2) async {
  final index = _items.indexWhere((item) => item['id'] == id);
  if (index != -1) {
    _items[index]['imageUrl'] = url1; // Update the first URL
    _items[index]['imageUrl2'] = url2; // Update the second URL (new field)
  }
}


  // Delete item by ID
  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item['id'] == id);
  }
}


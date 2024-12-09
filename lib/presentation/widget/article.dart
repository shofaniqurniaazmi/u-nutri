import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Article extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String link;

  const Article({super.key, 
    required this.imagePath,
    required this.title,
    required this.description,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Logika untuk mengunduh gambar atau data
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imagePath,
              width: double.infinity,
              height: 200.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              description,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            TextButton(
              onPressed: () async {
                final Uri url = Uri.parse(link);
                if (url.scheme == 'http' || url.scheme == 'https') {
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                } else {
                  throw 'Invalid URL format';
                }
              },
              child: const Text('Baca Selengkapnya'),
            ),
          ],
        ),
      ),
    );
  }
}

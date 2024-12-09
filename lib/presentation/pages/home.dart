import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nutritrack/common/assets/assets.dart';
import 'package:nutritrack/common/config/storage.dart';
import 'package:nutritrack/presentation/widget/article.dart';
import 'package:nutritrack/service/firebase/authentication_service.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthenticationService _firebaseAuth = AuthenticationService();
  Future<Map<String, dynamic>?>? _userProfileFuture;  // Make this nullable
  late Future<List<dynamic>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _newsFuture = fetchNews();
  }

  Future<List<dynamic>> fetchNews() async {
    const url =
        'https://newsdata.io/api/1/news?apikey=pub_512145b24e23ed26e817e4017220145129057&country=id&language=id&category=health';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'] as List<dynamic>;
    } else {
      throw Exception('Failed to load news');
    }
  }

  void _fetchUserProfile() async {
    final userId = await SecureStorage().getUserId();
    if (userId != null) {
      setState(() {
        _userProfileFuture = _firebaseAuth.getProfileUser(userId);
      });
    } else {
      setState(() {
        _userProfileFuture = Future.value(null); // Set it to null if no userId found
      });
    }
  }

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

      body: Stack(
        children: [
          // Background image
          Image.asset(
            coverImage, // Replace with your background image asset path
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
            top: 40.0, // Position the box from the top
            left: 20.0, // Position the box from the left
            right: 20.0, // Set the right padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FutureBuilder that waits for _userProfileFuture
                FutureBuilder<Map<String, dynamic>?>( 
                  future: _userProfileFuture,  // This can now be null
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return const Text('No profile data');
                    } else {
                      final profile = snapshot.data!;
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8.0,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 40.0,
                              color: Colors.purple,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              'Hello, ${profile['fullName']}!',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                    height: 20.0), // Space between the greeting box and news section
              ],
            ),
          ),
          Positioned(
            top: 200.0, // Adjusted to start below the greeting box
            left: 0.0,
            right: 0.0,
            bottom: 0.0,  // Extend the container to the bottom of the screen
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: FutureBuilder<List<dynamic>>(
                future: _newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData ||
                      snapshot.data == null ||
                      snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('No news available',
                            style: TextStyle(fontSize: 16.0, color: Colors.grey)));
                  } else {
                    final newsList = snapshot.data!;
                    final topNews = newsList.take(5).toList();
                    final otherNews = newsList.skip(5).take(5).toList();
                    return Column(
                      children: [
                        const SizedBox(height: 10.0),
                        const Text(
                          'Top News',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 150.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: topNews.length,
                            itemBuilder: (context, index) {
                              final newsItem = topNews[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: buildRecommendationCard(
                                  context,
                                  newsItem['title'] ?? 'No title',
                                  newsItem['image_url'] ?? '',
                                  newsItem['description'] ?? 'No description',
                                  newsItem['link']??'',
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'Other News',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        SizedBox(
                          height: 150.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: otherNews.length,
                            itemBuilder: (context, index) {
                              final newsItem = otherNews[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: buildRecommendationCard(
                                  context,
                                  newsItem['title'] ?? 'No title',
                                  newsItem['image_url'] ?? '',
                                  newsItem['description'] ?? 'No description',
                                  newsItem['link']??'',
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRecommendationCard(BuildContext context, String title,
      String imagePath, String description, String link) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Article(
              link: link,
              imagePath: imagePath,
              title: title,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        width: 150.0,
        height: 150.0, // Set a fixed height for consistency
        margin: const EdgeInsets.only(right: 10.0), // Space between cards
        child: Card(
          elevation: 4.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imagePath,
                height: 80.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.0,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class WordPressPage extends StatefulWidget {
  const WordPressPage({super.key});

  @override
  State<WordPressPage> createState() => _WordPressPageState();
}

class _WordPressPageState extends State<WordPressPage> {
  late Future<List<dynamic>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchLatestPosts();
  }

  Future<List<dynamic>> fetchLatestPosts() async {
    final response = await http.get(Uri.parse(
        'https://public-api.wordpress.com/wp/v2/sites/newonepieceweekly.wordpress.com/posts?per_page=3&orderby=date&order=desc'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
        backgroundColor: Colors.red[400],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No posts found'));
            } else {
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Image.network(
                    'https://favicone.com/newonepieceweekly.wordpress.com?s=100',
                    height: 100,
                  ),
                  ...snapshot.data!.map<Widget>((post) {
                    return Card(
                      color: const Color.fromARGB(255, 70, 10, 6),
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      child: ListTile(
                        title: Text(
                          post['title']['rendered']
                              .replaceAll(RegExp(r'&nbsp;'), ' '),
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                post['excerpt']['rendered']
                                    .replaceAll(RegExp(r'<[^>]*>'), ''),
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromARGB(255, 120, 10, 6)),
                              onPressed: () {
                                _launchURL(post['link']);
                              },
                              child: const Text('Leer más'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    Uri url2 = Uri.parse(url);
    if (!await launchUrl(url2)) {
      throw Exception('Could not launch $url2');
    }
  }
}

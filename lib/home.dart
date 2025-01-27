import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> data = [];
  @override
  void initState() {
    super.initState();
    fetchTodos();
  }

  Future<void> fetchTodos() async {
    try {
      final url = Uri.parse('https://dogapi.dog/api/v2/facts');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body is Map<String, dynamic> && body.containsKey('data')) {
          setState(() {
            data = List<Map<String, dynamic>>.from(body['data']);
          });
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      debugPrint('error banh');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final fetch = data[index];
          final attributes = fetch['attributes'] as Map<String, dynamic>?; 
          return ListTile(
            title: Text(attributes?['body']),
            subtitle: Text(fetch['id']),
          );
        },
      ),
    );
  }
}

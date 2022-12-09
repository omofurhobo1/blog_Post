import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:workshop/model/blog.dart';
import 'package:workshop/util/http_service.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  Future blogPost() async {
    final response = await http.get(Uri.parse(HttpService.blogs));
    List<Blog> blogsList = [];
    if (response.statusCode == 200) {
      var blogss = jsonDecode(response.body);
      // print(blogss['data']);
      for (var json in blogss['data']) {
        Blog blog = Blog.fromJson(json);
        print(blog.author);
        blogsList.add(blog);
      }
    } else {
      throw Exception('Failed to load blog');
    }
    return blogsList;
  }

  late Future blogpost;
  @override
  //Void @override
  void initState() {
    super.initState();
    blogpost = blogPost();
  }

  @override
  Widget build(BuildContext context) {
    // final blogProvider = Provider.of<BlogProvider>(context);
    //final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: blogpost,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {},
                    leading: ElevatedButton(
                        onPressed: () {}, child: const Text('Delete')),
                    title: Text(snapshot.data[index].title),
                    subtitle: Column(
                      children: [
                        Text(snapshot.data[index].body),
                        Text(snapshot.data[index].author)
                      ],
                    ),
                    trailing: ElevatedButton(
                        onPressed: () {}, child: const Text('Update')),
                  );
                },
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}

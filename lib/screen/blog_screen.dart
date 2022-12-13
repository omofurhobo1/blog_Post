import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../prefrence/user_prefrence.dart';
import '../provider/blog_provider.dart';
import '../provider/user_provider.dart';
import '../util/http_service.dart';
import 'edit_post.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  Future<User> getUser() => UserPreference().getUser();
  String username = "";
  String token = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser().then((value) {
      username = value.user;
      token = value.token;
      print(username);
    });
  }

  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Post'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: BlogProvider().getPost(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                reverse: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {},
                    leading: username == snapshot.data![index].author
                        ? ElevatedButton(
                            onPressed: () {
                              BlogProvider()
                                  .deletePost(snapshot.data![index].author,
                                      snapshot.data![index].id, token)
                                  .then((response) {
                                print(response);
                                HttpService()
                                    .showMessage(response["message"], context);
                                BlogProvider().getPost();
                              });
                            },
                            child: const Icon(Icons.delete))
                        : const SizedBox(),
                    title: Text(snapshot.data[index].title),
                    subtitle: Column(
                      children: [
                        Text(snapshot.data[index].body),
                        Text(
                          snapshot.data[index].author,
                          style: const TextStyle(color: Colors.amber),
                        )
                      ],
                    ),
                    trailing: username == snapshot.data![index].author
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditPost(
                                          id: snapshot.data![index].id,
                                          title: snapshot.data![index].title,
                                          body: snapshot.data![index].body)));
                            },
                            child: const Icon(Icons.edit))
                        : const SizedBox(),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

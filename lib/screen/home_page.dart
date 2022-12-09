import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workshop/provider/user_provider.dart';
import 'package:workshop/screen/blog_screen.dart';
import 'package:workshop/screen/login.dart';
import 'package:workshop/screen/post_screen.dart';

import '../prefrence/user_prefrence.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(actions: [
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Center(
              child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      UserPreference().removeUser();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const LoginScreen())));
                    },
                    child: const Icon(Icons.logout_rounded),
                  ))),
        ),
      ]),
      body: Center(
        child: Column(
          children: [
            Text("Welcome ${userProvider.changeName} "),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: ((context) {
                    return const BlogScreen();
                  })));
                },
                child: const Text('View blog Post'))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const PostScreen())));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

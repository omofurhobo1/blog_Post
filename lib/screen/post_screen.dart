import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/blog_provider.dart';
import '../provider/user_provider.dart';
import '../util/http_service.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController blogTitle = TextEditingController();
  final TextEditingController blogDescription = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final blogProvider = Provider.of<BlogProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Create A Post',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  controller: blogTitle,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Blog Title can not be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      filled: true,
                      // border: const OutlineInputBorder(),
                      label: Row(
                        children: const [Text("Blog Title "), Text("*")],
                      ),
                      hintText: "enter blod title"),
                ),
              ),
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: TextFormField(
                  controller: blogDescription,
                  maxLines: 4,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Blog Description can not be empty";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    // border: const OutlineInputBorder(),
                    filled: true,
                    // fillColor: const Color.fromARGB(201, 244, 241, 241),
                    label: Row(
                      children: const [Text("Blog Description "), Text("*")],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      blogProvider
                          .savePost(blogTitle.text, blogDescription.text,
                              userProvider.changeName, userProvider.token)
                          .then((response) {
                        HttpService().showMessage(response['message'], context);
                        //  clearForm();
                      });
                    }
                  },
                  child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }

  void clearForm() {
    blogTitle.clear();
    blogDescription.clear();
  }
}
